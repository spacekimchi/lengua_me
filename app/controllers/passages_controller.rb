class PassagesController < ApplicationController
  def show
    @passage = Passage.find(params[:id])
    @languages = Language.all
  end

  def index
    @passages = Passage.all.includes(:sentences)
    @topics = Topic.all
  end

  def new
  end

  def create
    @topic = Topic.find(params[:topic_id])
    pgs = PassageGeneratorService.new(topic: @topic, difficulty: params[:difficulty])
    title_and_sentences = pgs.call
    all_sentences = title_and_sentences[:sentences]
    title = title_and_sentences[:title]
    ActiveRecord::Base.transaction do
      @passage = Passage.create!(title: title, difficulty: params[:difficulty].to_sym)
      @passage.passage_topics.create!(topic: @topic)
      language = Language.english
      all_sentences.each_with_index do |sentence, idx|
        a = Sentence.create!(passage: @passage, language: language, content: sentence, order_idx: idx)
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
    sentences = PassageTranslatorService.new(sentences: @passage.sentences.pluck(:content), language: language).call[:sentences]
    @sentence_translations = []

    ActiveRecord::Base.transaction do
      sentences.each_with_index do |sentence, idx|
        @sentence_translations.append(SentenceTranslation.create!(language: language, sentence: @passage.sentences.find_by(order_idx: idx), text: sentence))
      end
    end

    respond_to do |format|
      if @sentence_translations.present?
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
end
