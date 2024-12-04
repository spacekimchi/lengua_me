class CreateSupportTicketMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :support_ticket_messages, id: :uuid do |t|
      t.references :support_ticket, type: :uuid, null: false, foreign_key: true
      t.references :user, type: :uuid, null: false, foreign_key: true
      t.text :content, null: false
      t.text :recipient_email
      t.boolean :internal, default: false

      t.timestamps
    end
  end
end
