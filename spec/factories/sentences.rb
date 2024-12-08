# == Schema Information
#
# Table name: sentences
#
#  id          :uuid             not null, primary key
#  content     :text             default("")
#  order_idx   :integer          default(0)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  language_id :uuid
#  passage_id  :uuid
#
# Indexes
#
#  index_sentences_on_language_id  (language_id)
#  index_sentences_on_passage_id   (passage_id)
#
# Foreign Keys
#
#  fk_rails_...  (language_id => languages.id)
#  fk_rails_...  (passage_id => passages.id)
#
FactoryBot.define do
  factory :sentence do
    
  end
end
