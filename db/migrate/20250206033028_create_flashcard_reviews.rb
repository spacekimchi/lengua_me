class CreateFlashcardReviews < ActiveRecord::Migration[8.0]
  def change
    create_table :flashcard_reviews, id: :uuid do |t|
      t.references :flashcard, type: :uuid, foreign_key: true, null: false
      t.integer :rating, null: false
      t.integer :scheduled_days, null: false, default: 0
      t.integer :elapsed_days, null: false, default: 0
      t.integer :previous_state, null: false, default: 0
      t.datetime :review_time, null: false

      t.timestamps
    end
  end
end
