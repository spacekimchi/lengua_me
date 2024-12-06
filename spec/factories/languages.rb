# == Schema Information
#
# Table name: languages
#
#  id         :uuid             not null, primary key
#  name       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_languages_on_name  (name) UNIQUE
#

FactoryBot.define do
  factory :language do
    
  end
end
