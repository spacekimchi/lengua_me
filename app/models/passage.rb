class Passage < ApplicationRecord
  has_many :sentences, dependent: :destroy
  has_many :passage_topics
  has_many :topics, through: :passage_topics, source: :topic

  enum :difficulty, [:basic, :a1, :a2, :b1, :b2, :c1, :c2, :native], default: :basic
end
