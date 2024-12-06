# == Schema Information
#
# Table name: topics
#
#  id         :uuid             not null, primary key
#  name       :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_topics_on_name  (name) UNIQUE
#

class Topic < ApplicationRecord
  has_many :passage_topics
  has_many :passages, through: :passage_topics, source: :passage

  validates :name, presence: true
end
