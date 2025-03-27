module Teachers
  class ExercisesController < ApplicationController
    def show
    end

    def index
      @passages = current_user.passages
    end

    def new
      @passage = Passage.new
      @english = Language.english
    end

    def create
      @passage = current_user.passages.new(exercises_params)

      if @passage.save
        # Redirect to the show action (adjust the path helper as appropriate)
        redirect_to teachers_exercise_path(@passage), notice: "Passage was successfully created."
      else
        # Render the “new” template again, which will automatically display errors
        render :new
      end
    end

    private

    def exercises_params
      params.require(:passage).permit(:category, :title, :difficulty_id, sentences_attributes: [:content, :hints, :order_idx, :prefix, :language_id, :passage_id, :tts_voice_id])
    end
  end
end
