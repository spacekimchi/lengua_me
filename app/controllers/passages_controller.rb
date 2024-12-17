class PassagesController < ApplicationController
  def show
    @passage = Passage.find(params[:id])
    @languages = Language.all
  end

  def index
    @difficulties = Difficulty.ordered.left_joins(:passages).select('difficulties.id as id, name, COUNT(passages) as total_passages').group('difficulties.id')
  end

  def create
    pgs = PassageGeneratorService.new(difficulty: params[:difficulty])
    title_and_sentences = pgs.call
    all_sentences = title_and_sentences[:sentences]
    title = title_and_sentences[:title]
    language = Language.english

    ActiveRecord::Base.transaction do
      @passage = Passage.create!(title: title.downcase, difficulty: Difficulty.find_by(name: params[:difficulty]))

      all_sentences.each_with_index do |sentence_content, idx|
        sentence = Sentence.create!(passage: @passage, language: language, content: sentence_content, order_idx: idx)

        # Create words for this sentence
        create_words_for_sentence(sentence, language)
      end
    end

    respond_to do |format|
      if @passage.present?
        flash.now[:success] = "The passage was successfully created."
        format.turbo_stream
      else
        flash.now[:error] = "Failed to create the passage."
        format.turbo_stream { render partial: 'partials/flash', status: :unprocessable_entity }
      end
    end
  end

  def translate
    @passage = Passage.find(params[:id])
    language = Language.find(params[:language_id])
    respond_to do |format|
      if PassageTranslatorService.new(sentences: @passage.sentences.pluck(:content), language: language).call
        flash.now[:success] = "The passage was successfully translated."
        format.turbo_stream
      else
        flash.now[:error] = "Failed to translate the passage."
        format.turbo_stream { render partial: 'partials/flash', status: :unprocessable_entity }
      end
    end
  end

  def translations
    @passage = Passage.find(params[:id])
    target_language = Language.find_by(code: params[:language_code])
    @sentences = Sentence.where(passage_id: params[:id])
      .joins(:translations)
      .where(sentence_translations: { language_id: target_language.id })
      .order(:order_idx)
      .select('sentences.id as sentence_id, sentences.content as content, sentences.order_idx as order_idx, sentence_translations.text as translation_text')

    render json: { sentences: @sentences }, status: :ok
  end

  def by_difficulty
    @difficulty = Difficulty.find_by(name: params[:difficulty_name])
    @passages = @difficulty.passages.ordered
  end

  def passage_writer
    @difficulty = Difficulty.find_by(name: params[:difficulty_name])

    unless @difficulty
      redirect_to root_path, alert: "Difficulty not found."
      return
    end

    @passage = @difficulty.passages.find_by(title: params[:passage_name])

    unless @passage
      redirect_to difficulty_path(@difficulty), alert: "Passage not found."
      return
    end

    @sentences = @passage.sentences
      .with_attached_audio
      .select('sentences.id, sentences.content, sentences.order_idx')
      .order(:order_idx)
    passage_progress = @passage.passage_progresses.find_by(user: current_user)
    @current_index = passage_progress&.current_index || 0

    @language_codes = Constants::LANGUAGE_CODES
    @sentences_data = @sentences.map do |sentence|
      {
        id: sentence.id,
        content: sentence.content,
        audio_url: (sentence.audio.attached? ? url_for(sentence.audio) : nil),
        order_idx: sentence.order_idx
      }
    end

    # Utilize model methods to get next and previous passages
    @next_passage = @passage.next_passage
    @previous_passage = @passage.previous_passage
  end

  private

  def create_words_for_sentence(sentence, language)
    # Define separators that should be replaced with spaces
    separators = /[,\;\:\.\!\?\-\—\(\)\[\]\{\}\"`\|\/\\\@\#\$\%\^\&\*\_\+\=\<\>\~]/

    # Normalize the sentence by replacing separators with spaces
    normalized = sentence.content.gsub(separators, ' ')

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
end
