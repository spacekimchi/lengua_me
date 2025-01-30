class CreateFlashcards < ActiveRecord::Migration[8.0]
  def change
    create_table :flashcards, id: :uuid do |t|
      t.references :user, type: :uuid, foreign_key: true, null: false
      t.references :deck, type: :uuid, foreign_key: true, null: false
      t.integer :flashcard_type, default: 0
      t.text :front
      t.text :back
      t.text :cloze
      t.text :additional_info
      t.datetime :due_at

      t.timestamps
    end
  end
end
