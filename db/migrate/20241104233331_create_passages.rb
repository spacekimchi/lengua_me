class CreatePassages < ActiveRecord::Migration[8.0]
  def change
    create_table :passages, id: :uuid do |t|
      t.text :title, default: ""
      t.integer :difficulty, default: 0

      t.timestamps
    end
  end
end
