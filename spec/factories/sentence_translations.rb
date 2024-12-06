# == Schema Information
#
# Table name: sentence_translations
#
#  id          :uuid             not null, primary key
#  sentence_id :uuid             not null
#  language_id :uuid             not null
#  text        :text             not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_sentence_translations_on_language_id                  (language_id)
#  index_sentence_translations_on_sentence_id                  (sentence_id)
#  index_sentence_translations_on_sentence_id_and_language_id  (sentence_id,language_id) UNIQUE
#

FactoryBot.define do
  factory :sentence_translation do
    
  end
end
