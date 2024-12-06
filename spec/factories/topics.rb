# == Schema Information
#
# Table name: topics
#
#  id         :uuid             not null, primary key
#  name       :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_topics_on_name  (name) UNIQUE
#

FactoryBot.define do
  factory :topic do
    
  end
end
