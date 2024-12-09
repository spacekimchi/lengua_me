# == Schema Information
#
# Table name: sentences
#
#  id          :uuid             not null, primary key
#  content     :text             default("")
#  order_idx   :integer          default(0)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  language_id :uuid
#  passage_id  :uuid
#
# Indexes
#
#  index_sentences_on_language_id  (language_id)
#  index_sentences_on_passage_id   (passage_id)
#
# Foreign Keys
#
#  fk_rails_...  (language_id => languages.id)
#  fk_rails_...  (passage_id => passages.id)
#
class Sentence < ApplicationRecord
  belongs_to :language
  belongs_to :passage

  has_many :translations, class_name: 'SentenceTranslation'

  has_one_attached :audio

  # after_create :enqueue_generate_audio_job

  # validates :voice_type, presence: true, inclusion: { in: GoogleTextToSpeechService::VOICE_TYPES.keys.map(&:to_s) }

  def generate_audio
    tts_service = GoogleTextToSpeechService.new(
      self.content,
      language_code: 'en-US'
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

