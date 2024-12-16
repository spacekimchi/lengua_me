# == Schema Information
#
# Table name: passages
#
#  id            :uuid             not null, primary key
#  title         :text             default("")
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  difficulty_id :uuid             not null
#
# Indexes
#
#  index_passages_on_difficulty_id  (difficulty_id)
#
# Foreign Keys
#
#  fk_rails_...  (difficulty_id => difficulties.id)
#
require 'rails_helper'

RSpec.describe Passage, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
