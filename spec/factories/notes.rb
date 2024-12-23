# == Schema Information
#
# Table name: notes
#
#  id         :uuid             not null, primary key
#  content    :text             default("")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  passage_id :uuid
#  user_id    :uuid             not null
#
# Indexes
#
#  index_notes_on_passage_id  (passage_id)
#  index_notes_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (passage_id => passages.id)
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :note do
    
  end
end
