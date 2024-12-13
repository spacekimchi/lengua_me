class CreateTopics < ActiveRecord::Migration[8.0]
  def change
    create_table :topics, id: :uuid do |t|
      t.text :name, null: false
      t.text :description, default: ''
      t.text :image_url

      t.timestamps
    end

    add_index :topics, :name, unique: true
  end
end
