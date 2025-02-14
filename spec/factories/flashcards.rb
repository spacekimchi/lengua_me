# == Schema Information
#
# Table name: flashcards
#
#  id              :uuid             not null, primary key
#  additional_info :text
#  back            :text
#  cloze           :text
#  difficulty      :float            default(0.0), not null
#  due_at          :datetime
#  flashcard_type  :integer          default("normal")
#  front           :text
#  lapses          :integer          default(0), not null
#  last_review     :datetime
#  reps            :integer          default(0), not null
#  stability       :float            default(0.0), not null
#  state           :integer          default(0), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  deck_id         :uuid             not null
#  user_id         :uuid             not null
#
# Indexes
#
#  index_flashcards_on_deck_id  (deck_id)
#  index_flashcards_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (deck_id => decks.id)
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :flashcard do
    association :user
    association :deck

    trait :new do
      state { Fsrs::State::NEW }
    end

    trait :learning do
      state { Fsrs::State::LEARNING }
      due_at { Time.now }
      reps { 1 }
      lapses { 0 }
      stability { 0.4 }
      difficulty { 6.81 }
      last_review { Time.now - 1 }
    end

    trait :review do
      state { Fsrs::State::REVIEW }
      due_at { Time.now }
      reps { 2 }
      lapses { 0 }
      stability { 0.4 }
      difficulty { 6.81 }
      last_review { Time.now - 1 }
    end

    trait :relearning do
      state { Fsrs::State::RELEARNING }
      due_at { Time.now }
      reps { 3 }
      lapses { 0 }
      stability { 2.206888932398359 }
      difficulty { 6.791199999999999 }
      last_review { Time.now - 1 }
    end
  end
end
