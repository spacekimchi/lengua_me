# == Schema Information
#
# Table name: flashcard_reviews
#
#  id             :uuid             not null, primary key
#  elapsed_days   :integer          default(0), not null
#  previous_state :integer          default(0), not null
#  rating         :integer          not null
#  review_time    :datetime         not null
#  scheduled_days :integer          default(0), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  flashcard_id   :uuid             not null
#
# Indexes
#
#  index_flashcard_reviews_on_flashcard_id  (flashcard_id)
#
# Foreign Keys
#
#  fk_rails_...  (flashcard_id => flashcards.id)
#
class FlashcardReview < ApplicationRecord
  belongs_to :flashcard
end
