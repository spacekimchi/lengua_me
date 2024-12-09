class GenerateAudioJob < ApplicationJob
  queue_as :default

  def perform(sentence_id)
    sentence = Sentence.find(sentence_id)
    sentence.generate_audio unless sentence.audio.attached?
  rescue StandardError => e
    Rails.logger.error "GenerateAudioJob Error: #{e.message}"
    raise e
  end
end
