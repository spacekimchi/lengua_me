# == Schema Information
#
# Table name: languages
#
#  id         :uuid             not null, primary key
#  name       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_languages_on_name  (name) UNIQUE
#

class Language < ApplicationRecord
  ENGLISH = 'english'.freeze

  has_many :sentences

  validates :name, presence: true

  def self.english
    Language.find_by!(name: ENGLISH)
  end
end
