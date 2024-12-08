# == Schema Information
#
# Table name: product_prices
#
#  id              :uuid             not null, primary key
#  currency        :string           default("usd")
#  description     :string
#  interval        :integer          not null
#  is_active       :boolean          default(TRUE), not null
#  lookup_key      :string(128)
#  name            :string(128)      not null
#  price           :integer          default(0), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  product_id      :uuid             not null
#  stripe_price_id :string(128)
#
# Indexes
#
#  index_product_prices_on_lookup_key       (lookup_key) UNIQUE
#  index_product_prices_on_product_id       (product_id)
#  index_product_prices_on_stripe_price_id  (stripe_price_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (product_id => products.id)
#
FactoryBot.define do
  factory :product_price do
    association :product
    stripe_price_id { Faker::Alphanumeric.alphanumeric(number: 20) }
    name { Faker::Commerce.product_name }
    price { Faker::Number.between(from: 1000, to: 10000) } # Represented in cents
    is_active { true }
    interval { ProductPrice.intervals.keys.sample }
    description { Faker::Lorem.sentence }
    lookup_key { Faker::Alphanumeric.alphanumeric(number: 10) }
    currency { 'usd' }

    trait :inactive do
      is_active { false }
    end
  end
end
