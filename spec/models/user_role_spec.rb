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

require 'rails_helper'

RSpec.describe UserRole, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      user = FactoryBot.build(:user)
      expect(user).to be_valid
    end

    it "is not valid without an email" do
      user = FactoryBot.build(:user, email: nil)
      expect(user).not_to be_valid
    end
  end
end
