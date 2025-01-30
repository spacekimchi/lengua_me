class Deck < ApplicationRecord
  belongs_to :user

  has_many :flashcards

  validates :name, uniqueness: { scope: :user_id }
end
