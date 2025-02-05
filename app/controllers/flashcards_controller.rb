class FlashcardsController < ApplicationController
  before_action :require_login

  def index
    @decks = current_user.decks.includes(:flashcards)
    @deck = current_user.decks.new
  end

  def show
  end
end
