class Sentence < ApplicationRecord
  belongs_to :language
  belongs_to :passage

  has_many :translations, class_name: 'SentenceTranslation'

  has_one_attached :audio

  # after_create :generate_audio

  private

  def generate_audio
    tts_service = TextToSpeechService.new(self.content)
    audio_file = tts_service.synthesize_speech

    self.audio.attach(
      io: File.open(audio_file.path),
      filename: "sentence_#{self.id}.mp3",
      content_type: 'audio/mpeg'
    )
    audio_file.close
    audio_file.unlink
  end
end
