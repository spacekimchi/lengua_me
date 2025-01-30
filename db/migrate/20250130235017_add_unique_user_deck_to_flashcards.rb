class AddUniqueUserDeckToFlashcards < ActiveRecord::Migration[8.0]
  def change
    add_index :flashcards, [:user_id, :deck_id], unique: true
  end
end
