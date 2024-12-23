class CreateNotes < ActiveRecord::Migration[8.0]
  def change
    create_table :notes, id: :uuid do |t|
      t.references :user, type: :uuid, foreign_key: true, null: false
      t.references :passage, type: :uuid, foreign_key: true, null: true
      t.text :content, default: ""

      t.timestamps
    end
  end
end
