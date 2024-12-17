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
