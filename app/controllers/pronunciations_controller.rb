class PronunciationsController < ApplicationController
  def show
    original_language = Language.find_by(code: params[:original_language])
    translate_language = Language.find_by(code: params[:translate_language])
    word = Word.find_by(language: original_language, text: params[:text].downcase)
    tts_code = params[:tts_code].presence || 'en-US'
    male_pronunciation = word.pronunciations.find_by(tts_voice: TtsVoice.default_voices(language_code: tts_code, gender: :male))
    female_pronunciation = word.pronunciations.find_by(tts_voice: TtsVoice.default_voices(language_code: tts_code, gender: :female))

    render json: { male_pronunciation: url_for(male_pronunciation.audio), female_pronunciation: url_for(female_pronunciation.audio), word_text: word.text, pronunciation_text: male_pronunciation.text.presence || female_pronunciation.text }
  end
end
