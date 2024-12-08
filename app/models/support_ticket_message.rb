# == Schema Information
#
# Table name: support_ticket_messages
#
#  id                :uuid             not null, primary key
#  content           :text             not null
#  internal          :boolean          default(FALSE)
#  recipient_email   :text
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  support_ticket_id :uuid             not null
#  user_id           :uuid             not null
#
# Indexes
#
#  index_support_ticket_messages_on_support_ticket_id  (support_ticket_id)
#  index_support_ticket_messages_on_user_id            (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (support_ticket_id => support_tickets.id)
#  fk_rails_...  (user_id => users.id)
#
class SupportTicketMessage < ApplicationRecord
  belongs_to :support_ticket
end
