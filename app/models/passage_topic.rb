class PassageTopic < ApplicationRecord
  belongs_to :passage
  belongs_to :topic
end
