# == Schema Information
#
# Table name: application_errors
#
#  id               :uuid             not null, primary key
#  backtrace        :text
#  calling_function :text
#  data             :jsonb
#  is_resolved      :boolean
#  level            :integer          default("triage"), not null
#  message          :text             not null
#  notes            :text
#  resolved_at      :datetime
#  url              :text
#  user_agent       :text
#  user_ip          :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  user_id          :text
#
class ApplicationError < ApplicationRecord
  enum :level, [:triage, :low, :medium, :high, :critical], default: :triage

  def with_backtrace_from_error(e)
    self.backtrace = "\n\t#{e.backtrace.join("\n\t")}"
    self
  end
end
