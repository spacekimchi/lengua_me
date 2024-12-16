class CreateDifficulties < ActiveRecord::Migration[8.0]
  def change
    create_table :difficulties, id: :uuid do |t|
      t.text :name, null: false
      t.integer :level, null: false
      t.text :description

      t.timestamps
    end

    add_index :difficulties, :name, unique: true
    add_index :difficulties, :level, unique: true
  end
end
