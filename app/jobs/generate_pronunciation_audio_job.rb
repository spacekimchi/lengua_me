class GeneratePronunciationAudioJob < ApplicationJob
  queue_as :default

  def perform(pronunciation_id)
    pronunciation = Pronunciation.find(pronunciation_id)
    pronunciation.generate_audio
  rescue StandardError => e
    Rails.logger.error "GenerateAudioJob Error: #{e.message}"
    raise e
  end
end
