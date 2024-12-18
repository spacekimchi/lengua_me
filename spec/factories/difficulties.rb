# == Schema Information
#
# Table name: difficulties
#
#  id          :uuid             not null, primary key
#  description :text
#  level       :integer          not null
#  name        :text             not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_difficulties_on_level  (level) UNIQUE
#  index_difficulties_on_name   (name) UNIQUE
#
FactoryBot.define do
  factory :difficulty do
    
  end
end
