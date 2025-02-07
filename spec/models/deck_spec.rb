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
require 'rails_helper'

RSpec.describe Deck, type: :model do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }

  describe 'validations' do
    let(:deck_name) { Faker::name }

    it 'name must be present' do
      expect(build(:deck, user: user, name: nil)).not_to be_valid
    end

    it 'allows different users to have decks with the same name' do
      user.decks.create(name: deck_name)
      expect(build(:deck, user: user2, name: deck_name)).to be_valid
    end

    it 'does not allow a user to have decks with the same name' do
      user.decks.create(name: deck_name)
      expect(build(:deck, user: user, name: deck_name)).not_to be_valid
    end
  end

  context 'study material' do
    let(:deck) { create(:deck, user: user) }

    before do
      (Deck::DEFAULT_NEW_CARDS_PER_DAY + 1).times do
        create(:flashcard, :new, user: user, deck: deck)
        create(:flashcard, :learning, user: user, deck: deck)
        create(:flashcard, :review, user: user, deck: deck)
        create(:flashcard, :relearning, user: user, deck: deck)
      end
    end

    describe '#new_cards' do
      it 'should not return more than the maximum per day' do
        expect(deck.flashcards.count).to be > Deck::DEFAULT_NEW_CARDS_PER_DAY
        expect(deck.new_cards.count).to be <= Deck::DEFAULT_NEW_CARDS_PER_DAY
      end

      it 'should return only new cards' do
        expect(deck.new_cards.pluck(:state).uniq).to eq([0])
      end
    end

    describe '#due_cards' do
      it 'should not return any new cards' do
        expect(deck.flashcards.pluck(:state).uniq).to include(0)
        expect(deck.due_cards.pluck(:state).uniq).not_to include(0)
      end
    end
  end
end
