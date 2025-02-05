class DecksController < ApplicationController
  before_action :require_login

  def create
    @deck = current_user.decks.new(deck_params)
  end

  private

  def deck_params
    params.require(:deck).permit(:name)
  end
end
