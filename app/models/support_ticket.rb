# == Schema Information
#
# Table name: support_tickets
#
#  id             :uuid             not null, primary key
#  author_email   :string           not null
#  content        :text             not null
#  priority       :integer          default("medium"), not null
#  resolved_at    :datetime
#  status         :integer          default("open"), not null
#  subject        :string           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  assigned_to_id :uuid
#  user_id        :uuid
#
# Indexes
#
#  index_support_tickets_on_assigned_to_id  (assigned_to_id)
#  index_support_tickets_on_author_email    (author_email)
#  index_support_tickets_on_priority        (priority)
#  index_support_tickets_on_status          (status)
#  index_support_tickets_on_user_id         (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (assigned_to_id => users.id)
#  fk_rails_...  (user_id => users.id)
#
class SupportTicket < ApplicationRecord
  LOW = :low
  OPEN = :open
  belongs_to :user, optional: true
  belongs_to :assigned_to, class_name: 'User', optional: true

  validates :author_email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :subject, presence: true
  validates :content, presence: true

  enum :status, [:open, :in_progress, :closed], default: :open
  enum :priority, [:low, :medium, :high, :critical], default: :medium

  def assign_to_user(user)
    update(assigned_to: user)
  end
end
