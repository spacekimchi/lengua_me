class DecksController < ApplicationController
  before_action :require_login

  def index
    @decks = current_user.decks.includes(:flashcards)
    @deck = current_user.decks.new
  end

  def show
    @deck = current_user.decks.find(params[:id])
    @flashcard = @deck.flashcards.new
  end

  def study
    @deck = current_user.decks.find(params[:id])
    @new_cards = @deck.new_cards
    @due_cards = @deck.due_cards
    @flashcards = @new_cards + @due_cards
    @current_card = @flashcards.present? ? @flashcards[0] : nil
  end

  def create
    @deck = current_user.decks.new(deck_params)
    respond_to do |format|
      if @deck.save
        flash[:success] = "Successfully created a new deck."
        format.turbo_stream
        format.html { redirect_to decks_path, notice: "Deck created." }
      else
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("deck_form", partial: "flashcards/add_deck_form")
        end
        format.html { render :new }
      end
    end
  end

  private

  def deck_params
    params.require(:deck).permit(:name)
  end
end
