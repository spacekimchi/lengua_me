class FlashcardReview < ApplicationRecord
  belongs_to :user
  belongs_to :flashcard

  validates :reviewed_at, presence: true
  validates :quality, presence: true
end
