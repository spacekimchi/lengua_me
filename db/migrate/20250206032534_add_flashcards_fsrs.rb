class AddFlashcardsFsrs < ActiveRecord::Migration[8.0]
  def change
    add_column :flashcards, :reps, :integer, default: 0, null: false
    add_column :flashcards, :lapses, :integer, default: 0, null: false
    add_column :flashcards, :state, :integer, default: 0, null: false # FSRS::State::NEW is 0
    add_column :flashcards, :stability, :float, default: 0.0, null: false
    add_column :flashcards, :difficulty, :float, default: 0.0, null: false
    add_column :flashcards, :last_review, :datetime
  end
end
