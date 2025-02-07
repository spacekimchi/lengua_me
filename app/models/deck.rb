# == Schema Information
#
# Table name: decks
#
#  id         :uuid             not null, primary key
#  name       :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :uuid             not null
#
# Indexes
#
#  index_decks_on_user_id           (user_id)
#  index_decks_on_user_id_and_name  (user_id,name) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Deck < ApplicationRecord
  DEFAULT_NEW_CARDS_PER_DAY = 20;

  belongs_to :user

  has_many :flashcards

  validates :name, uniqueness: { scope: :user_id }, presence: true

  def new_cards
    flashcards.where("state = ?", Fsrs::State::NEW)
      .order(:created_at)
      .limit(DEFAULT_NEW_CARDS_PER_DAY)
  end

  def due_cards
    flashcards.where("due_at <= ?", Time.current)
      .where.not("state = ?", Fsrs::State::NEW)
      .order(:due_at)
  end
end
