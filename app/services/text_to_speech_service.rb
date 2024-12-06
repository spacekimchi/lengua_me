# app/services/text_to_speech_service.rb
require "google/cloud/text_to_speech"

class TextToSpeechService
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
  DEFAULT_VOICE_TYPE = :wavenet # Set your preferred default voice type

  def initialize(
    text,
    language_code: DEFAULT_LANGUAGE_CODE,
    gender: DEFAULT_SSML_GENDER,
    voice_type: DEFAULT_VOICE_TYPE
  )
    @text = text
    @language_code = language_code
    @gender = gender
    @voice_type = voice_type
  end

  def synthesize_speech
    client = Google::Cloud::TextToSpeech.text_to_speech

    synthesis_input = { text: @text }

    # Select a voice name based on the voice_type
    voice_name = select_voice_name(@language_code, @voice_type)

    voice = {
      name: voice_name,
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

  private

  def select_voice_name(language_code, voice_type)
    available_voices = VOICE_TYPES[voice_type]
    raise ArgumentError, "Unsupported voice type: #{voice_type}" unless available_voices

    # You can implement more sophisticated selection logic here
    available_voices.sample
  end
end

