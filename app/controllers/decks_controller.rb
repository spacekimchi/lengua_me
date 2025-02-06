class DecksController < ApplicationController
  before_action :require_login

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
