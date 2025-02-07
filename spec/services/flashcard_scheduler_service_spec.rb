require 'rails_helper'

RSpec.describe FlashcardSchedulerService, type: :service do
  let(:user) { create(:user) }

  describe '#schedule_review' do
    let(:deck) { create(:deck, user: user) }
    let(:new_flashcard) { create(:flashcard, :new, deck: deck, user: user) }
    let(:learning_flashcard) { create(:flashcard, :learning, deck: deck, user: user) }
    let(:review_flashcard) { create(:flashcard, :review, deck: deck, user: user) }
    let(:relearning_flashcard) { create(:flashcard, :relearning, deck: deck, user: user) }

    context 'when rating is AGAIN' do
      it 'should create a flashcard_review' do
        expect { FlashcardSchedulerService.schedule_review(new_flashcard, Fsrs::Rating::AGAIN) }
          .to change{ FlashcardReview.count }.by(1)
      end
    end

    context 'when rating is EASY' do
      it 'should create a flashcard_review' do
        FlashcardSchedulerService.schedule_review(learning_flashcard, Fsrs::Rating::EASY)
      end
    end

    context 'when rating is GOOD' do
      it 'should create a flashcard_review' do
        FlashcardSchedulerService.schedule_review(review_flashcard, Fsrs::Rating::GOOD)
      end
    end

    context 'when rating is HARD' do
      it 'should create a flashcard_review' do
        FlashcardSchedulerService.schedule_review(relearning_flashcard, Fsrs::Rating::HARD)
        FlashcardSchedulerService.schedule_review(relearning_flashcard, Fsrs::Rating::AGAIN)
      end
    end
  end
end
