class PassagesController < ApplicationController
  before_action :require_login, only: [:in_progress]

  def show
    @passage = Passage.find(params[:id])
    @languages = Language.all
  end

  def index
    @categories = Passage.joins(:difficulty).group(:category).select("passages.category as name, count(passages.id) as total_passages, min(difficulties.level) as min_difficulty, max(difficulties.level) as max_difficulty")
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

  def by_category
    search_query = params[:q]
    difficulty_filter = params[:difficulty]

    unless Passage.categories.keys.include?(params[:category_name])
      redirect_to root_path, alert: "Category not found."
      return
    end

    @category = params[:category_name].gsub('_', ' ').titleize

    aggregated_passages = Passage
      .by_category(params[:category_name])
      .joins(:sentences, :difficulty)
      .select(
        'passages.id as id, passages.title, passages.position, count(sentences.id) as total_sentences, difficulties.id as difficulty_id, difficulties.name as difficulty_name'
      )
        .group('passages.id, difficulties.id')

    aggregated_passages = aggregated_passages.where(difficulty: Difficulty.find_by(name: difficulty_filter.downcase)) if difficulty_filter.present?
    aggregated_passages = aggregated_passages.search_like(search_query) if search_query.present?

    passages = Passage
      .from(aggregated_passages, :aggregated_passages)
      .select('*')
      .ordered

    @pagy, @passages = pagy(passages, limit: 30)

    if current_user
      @passage_progresses = PassageProgress
        .where(user: current_user, passage: @passages.pluck(:id))
        .select('passage_progresses.passage_id, passage_progresses.completed_count, passage_progresses.current_index')
        .index_by(&:passage_id)
    end
  end

  def passage_writer
    unless Passage.categories.keys.include?(params[:category_name])
      redirect_to root_path, alert: "Category not found."
      return
    end

    @category = params[:category_name].gsub('_', ' ').titleize

    @passage = Passage.by_category(params[:category_name]).find_by(title: params[:passage_name])

    unless @passage
      redirect_to by_category_path(category_name: params[:category_name]), alert: "Passage not found."
      return
    end

    @sentences = @passage.sentences
      .with_attached_audio
      .select('sentences.id, sentences.content, sentences.order_idx, sentences.prefix')
      .order(:order_idx)
    @passage_progress = @passage.passage_progresses.find_by(user: current_user)
    @current_index = @passage_progress&.current_index || 0

    @language_codes = Constants::LANGUAGE_CODES
    @sentences_data = @sentences.map do |sentence|
      {
        id: sentence.id,
        content: sentence.content,
        audio_url: (sentence.audio.attached? ? url_for(sentence.audio) : nil),
        order_idx: sentence.order_idx,
        prefix: sentence.prefix
      }
    end

    # Utilize model methods to get next and previous passages
    @next_passage = @passage.next_passage
    @previous_passage = @passage.previous_passage
  end

  def in_progress
    @passage_progresses = current_user.passage_progresses.in_progress

    respond_to do |format|
      format.turbo_stream
      format.json { render json: { passage_progresses: @passage_progresses }, status: :ok }
      format.html { redirect_back fallback_location: root_path, error: "Please enable JavaScript to see the in-progress popup." }
    end
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
