# == Schema Information
#
# Table name: words
#
#  id          :uuid             not null, primary key
#  text        :text             not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  language_id :uuid             not null
#
# Indexes
#
#  index_words_on_language_id           (language_id)
#  index_words_on_language_id_and_text  (language_id,text) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (language_id => languages.id)
#
require 'rails_helper'

RSpec.describe Word, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
