class CreateLanguages < ActiveRecord::Migration[8.0]
  def change
    create_table :languages, id: :uuid do |t|
      t.text :name
      t.text :code

      t.timestamps
    end

    add_index :languages, :name, unique: true
    add_index :languages, :code, unique: true
  end
end
