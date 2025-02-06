class Flashcard < ApplicationRecord
  belongs_to :user
  belongs_to :deck

  has_many :flashcard_reviews

  enum :flashcard_type, [:normal, :cloze], default: :normal

  # quality_rating is the rating of ease of recalling a flashcard
  # quality_rating should be in the range of 1-5
  # A quality_rating of 3 or less means the card was 'forgotten'
  #   - review_count should be set to 0
  #   - interval should be reset as well
  def update_ease_factor(quality_rating)
    if quality_rating <= 3
      update(review_count: 0, interval: 0)
    else
      min_ease_factor = 1.3
      new_ease_factor = ease_factor - 0.8 + (0.28 * quality_rating) - (0.02 * quality_rating * quality_rating)
      new_interval = if review_count == 0
                       1
                     else if review_count == 1
                       2
                     else if review_count == 2
                       6
                     else
                       (interval * new_ease_factor).floor
                     end

      update(ease_factor: [min_ease_factor, new_ease_factor].max, interval: new_interval)
    end
  end
end
