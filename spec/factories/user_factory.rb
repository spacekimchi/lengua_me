# == Schema Information
#
# Table name: users
#
#  id                    :uuid             not null, primary key
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  username              :string           not null
#  email                 :string           not null
#  encrypted_password    :string(128)      not null
#  confirmation_token    :string(128)
#  remember_token        :string(128)      not null
#  stripe_customer_id    :string
#  verification_token    :string
#  verified_at           :datetime
#  verified_requested_at :datetime
#
# Indexes
#
#  index_users_on_confirmation_token  (confirmation_token) UNIQUE
#  index_users_on_email               (email) UNIQUE
#  index_users_on_remember_token      (remember_token) UNIQUE
#  index_users_on_stripe_customer_id  (stripe_customer_id) UNIQUE
#

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    username { Faker::Internet.username }
    password { Faker::Internet.password }
    remember_token { Faker::Internet.password }

    trait :with_admin do
      after(:create) do |user|
        create(:user_role, :with_admin, user: user)
      end
    end

    trait :with_super_admin do
      after(:create) do |user|
        create(:user_role, :with_super_admin, user: user)
      end
    end
  end
end
