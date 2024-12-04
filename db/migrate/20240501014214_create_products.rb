class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products, id: :uuid do |t|
      t.string :stripe_product_id, limit: 128
      t.string :name, limit: 128, null: false
      t.string :description
      t.boolean :for_subscription, null: false, default: true
      t.boolean :is_active, null: false, default: true

      t.timestamps
    end

    add_index :products, :stripe_product_id, unique: true
  end
end
