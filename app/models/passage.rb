# == Schema Information
#
# Table name: passages
#
#  id            :uuid             not null, primary key
#  category      :integer          default("unassigned")
#  position      :integer          not null
#  title         :text             default("")
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  difficulty_id :uuid             not null
#
# Indexes
#
#  index_passages_on_difficulty_id  (difficulty_id)
#  index_passages_on_title_trgm     (title) USING gin
#
# Foreign Keys
#
#  fk_rails_...  (difficulty_id => difficulties.id)
#
class Passage < ApplicationRecord
  include PgSearch::Model

  enum :category, [:unassigned, :short_stories, :conversations], default: :unassigned

  belongs_to :difficulty

  has_many :sentences, dependent: :destroy
  has_many :passage_progresses, dependent: :destroy

  pg_search_scope :search_by_position_and_title,
                  against: [:position, :title],
                  using: {
                    tsearch: {
                      prefix: true,
                      any_word: true,
                      dictionary: 'simple'
                    },
                    trigram: {}
                  },
                  ignoring: :accents

  # ILIKE '%text%'-Style Search Scope
  scope :search_like, ->(query) {
    return all if query.blank?

    sanitized_query = "%#{sanitize_sql_like(query)}%"

    where("CAST(position AS TEXT) || '. ' || title ILIKE :q", q: sanitized_query)
  }
  scope :ordered, -> { order(:position) }
  scope :ordered_by_difficulty, -> {
    order('difficulties.level ASC')
  }
  scope :ordered_by_difficulty_and_position, -> {
    order('difficulties.level ASC, passages.position ASC')
  }
  scope :by_difficulty, -> (difficulty) { where(difficulty: difficulty) }
  scope :by_category, -> (category) { where(category: category) }
  scope :with_user_progress, -> (user) {
    return all unless user

    left_outer_joins(:passage_progresses)
      .where(passage_progresses: { user_id: [user.id, nil] })
  }

  # Validation to ensure position uniqueness within a difficulty
  validates :position, uniqueness: { scope: :category }, allow_nil: false

  # Callback to set position before creation
  before_create :set_position

  def self.category_image(category)
    case category
    when 1
      '/images/short_stories.png'
    when 2
      '/images/conversations.png'
    else
      '/images/ruby.png'
    end
  end

  def self.translated_category(category)
    case category
    when 1, "short_stories"
      I18n.t('passages.short_stories')
    when 2, "conversations"
      I18n.t('passages.conversations')
    else
      "Uncategorized"
    end
  end

  def self.passages_without_any_translations
    # 1) Find the corresponding Language records for your target names:
    target_languages = Language.supported_languages

    # 2) Get all passages that do NOT have any SentenceTranslations
    #    for any of the above languages:
    Passage
      .left_joins(sentences: :translations)
      .where(sentences: { id: Sentence.select(:id) })  # ensure we only consider passages that actually have sentences
      .group("passages.id")
      .having("SUM(CASE WHEN sentence_translations.language_id IN (?) THEN 1 ELSE 0 END) = 0", target_languages.ids)
      .distinct
  end

  def self.with_some_translations
    target_languages = Language.supported_languages

    Passage
      .joins(sentences: :translations)
      .where(sentence_translations: { language_id: target_languages })
      .group("passages.id")
    # "some but not all" means > 0 and < target_languages.size
      .having(
        "COUNT(DISTINCT sentence_translations.language_id) > 0
     AND COUNT(DISTINCT sentence_translations.language_id) < ?",
     target_languages.size
      )
        .distinct
  end

  def self.passages_with_all_translations
    target_languages = Language.supported_languages

    Passage
      .joins(sentences: :translations)
      .where(sentence_translations: { language_id: target_languages })
      .group("passages.id")
      .having("COUNT(DISTINCT sentence_translations.language_id) = ?", target_languages.size)
      .distinct
  end

  def translate(language:)
    PassageTranslatorService.new(sentences: sentences.pluck(:content, :id), language: language).call
  end

  def sentences_to_speech
    sentences.each do |sentence|
      sentence.generate_audio
    end
  end

  def next_passage
    Passage.by_category(category).ordered.where("position > ?", position).first
  end

  def previous_passage
    Passage.by_category(category).ordered.where("position < ?", position).last
  end

  private

  def set_position
    # Find the maximum position within the same difficulty
    max_position = Passage.by_category(category).maximum(:position) || 0
    self.position = max_position + 1
  end
end
