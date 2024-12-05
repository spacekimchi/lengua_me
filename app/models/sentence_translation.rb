class SentenceTranslation < ApplicationRecord
  belongs_to :sentence
  belongs_to :language
end
