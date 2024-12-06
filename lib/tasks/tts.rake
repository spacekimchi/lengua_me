namespace :tts do
  desc "List available Google TTS voices"
  task list_voices: :environment do
    require "google/cloud/text_to_speech"

    client = Google::Cloud::TextToSpeech.text_to_speech

    # Optional: Specify language code to filter voices
    language_code = "en-US"

    voices = client.list_voices(language_code: language_code)

    voices.voices.each do |voice|
      puts "Name: #{voice.name}"
      puts "  Language Codes: #{voice.language_codes.join(', ')}"
      puts "  SSML Gender: #{voice.ssml_gender}"
      puts "  Natural Sample Rate: #{voice.natural_sample_rate_hertz}"

      # Categorize voice type based on naming conventions
      voice_type = categorize_voice_type(voice.name)
      puts "  Voice Type: #{voice_type}"

      puts "-" * 40
    end
  end

  # Helper method to categorize voice types based on voice name
  def categorize_voice_type(voice_name)
    if voice_name.include?("Wavenet")
      "Wavenet"
    elsif voice_name.include?("Neural2")
      "Neural2"
    elsif voice_name.include?("Studio")
      "Studio"
    elsif voice_name.include?("Polyglot")
      "Polyglot"
    elsif voice_name.include?("Journey")
      "Journey"
    else
      "Standard"
    end
  end
end

