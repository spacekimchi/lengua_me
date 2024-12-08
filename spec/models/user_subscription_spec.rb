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

require 'rails_helper'

RSpec.describe UserSubscription, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      user_subscription = build(:user_subscription)
      expect(user_subscription).to be_valid
    end
  end

  describe "#is_active?" do
    context "when the subscription is within the active period" do
      let(:user_subscription) { create(:user_subscription, current_period_end: 1.month.from_now.to_i) }

      it "returns true" do
        expect(user_subscription.is_active?).to be true
      end
    end

    context "when the subscription is past the active period" do
      let(:user_subscription) { create(:user_subscription, current_period_end: 1.day.ago.to_i) }

      it "returns false" do
        expect(user_subscription.is_active?).to be false
      end
    end
  end
end
