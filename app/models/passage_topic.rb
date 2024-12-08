# == Schema Information
#
# Table name: passage_topics
#
#  id         :uuid             not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  passage_id :uuid             not null
#  topic_id   :uuid             not null
#
# Indexes
#
#  index_passage_topics_on_passage_id               (passage_id)
#  index_passage_topics_on_passage_id_and_topic_id  (passage_id,topic_id) UNIQUE
#  index_passage_topics_on_topic_id                 (topic_id)
#
# Foreign Keys
#
#  fk_rails_...  (passage_id => passages.id)
#  fk_rails_...  (topic_id => topics.id)
#

class PassageTopic < ApplicationRecord
  belongs_to :passage
  belongs_to :topic
end
