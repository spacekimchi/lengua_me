class CreateWords < ActiveRecord::Migration[8.0]
  def change
    create_table :words, id: :uuid do |t|
      t.references :language, type: :uuid, foreign_key: true, null: false
      t.text :text, null: false

      t.timestamps
    end

    add_index :words, [:language_id, :text], unique: true
  end
end
