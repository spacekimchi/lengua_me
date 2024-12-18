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
  has_many :pronunciations

  validates :text, presence: true

  def add_default_pronunciations(language_code: 'en-US')
    TtsVoice.genders.keys.each do |gender|
      tts_voice = TtsVoice.default_voices(language_code: language_code, gender: gender.to_sym)
      pronunciations.find_or_create_by(tts_voice: tts_voice)
    end
  end
end
