# == Schema Information
#
# Table name: tts_voices
#
#  id            :uuid             not null, primary key
#  accent        :text
#  gender        :text             not null
#  language_code :text             not null
#  name          :text             not null
#  provider      :integer          default("google"), not null
#  provider_id   :text             not null
#
# Indexes
#
#  index_tts_voices_on_language_code      (language_code)
#  index_tts_voices_on_name_and_provider  (name,provider) UNIQUE
#  index_tts_voices_on_provider           (provider)
#
class TtsVoice < ApplicationRecord

  has_many :pronunciations
  has_many :words, through: :pronunciations, source: :word

  validates :language_code, presence: true
  validates :gender, presence: true
  validates :name, presence: true
  validates :provider_id, presence: true

  enum :provider, [:google, :elevenlabs, :playht], default: :google
end
