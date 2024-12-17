class CreatePassages < ActiveRecord::Migration[8.0]
  def change
    create_table :passages, id: :uuid do |t|
      t.references :difficulty, type: :uuid, foreign_key: true, null: false
      t.text :title, default: ""
      t.integer :position, null: false

      t.timestamps
    end

    add_index :passages, [:difficulty_id, :position], unique: true
  end
end
