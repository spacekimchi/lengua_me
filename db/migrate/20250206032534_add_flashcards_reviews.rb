class AddFlashcardsReviews < ActiveRecord::Migration[8.0]
  def change
    add_column :flashcards, :last_reviewed_at, :datetime
    add_column :flashcards, :repetition_count, :integer, default: 0, null: false
    add_column :flashcards, :interval, :float, default: 0.0, null: false
    add_column :flashcards, :ease_factor, :float, default: 2.5, null: false
  end
end
