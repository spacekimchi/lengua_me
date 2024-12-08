# == Schema Information
#
# Table name: user_subscriptions
#
#  id                     :uuid             not null, primary key
#  current_period_end     :bigint
#  current_period_start   :bigint
#  status                 :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  product_id             :uuid
#  product_price_id       :uuid
#  stripe_subscription_id :string(128)
#  user_id                :uuid             not null
#
# Indexes
#
#  index_user_subscriptions_on_product_id              (product_id)
#  index_user_subscriptions_on_product_price_id        (product_price_id)
#  index_user_subscriptions_on_stripe_subscription_id  (stripe_subscription_id) UNIQUE
#  index_user_subscriptions_on_user_id                 (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (product_id => products.id)
#  fk_rails_...  (product_price_id => product_prices.id)
#  fk_rails_...  (user_id => users.id)
#

FactoryBot.define do
  factory :user_subscription do
    association :user
    association :product
    association :product_price

    stripe_subscription_id { Faker::Alphanumeric.alphanumeric(number: 20) }
    status { UserSubscription::STATUSES[:ACTIVE] }
    current_period_start { Time.now.to_i }
    current_period_end { 1.month.from_now.to_i }

    trait :lifetime_subscription do
      stripe_subscription_id { nil } # Indicates a lifetime subscription
      status { UserSubscription::STATUSES[:ACTIVE] }
      current_period_start { Time.now.to_i }
      current_period_end { 100.years.from_now.to_i }
    end

    trait :canceled do
      status { UserSubscription::STATUSES[:CANCELED] }
    end
  end
end
