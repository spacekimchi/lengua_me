class CreateUserSubscriptions < ActiveRecord::Migration[8.0]
  def change
    create_table :user_subscriptions, id: :uuid do |t|
      t.references :user, type: :uuid, null: false, foreign_key: true
      t.references :product, type: :uuid, foreign_key: true
      t.references :product_price, type: :uuid, foreign_key: true
      t.string :stripe_subscription_id, limit: 128
      t.string :status
      t.bigint :current_period_start
      t.bigint :current_period_end

      t.timestamps
    end

    add_index :user_subscriptions, :stripe_subscription_id, unique: true
  end
end
