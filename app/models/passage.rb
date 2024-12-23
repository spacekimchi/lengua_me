# == Schema Information
#
# Table name: passages
#
#  id            :uuid             not null, primary key
#  position      :integer          not null
#  search_text   :text             default("")
#  title         :text             default("")
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  difficulty_id :uuid             not null
#
# Indexes
#
#  index_passages_on_difficulty_id               (difficulty_id)
#  index_passages_on_difficulty_id_and_position  (difficulty_id,position) UNIQUE
#  index_passages_on_search_text_trgm            (search_text) USING gin
#
# Foreign Keys
#
#  fk_rails_...  (difficulty_id => difficulties.id)
#
class Passage < ApplicationRecord
  include PgSearch::Model
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
  scope :by_difficulty, ->(difficulty) { where(difficulty: difficulty) }
  scope :with_user_progress, ->(user) {
    return all unless user

    left_outer_joins(:passage_progresses)
      .where(passage_progresses: { user_id: [user.id, nil] })
  }

  # Validation to ensure position uniqueness within a difficulty
  validates :position, uniqueness: { scope: :difficulty_id }, allow_nil: false

  # Callback to set position before creation
  before_create :set_position

  def translate(language:)
    PassageTranslatorService.new(sentences: sentences.pluck(:content, :id), language: language).call
  end

  def sentences_to_speech
    sentences.each do |sentence|
      sentence.generate_audio
    end
  end

  def next_passage
    difficulty.passages.ordered.where("position > ?", position).first
  end

  def previous_passage
    difficulty.passages.ordered.where("position < ?", position).last
  end

  private

  def set_position
    # Find the maximum position within the same difficulty
    max_position = difficulty.passages.maximum(:position) || 0
    self.position = max_position + 1
  end
end
