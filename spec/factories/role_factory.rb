# == Schema Information
#
# Table name: roles
#
#  id          :uuid             not null, primary key
#  name        :integer
#  description :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_roles_on_name  (name) UNIQUE
#

FactoryBot.define do
  factory :role do
    name { Role::NAMES.sample }
    description { Faker::Lorem.sentence }

    trait :admin do
      name { Role::ADMIN }
      description { Faker::Lorem.sentence }
    end

    trait :super_admin do
      name { Role::SUPER_ADMIN }
      description { Faker::Lorem.sentence }
    end
  end
end
