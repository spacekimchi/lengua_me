class Language < ApplicationRecord
  ENGLISH = 'english'.freeze

  has_many :sentences

  validates :name, presence: true

  def self.english
    Language.find_by!(name: ENGLISH)
  end
end
