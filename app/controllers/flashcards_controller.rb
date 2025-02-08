class FlashcardsController < ApplicationController
  before_action :require_login

  def index
  end

  def show
  end

  def review
    @flashcard = current_user.flashcards.find(params[:id])
    rating = params[:rating].to_i
    @fsrs = FlashcardSchedulerService.schedule_review(@flashcard, rating)

    @deck = @flashcard.deck
    @new_cards = @deck.new_cards
    @due_cards = @deck.due_cards
    @flashcards = @new_cards + @due_cards
    @current_card = @flashcards.present? ? @flashcards[0] : nil

    respond_to do |format|
      format.turbo_stream
    end
  end

  def create
    @deck = current_user.decks.find(flashcard_params[:deck_id])
    @flashcard = @deck.flashcards.new(flashcard_params)
    @flashcard.user = current_user

    respond_to do |format|
      if @flashcard.save
        flash[:success] = "Successfully added a flashcard"
        format.turbo_stream
      else
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("new_flashcard_modal", partial: "flashcards/new_flashcard")
        end
      end
    end
  end

  private

  def flashcard_params
    params.require(:flashcard).permit(:flashcard_type, :front, :back, :cloze, :additional_info, :deck_id)
  end
end
