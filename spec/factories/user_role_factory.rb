# == Schema Information
#
# Table name: user_roles
#
#  id         :uuid             not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  role_id    :uuid             not null
#  user_id    :uuid             not null
#
# Indexes
#
#  index_user_roles_on_role_id  (role_id)
#  index_user_roles_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (role_id => roles.id)
#  fk_rails_...  (user_id => users.id)
#

FactoryBot.define do
  factory :user_role do
    user

    trait :with_admin do
      association :role, factory: [:role, :admin]
    end

    trait :with_super_admin do
      association :role, factory: [:role, :super_admin]
    end
  end
end
