# == Schema Information
#
# Table name: passages
#
#  id         :uuid             not null, primary key
#  difficulty :integer          default("basic")
#  title      :text             default("")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :passage do
    
  end
end
