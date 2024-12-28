# == Schema Information
#
# Table name: sentences
#
#  id           :uuid             not null, primary key
#  content      :text             default("")
#  hints        :text             default([]), is an Array
#  order_idx    :integer          default(0)
#  prefix       :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  language_id  :uuid
#  passage_id   :uuid
#  tts_voice_id :uuid             not null
#
# Indexes
#
#  index_sentences_on_language_id   (language_id)
#  index_sentences_on_passage_id    (passage_id)
#  index_sentences_on_tts_voice_id  (tts_voice_id)
#
# Foreign Keys
#
#  fk_rails_...  (language_id => languages.id)
#  fk_rails_...  (passage_id => passages.id)
#  fk_rails_...  (tts_voice_id => tts_voices.id)
#
class Sentence < ApplicationRecord
  BUCKET_FOLDER = "sentences".freeze

  belongs_to :language, optional: true
  belongs_to :passage, optional: true
  belongs_to :tts_voice

  has_many :translations, class_name: 'SentenceTranslation', dependent: :destroy

  has_one_attached :audio

  validates :content, presence: true

  scope :without_audio, -> { where.missing(:audio_attachment) }

  # after_create :enqueue_generate_audio_job

  # validates :voice_type, presence: true, inclusion: { in: GoogleTextToSpeechService::VOICE_TYPES.keys.map(&:to_s) }

  def self.generate_missing_audio
    without_audio.find_each do |sentence|
      sentence.generate_audio
      sleep(3)
    end
  end

  def generate_audio
    return if audio.attached?

    language_code = tts_voice.language_code
    gender = tts_voice.gender
    name = tts_voice.provider_id
    tts_service = GoogleTextToSpeechService.new(
      self.content,
      language_code: language_code,
      gender: gender,
      voice_name: name
    )

    audio_data = tts_service.synthesize_speech

    filename = "#{order_idx}_#{name}_#{language_code}_#{gender}.mp3"
    bucket_key = "passages/#{passage.title}/#{BUCKET_FOLDER}/#{filename}"

    Tempfile.create(['sentence_', '.mp3']) do |tempfile|
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

