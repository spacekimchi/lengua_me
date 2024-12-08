# == Schema Information
#
# Table name: products
#
#  id                :uuid             not null, primary key
#  description       :string
#  for_subscription  :boolean          default(TRUE), not null
#  is_active         :boolean          default(TRUE), not null
#  name              :string(128)      not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  stripe_product_id :string(128)
#
# Indexes
#
#  index_products_on_stripe_product_id  (stripe_product_id) UNIQUE
#
FactoryBot.define do
  factory :product do
    stripe_product_id { Faker::Alphanumeric.alphanumeric(number: 20) }
    name { Faker::Commerce.product_name }
    description { Faker::Lorem.sentence }
    for_subscription { [true, false].sample }
    is_active { true }

    trait :for_subscription do
      for_subscription { true }
    end

    trait :for_payment do
      for_subscription { false }
    end

    trait :inactive do
      is_active { false }
    end
  end
end
