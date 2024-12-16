class CreatePassages < ActiveRecord::Migration[8.0]
  def change
    create_table :passages, id: :uuid do |t|
      t.references :difficulty, type: :uuid, foreign_key: true, null: false
      t.text :title, default: ""

      t.timestamps
    end
  end
end
