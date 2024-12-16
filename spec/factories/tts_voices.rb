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
FactoryBot.define do
  factory :tts_voice do
    
  end
end
