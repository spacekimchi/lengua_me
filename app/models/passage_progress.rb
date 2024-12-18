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
class PassageProgress < ApplicationRecord
  belongs_to :user
  belongs_to :passage

  before_save :check_current_index

  def check_current_index
    if passage.sentences.count <= current_index
      self.current_index = 0
      self.completed_count += 1
    end
  end
end
