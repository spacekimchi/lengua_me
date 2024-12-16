class CreateSentences < ActiveRecord::Migration[8.0]
  def change
    create_table :sentences, id: :uuid do |t|
      t.references :language, type: :uuid, null: true, foreign_key: true
      t.references :passage, type: :uuid, null: true, foreign_key: true

      t.text :content, default: ""
      t.integer :order_idx, default: 0
      t.text :prefix
      t.text :hints, array: true, default: []

      t.timestamps
    end
  end
end
