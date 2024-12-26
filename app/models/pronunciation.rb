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
  belongs_to :word
  belongs_to :tts_voice

  # Attach one audio file for the pronunciation
  has_one_attached :audio

  # Optionally, you may want to generate audio after the record is created
  # after_create :enqueue_generate_audio_job

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

    Tempfile.create(['pronunciation_', '.mp3']) do |tempfile|
      tempfile.binmode
      tempfile.write(audio_data)
      tempfile.rewind

      self.audio.attach(
        io: tempfile,
        filename: "#{name}_#{language_code}_#{gender}_#{self.word.text}.mp3",
        content_type: 'audio/mpeg'
      )
    end
  end

  private

  def enqueue_generate_audio_job
    # If you have a background job for generating audio, you can enqueue it here
    GeneratePronunciationAudioJob.perform_later(self.id)
  end
end

