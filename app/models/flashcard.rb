class Flashcard < ApplicationRecord
  belongs_to :user
  belongs_to :deck

  enum :flashcard_type, [:normal, :cloze], default: :normal
end
