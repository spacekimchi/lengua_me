# == Schema Information
#
# Table name: tts_voices
#
#  id            :uuid             not null, primary key
#  accent        :text
#  gender        :integer          default("female"), not null
#  language_code :text             not null
#  name          :text             not null
#  provider      :integer          default("google"), not null
#  provider_id   :text             not null
#
# Indexes
#
#  index_tts_voices_on_language_code             (language_code)
#  index_tts_voices_on_provider                  (provider)
#  index_tts_voices_on_provider_id_and_provider  (provider_id,provider) UNIQUE
#
class TtsVoice < ApplicationRecord

  has_many :pronunciations
  has_many :words, through: :pronunciations, source: :word
  has_many :sentences

  validates :language_code, presence: true
  validates :name, presence: true
  validates :provider_id, presence: true

  enum :provider, [:google, :elevenlabs, :playht], default: :google
  enum :gender, [:male, :female], default: :male

  def self.default_voices(language_code:, gender:)
    case language_code
    when 'en-US'
      if gender == :male
        find_by(gender: gender, provider_id: "en-US-Journey-D", provider: :google)
      else
        find_by(gender: gender, provider_id: "en-US-Journey-F", provider: :google)
      end
    end
  end
end
