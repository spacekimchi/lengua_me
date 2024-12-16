# == Schema Information
#
# Table name: sentences
#
#  id          :uuid             not null, primary key
#  content     :text             default("")
#  hints       :text             default([]), is an Array
#  order_idx   :integer          default(0)
#  prefix      :text
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
    return if audio.attached?

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

  def create_words_from_content(language)
    # Define separators that should be replaced with spaces
    separators = /[,\;\:\.\!\?\-\—\(\)\[\]\{\}\"`\|\/\\\@\#\$\%\^\&\*\_\+\=\<\>\~]/

    # Normalize the sentence by replacing separators with spaces
    normalized = content.gsub(separators, ' ')

    # Split on spaces to get raw words
    raw_words = normalized.split(' ').reject(&:blank?)

    raw_words.each do |w|
      # Downcase to keep consistency
      word_text = w.downcase.strip

      # Use find_or_create_by to avoid duplicates
      # (assuming unique constraint on [language_id, text])
      Word.find_or_create_by(language: language, text: word_text) if word_text.present?
    end
  end

  private

  def enqueue_generate_audio_job
    GenerateAudioJob.perform_later(self.id)
  end
end

