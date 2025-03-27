# == Schema Information
#
# Table name: passages
#
#  id            :uuid             not null, primary key
#  category      :integer          default("unassigned")
#  position      :integer          not null
#  title         :text             default("")
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  difficulty_id :uuid             not null
#  user_id       :uuid
#
# Indexes
#
#  index_passages_on_difficulty_id  (difficulty_id)
#  index_passages_on_title_trgm     (title) USING gin
#  index_passages_on_user_id        (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (difficulty_id => difficulties.id)
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Passage, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
