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
class Flashcard < ApplicationRecord
  NEW = 0
  LEARNING = 1
  REVIEW = 2
  RELEARNING = 3
  STATES = [NEW, LEARNING, REVIEW, RELEARNING].freeze
  NORMAL = :normal
  CLOZE = :cloze

  belongs_to :user
  belongs_to :deck

  has_many :flashcard_reviews

  enum :flashcard_type, [:normal, :cloze], default: :normal
end
