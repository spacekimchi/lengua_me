class PronunciationsController < ApplicationController
  def show
    original_language = Language.find_by(code: params[:original_language])
    translate_language = Language.find_by(code: params[:translate_language])
    word = Word.find_by(language: original_language, text: params[:text].downcase)
    tts_code = params[:tts_code] || 'en-US'
    tts_gender = params[:gender] || 'Male'
    pronunciation = word.pronunciations.find_by(tts_voice: TtsVoice.find_by(language_code: tts_code, gender: tts_gender))
    debugger
    render json: { pronunciation: pronunciation
  end
end
