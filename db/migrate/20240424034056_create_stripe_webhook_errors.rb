class CreateStripeWebhookErrors < ActiveRecord::Migration[8.0]
  def change
    create_table :stripe_webhook_errors, id: :uuid do |t|
      t.string :message
      t.string :stripe_customer_id
      t.json :event_object
      t.string :event_type
      t.boolean :is_resolved, default: false

      t.timestamps
    end
  end
end
