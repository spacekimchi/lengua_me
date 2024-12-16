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

  def translate(language:)
    PassageTranslatorService.new(sentences: sentences.pluck(:content, :id), language: language).call
  end

  def sentences_to_speech
    sentences.each do |sentence|
      sentence.generate_audio
    end
  end
end
