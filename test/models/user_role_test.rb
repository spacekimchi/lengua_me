# == Schema Information
#
# Table name: user_roles
#
#  id         :uuid             not null, primary key
#  user_id    :uuid             not null
#  role_id    :uuid             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_user_roles_on_role_id  (role_id)
#  index_user_roles_on_user_id  (user_id)
#

require "test_helper"

class UserRoleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
