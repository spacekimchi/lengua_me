# == Schema Information
#
# Table name: topics
#
#  id          :uuid             not null, primary key
#  description :text             default("")
#  name        :text             not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_topics_on_name  (name) UNIQUE
#

require 'rails_helper'

RSpec.describe Topic, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
