class Sentence < ApplicationRecord
  belongs_to :language
  belongs_to :passage

  has_many :translations, class_name: 'SentenceTranslation'

  has_one_attached :audio

  # after_create :enqueue_generate_audio_job

  # validates :voice_type, presence: true, inclusion: { in: TextToSpeechService::VOICE_TYPES.keys.map(&:to_s) }

  def generate_audio
    tts_service = TextToSpeechService.new(
      self.content,
      # language_code: self.language.code,  # Assuming `language` has a `code` attribute like "en-US"
      # gender: self.language.gender,        # Assuming `language` has a `gender` attribute ("MALE", "FEMALE", "NEUTRAL")
      language_code: 'en-US',
      gender: 'FEMALE',
      voice_type: :wavenet
    )

    audio_data = tts_service.synthesize_speech

    Tempfile.create(['sentence_', '.mp3']) do |tempfile|
      tempfile.binmode
      tempfile.write(audio_data)
      tempfile.rewind

      self.audio.attach(
        io: tempfile,
        filename: "sentence_#{self.id}.mp3",
        content_type: 'audio/mpeg'
      )
    end
  end

  private

  def enqueue_generate_audio_job
    GenerateAudioJob.perform_later(self.id)
  end
end

