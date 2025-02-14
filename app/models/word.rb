# == Schema Information
#
# Table name: words
#
#  id          :uuid             not null, primary key
#  is_name     :boolean          default(FALSE)
#  text        :text             not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  language_id :uuid             not null
#
# Indexes
#
#  index_words_on_language_id           (language_id)
#  index_words_on_language_id_and_text  (language_id,text) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (language_id => languages.id)
#
class Word < ApplicationRecord
  belongs_to :language

  has_many :pronunciations, dependent: :destroy
  has_many :word_definitions, dependent: :destroy

  validates :text, presence: true

  scope :without_male_or_female_pronunciations, -> {
    left_joins(:pronunciations)
      .joins("LEFT JOIN tts_voices ON pronunciations.tts_voice_id = tts_voices.id")
      .group("words.id")
      .having("COUNT(DISTINCT CASE WHEN tts_voices.gender = 0 THEN tts_voices.id END) = 0 OR COUNT(DISTINCT CASE WHEN tts_voices.gender = 1 THEN tts_voices.id END) = 0")
  }

  def self.generate_missing_pronunciations
    words = without_male_or_female_pronunciations
    words.each do |word|
      word.add_missing_pronunciations
    end
  end

  def add_missing_pronunciations(language_code: 'en-US')
    TtsVoice.genders.keys.each do |gender|
      next if pronunciations.joins(:tts_voice).exists?(tts_voices: { gender: gender })

      tts_voice = TtsVoice.default_voices(language_code: language_code, gender: gender.to_sym)
      pronunciations.create!(tts_voice: tts_voice)
    end
  end

  def add_default_pronunciations(language_code: 'en-US')
    TtsVoice.genders.keys.each do |gender|
      tts_voice = TtsVoice.default_voices(language_code: language_code, gender: gender.to_sym)
      pronunciations.find_or_create_by(tts_voice: tts_voice)
    end
  end
end
