# This uses the FSRS4.5 algorithm
class FlashcardSchedulerService
  # rating should be one of FSRS::Rating::AGAIN, FSRS::Rating::HARD,
  # FSRS::Rating::GOOD, or FSRS::Rating::EASY
  def self.schedule_review(flashcard, rating, now = Time.now.utc)
    fsrs_card = FSRS::Card.new
    fsrs_card.due         = flashcard.due_at || now
    fsrs_card.stability   = flashcard.stability   || 0.0
    fsrs_card.difficulty  = flashcard.difficulty  || 0.0
    fsrs_card.reps        = flashcard.reps        || 0
    fsrs_card.lapses      = flashcard.lapses      || 0
    fsrs_card.state       = flashcard.state       || FSRS::State::NEW
    fsrs_card.last_review = flashcard.last_review || now

    fsrs_card.elapsed_days = if flashcard.last_review
                               (now.to_date - flashcard.last_review.to_date).to_i
                             else
                               0
                             end

    scheduler = FSRS::Scheduler.new
    scheduling_logs = scheduler.repeat(fsrs_card, now)
    # This returns a hash keyed by each rating, e.g.: {
    #   FSRS::Rating::AGAIN => Fsrs::SchedulingInfo,
    #   FSRS::Rating::HARD  => Fsrs::SchedulingInfo,
    #   ...
    # }

    scheduling_info = scheduling_logs[rating]         # Fsrs::SchedulingInfo
    updated_fsrs_card = scheduling_info.card          # The updated Fsrs::Card
    review_log        = scheduling_info.review_log    # Fsrs::ReviewLog

    # Update the flashcard with new scheduling info.
    flashcard.due_at     = updated_fsrs_card.due
    flashcard.stability  = updated_fsrs_card.stability
    flashcard.difficulty = updated_fsrs_card.difficulty
    flashcard.reps       = updated_fsrs_card.reps
    flashcard.lapses     = updated_fsrs_card.lapses
    flashcard.state      = updated_fsrs_card.state
    flashcard.last_review = now
    flashcard.save!

    # Record the review event in the flashcard_reviews table.
    flashcard.flashcard_reviews.create!(
      rating:         review_log.rating,        # e.g., 1 = AGAIN, 2 = HARD, etc.
      scheduled_days: review_log.scheduled_days,
      elapsed_days:   review_log.elapsed_days,
      previous_state: review_log.state,         # state of the card before scheduling
      review_time:    now                       # or review_log.review if you prefer
    )
  end

  # This should be a controller method somewhere
  # def review
  #   flashcard = Flashcard.find(params[:id])
  #   # rating is one of [1, 2, 3, 4] corresponding to
  #   # FSRS::Rating::AGAIN, HARD, GOOD, EASY
  #   rating = params[:rating].to_i

  #   FlashcardSchedulerService.schedule_review(flashcard, rating)

  #   render json: {
  #     success: true,
  #     next_review_at: flashcard.reload.due_at
  #   }
  # end
end

