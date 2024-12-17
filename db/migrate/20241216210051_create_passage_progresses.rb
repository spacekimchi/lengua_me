class CreatePassageProgresses < ActiveRecord::Migration[8.0]
  def change
    create_table :passage_progresses, id: :uuid do |t|
      t.references :user, type: :uuid, null: false, foreign_key: true
      t.references :passage, type: :uuid, null: false, foreign_key: true
      t.integer :current_index, default: 0
      t.integer :completed_count, default: 0

      t.timestamps
    end

    add_index :passage_progresses, [:user_id, :passage_id], unique: true
  end
end
