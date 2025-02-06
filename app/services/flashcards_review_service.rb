class FlashcardReviewService
  MIN_EASE_FACTOR = 1.3

  def initialize(flashcard:, quality:, user:)
    @flashcard = flashcard
    @quality = quality.to_i  # Ensure it's an integer between 0 and 5
    @user = user
  end

  def process_review
    # Capture previous state
    previous_interval = @flashcard.interval || 0
    previous_ease_factor = @flashcard.ease_factor || 2.5
    previous_review_count = @flashcard.review_count || 0

    # Determine if the review is successful (quality >= 3)
    if @quality < 3
      # If the quality is too low, reset the repetition count.
      new_review_count = 0
      new_interval = 1  # Or choose to keep it low, such as 1 day.
      new_ease_factor = previous_ease_factor  # Alternatively, you can adjust it slightly.
    else
      # Successful review
      new_review_count = previous_review_count + 1

      # Update the ease factor based on SM-2 formula
      new_ease_factor = previous_ease_factor - 0.8 + (0.28 * @quality) - (0.02 * @quality * @quality)
      new_ease_factor = [new_ease_factor, MIN_EASE_FACTOR].max

      # Determine the new interval
      new_interval =
        case new_review_count
        when 1
          1  # 1 day for the first review
        when 2
          6  # 6 days for the second review
        else
          # Multiply the previous interval by the new ease factor.
          (previous_interval * new_ease_factor).floor
        end
    end

    # Compute the new due date
    new_due_at = Time.current + new_interval.days

    # Update the flashcard's state
    @flashcard.update!(
      last_reviewed_at: Time.current,
      review_count: new_review_count,
      interval: new_interval,
      ease_factor: new_ease_factor,
      due_at: new_due_at
    )

    # Log the review in flashcard_reviews
    FlashcardReview.create!(
      user: @user,
      flashcard: @flashcard,
      reviewed_at: Time.current,
      quality: @quality,
      previous_interval: previous_interval,
      new_interval: new_interval,
      previous_ease_factor: previous_ease_factor,
      new_ease_factor: new_ease_factor
    )
  end

=begin
  # This should be somewhere in a controller action
  def review
    @flashcard = Flashcard.find(params[:id])
    quality = params[:quality].to_i  # e.g., from a form submission (0–5)

    begin
      FlashcardReviewService.new(@flashcard, quality).process_review
      flash[:notice] = "Review processed successfully!"
    rescue => e
      flash[:alert] = "There was an error processing your review: #{e.message}"
    end

    redirect_to some_path
  end
=end
end

