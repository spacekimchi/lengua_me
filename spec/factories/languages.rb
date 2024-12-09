# == Schema Information
#
# Table name: languages
#
#  id         :uuid             not null, primary key
#  code       :text
#  name       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_languages_on_code  (code) UNIQUE
#  index_languages_on_name  (name) UNIQUE
#

FactoryBot.define do
  factory :language do
    
  end
end
