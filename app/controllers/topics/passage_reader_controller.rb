module Topics
  class PassageReaderController < ApplicationController
    def show
      @topic = Topic.find_by(name: deurlify(params[:topic_name]))
      @passage = @topic.passages.find(params[:id])
      @sentences = @passage.sentences.order(:order_idx)
    end
  end
end
