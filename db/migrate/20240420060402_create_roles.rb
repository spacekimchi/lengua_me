class CreateRoles < ActiveRecord::Migration[8.0]
  def change
    create_table :roles, id: :uuid do |t|
      t.integer :name
      t.string :description

      t.timestamps
    end

    add_index :roles, :name, unique: true
  end
end
