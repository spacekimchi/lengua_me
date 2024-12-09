# app/services/text_to_speech_service.rb
require "google/cloud/text_to_speech"

class GoogleTextToSpeechService
  VOICE_TYPES = {
    standard: [
      "en-US-Standard-B",
      "en-US-Standard-C",
      "en-US-Standard-D",
      # Add other Standard voices as needed
    ],
    wavenet: [
      "en-US-Wavenet-A",
      "en-US-Wavenet-B",
      "en-US-Wavenet-C",
      "en-US-Wavenet-D",
      # Add other Wavenet voices as needed
    ],
    neural2: [
      "en-US-Neural2-A",
      "en-US-Neural2-B",
      # Add other Neural2 voices as needed
    ],
    studio: [
      # Add Studio voices if available
    ],
    polyglot: [
      # Add Polyglot voices if available
    ],
    journey: [
      # Add Journey voices if available
    ]
  }.freeze

  DEFAULT_LANGUAGE_CODE = "en-US"
  DEFAULT_SSML_GENDER = "FEMALE"
  DEFAULT_FEMALE_US_NAME = "en-US-Journey-F".freeze
  DEFAULT_MALE_US_NAME = "en-US-Journey-D".freeze


  def initialize(
    text,
    language_code: DEFAULT_LANGUAGE_CODE,
    gender: DEFAULT_SSML_GENDER,
    voice_name: DEFAULT_FEMALE_US_NAME
  )
    @text = text
    @language_code = language_code
    @gender = gender
    @voice_name = voice_name
  end

  def synthesize_speech
    client = Google::Cloud::TextToSpeech.text_to_speech

    synthesis_input = { text: @text }

    voice = {
      name: @voice_name,
      language_code: @language_code,
      ssml_gender: @gender.upcase.to_sym
    }

    audio_config = { audio_encoding: :MP3 }

    response = client.synthesize_speech(
      input: synthesis_input,
      voice: voice,
      audio_config: audio_config
    )

    response.audio_content # Binary MP3 data
  end
end

