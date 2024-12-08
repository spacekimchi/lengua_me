# == Schema Information
#
# Table name: sentence_translations
#
#  id          :uuid             not null, primary key
#  text        :text             not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  language_id :uuid             not null
#  sentence_id :uuid             not null
#
# Indexes
#
#  index_sentence_translations_on_language_id                  (language_id)
#  index_sentence_translations_on_sentence_id                  (sentence_id)
#  index_sentence_translations_on_sentence_id_and_language_id  (sentence_id,language_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (language_id => languages.id)
#  fk_rails_...  (sentence_id => sentences.id)
#

require 'rails_helper'

RSpec.describe SentenceTranslation, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
