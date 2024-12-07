module Topics
  class PassageReaderController < ApplicationController
    def show
      @topic = Topic.find_by(name: deurlify(params[:topic_name]))
      @passage = @topic.passages.find(params[:id])
      @sentences = @passage.sentences.order(:order_idx)
      @sentences_data = @sentences.map do |sentence|
        {
          content: sentence.content,
          audio_url: (sentence.audio.attached? ? url_for(sentence.audio) : nil),
          order_idx: sentence.order_idx
        }
      end
    end
  end
end

