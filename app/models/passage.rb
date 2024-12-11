# == Schema Information
#
# Table name: passages
#
#  id         :uuid             not null, primary key
#  difficulty :integer          default("basic")
#  title      :text             default("")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Passage < ApplicationRecord
  has_many :sentences, dependent: :destroy
  has_many :passage_topics
  has_many :topics, through: :passage_topics, source: :topic

  enum :difficulty, [:basic, :a1, :a2, :b1, :b2, :c1, :c2, :native], default: :basic

  def translate(language:)
    PassageTranslatorService.new(sentences: sentences.pluck(:content, :id), language: language).call
  end

  def sentences_to_speech
    sentences.each do |sentence|
      sentence.generate_audio
    end
  end
end
