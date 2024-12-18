# == Schema Information
#
# Table name: difficulties
#
#  id          :uuid             not null, primary key
#  description :text
#  level       :integer          not null
#  name        :text             not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_difficulties_on_level  (level) UNIQUE
#  index_difficulties_on_name   (name) UNIQUE
#
class Difficulty < ApplicationRecord
  # Enum-like values
  DIFFICULTY_LEVELS = {
    basic: 0, a1: 1, a2: 2, b1: 3, b2: 4, c1: 5, c2: 6, native: 7
  }.freeze

  has_many :passages

  # Validations
  validates :name, presence: true, uniqueness: true, inclusion: { in: DIFFICULTY_LEVELS.keys.map(&:to_s) }
  validates :level, presence: true, uniqueness: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  # Scopes
  scope :ordered, -> { order(:level) }

  # Helper method
  def display_name
    name.titleize
  end

  # Class method to fetch all possible values
  def self.difficulties
    DIFFICULTY_LEVELS.keys.map(&:to_s)
  end

  def translated_description
    I18n.t("difficulties.#{name}.description")
  end
end

