class PassagesController < ApplicationController
  def show
    @passage = Passage.find(params[:id])
    @languages = Language.all
  end

  def index
    @topics = Topic.left_joins(:passages).select('topics.id as id, name, description, COUNT(passages) as total_passages').group('topics.id')
  end

  def create
    @topic = Topic.find(params[:topic_id])
    pgs = PassageGeneratorService.new(topic: @topic, difficulty: params[:difficulty])
    title_and_sentences = pgs.call
    all_sentences = title_and_sentences[:sentences]
    title = title_and_sentences[:title]
    language = Language.english

    ActiveRecord::Base.transaction do
      @passage = Passage.create!(title: title.downcase, difficulty: params[:difficulty].to_sym)
      @passage.passage_topics.create!(topic: @topic)

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

  def get_by_topic
    @topic = Topic.find_by(name: deurlify(params[:topic_name]))
    @passages = @topic.passages
  end

  def passage_writer
    @topic = Topic.find_by(name: deurlify(params[:topic_name]))
    @passage = @topic.passages.find_by(title: deurlify(params[:passage_name]))
    @sentences = @passage.sentences.order(:order_idx)
    @language_codes = Constants::LANGUAGE_CODES
    @sentences_data = @sentences.map do |sentence|
      {
        content: sentence.content,
        audio_url: (sentence.audio.attached? ? url_for(sentence.audio) : nil),
        order_idx: sentence.order_idx
      }
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
