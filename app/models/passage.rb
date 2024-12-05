class Passage < ApplicationRecord
  GRADE_LEVELS = %w[kindergarten 1st 2nd 3rd 4th 5th 6th 7th 8th 9th 10th 11th 12th].freeze

  has_many :sentences, dependent: :destroy
  has_many :passage_topics
  has_many :topics, through: :passage_topics, source: :topic

  enum :difficulty, [:basic, :a1, :a2, :b1, :b2, :c1, :c2, :native]
end
