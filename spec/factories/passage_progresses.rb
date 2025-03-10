# == Schema Information
#
# Table name: passage_progresses
#
#  id              :uuid             not null, primary key
#  completed_count :integer          default(0)
#  current_index   :integer          default(0)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  passage_id      :uuid             not null
#  user_id         :uuid             not null
#
# Indexes
#
#  index_passage_progresses_on_passage_id              (passage_id)
#  index_passage_progresses_on_user_id                 (user_id)
#  index_passage_progresses_on_user_id_and_passage_id  (user_id,passage_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (passage_id => passages.id)
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :passage_progress do
    
  end
end
