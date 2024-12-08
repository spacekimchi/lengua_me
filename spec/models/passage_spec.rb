# == Schema Information
#
# Table name: passages
#
#  id         :uuid             not null, primary key
#  difficulty :integer          default("basic")
#  title      :text             default("")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Passage, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
