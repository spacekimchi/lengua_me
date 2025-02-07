class RemoveUniqUserDeckFromFlashcards < ActiveRecord::Migration[8.0]
  def change
    remove_index :flashcards, name: "index_flashcards_on_user_id_and_deck_id"
  end
end
