# == Schema Information
#
# Table name: pronunciations
#
#  id           :uuid             not null, primary key
#  text         :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  tts_voice_id :uuid             not null
#  word_id      :uuid             not null
#
# Indexes
#
#  index_pronunciations_on_tts_voice_id              (tts_voice_id)
#  index_pronunciations_on_word_id                   (word_id)
#  index_pronunciations_on_word_id_and_tts_voice_id  (word_id,tts_voice_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (tts_voice_id => tts_voices.id)
#  fk_rails_...  (word_id => words.id)
#
class Pronunciation < ApplicationRecord
  BUCKET_FOLDER = "pronunciations".freeze

  belongs_to :word
  belongs_to :tts_voice

  # Attach one audio file for the pronunciation
  has_one_attached :audio

  scope :without_audio, -> { where.missing(:audio_attachment) }
  scope :with_audio, -> { joins(:audio_attachment) }

  # Optionally, you may want to generate audio after the record is created
  # after_create :enqueue_generate_audio_job

  def self.generate_missing_audio
    without_audio.find_each do |p|
      p.generate_audio
      sleep(3)
    end
  end

  def generate_audio
    return if audio.attached?

    language_code = tts_voice.language_code
    gender = tts_voice.gender
    name = tts_voice.provider_id
    tts_service = GoogleTextToSpeechService.new(
      word.text,
      language_code: language_code,
      gender: gender,
      voice_name: name
    )

    audio_data = tts_service.synthesize_speech

    filename = "#{self.word.text}_#{name}_#{language_code}_#{gender}.mp3"
    bucket_key = "#{BUCKET_FOLDER}/#{filename}"

    Tempfile.create(['pronunciation_', '.mp3']) do |tempfile|
      tempfile.binmode
      tempfile.write(audio_data)
      tempfile.rewind

      self.audio.attach(
        io: tempfile,
        filename: filename,
        content_type: 'audio/mpeg',
        key: bucket_key
      )
    end
  end

  private

  def enqueue_generate_audio_job
    # If you have a background job for generating audio, you can enqueue it here
    GeneratePronunciationAudioJob.perform_later(self.id)
  end
end

