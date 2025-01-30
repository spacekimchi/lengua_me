class CreateDecks < ActiveRecord::Migration[8.0]
  def change
    create_table :decks, id: :uuid do |t|
      t.references :user, type: :uuid, foreign_key: true, null: false
      t.text :name, null: false
      t.timestamps
    end

    add_index :decks, [:user_id, :name], unique: true
  end
end
