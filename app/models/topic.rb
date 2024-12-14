# == Schema Information
#
# Table name: topics
#
#  id          :uuid             not null, primary key
#  description :text             default("")
#  name        :text             not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_topics_on_name  (name) UNIQUE
#

class Topic < ApplicationRecord
  NAMES = ['sports', 'dating', 'travel', 'food', 'hobbies', 'world news', 'career', 'education', 'art', 'health', 'technology', 'daily life', ' routines', 'environmental', 'social', 'shopping', 'entertainment', 'personal finances', 'safety', 'personal development', 'community service', 'pets', 'transportation', 'cultural etiquette', 'conversations'].freeze
  has_many :passage_topics
  has_many :passages, through: :passage_topics, source: :passage

  validates :name, presence: true
end
