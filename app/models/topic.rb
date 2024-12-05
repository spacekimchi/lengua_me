class Topic < ApplicationRecord
  has_many :passage_topics
  has_many :passages, through: :passage_topics, source: :passage

  validates :name, presence: true
end
