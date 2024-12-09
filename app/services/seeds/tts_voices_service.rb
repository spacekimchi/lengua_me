require 'csv'

module Seeds
  class TtsVoicesService
    def self.call
      google_tts_voices = CSV.read('google_tts_voices.csv')
      google_tts_voices.each do |g_tts|
        language_name = g_tts[0].split(' (')[0]

        accent = g_tts[0].split(' (')[1][0...-1] rescue language_name
        language_code = g_tts[2]
        gender = g_tts[4].downcase.to_sym
        voice_name = g_tts[3]
        provider_id = g_tts[3]
        provider = :google

        TtsVoice.transaction do
          TtsVoice.find_or_create_by(accent: accent, language_code: language_code, gender: gender, name: language_name, provider_id: provider_id, provider: provider)
        end
      end
    end
  end
end
