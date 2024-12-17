# == Schema Information
#
# Table name: passages
#
#  id            :uuid             not null, primary key
#  title         :text             default("")
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  difficulty_id :uuid             not null
#
# Indexes
#
#  index_passages_on_difficulty_id  (difficulty_id)
#
# Foreign Keys
#
#  fk_rails_...  (difficulty_id => difficulties.id)
#
class Passage < ApplicationRecord
  belongs_to :difficulty

  has_many :sentences, dependent: :destroy
  has_many :passage_progresses, dependent: :destroy

  # Scope to order passages by position
  scope :ordered, -> { order(:position) }

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
