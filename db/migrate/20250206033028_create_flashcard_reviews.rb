class CreateFlashcardReviews < ActiveRecord::Migration[8.0]
  def change
    create_table :flashcard_reviews, id: :uuid do |t|
      t.references :user, type: :uuid, foreign_key: true, null: false
      t.references :flashcard, type: :uuid, foreign_key: true, null: false
      t.datetime :reviewed_at, null: false
      t.integer  :quality, null: false
      t.integer  :previous_interval
      t.integer  :new_interval
      t.float    :previous_ease_factor
      t.float    :new_ease_factor
      t.integer  :repetition_count, null: false, default: 0
      t.text     :notes

      t.timestamps
    end
  end
end
