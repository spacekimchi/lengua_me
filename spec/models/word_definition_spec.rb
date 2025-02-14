# == Schema Information
#
# Table name: word_definitions
#
#  id               :uuid             not null, primary key
#  definition       :text             not null
#  example_sentence :text
#  part_of_speech   :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  word_id          :uuid             not null
#
# Indexes
#
#  index_word_definitions_on_word_id  (word_id)
#
# Foreign Keys
#
#  fk_rails_...  (word_id => words.id)
#
require 'rails_helper'

RSpec.describe WordDefinition, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
