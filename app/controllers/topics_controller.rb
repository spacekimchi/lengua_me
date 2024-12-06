class TopicsController < ApplicationController
  def show
    topic_name = deurlify(params[:name])
    @topic = Topic.find_by(name: topic_name)
    @passages = @topic.passages
  end

  def index
    @topics = Topic.all
  end
end
