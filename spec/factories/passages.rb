# == Schema Information
#
# Table name: passages
#
#  id            :uuid             not null, primary key
#  category      :integer          default("unassigned")
#  position      :integer          not null
#  title         :text             default("")
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  difficulty_id :uuid             not null
#
# Indexes
#
#  index_passages_on_difficulty_id  (difficulty_id)
#  index_passages_on_title_trgm     (title) USING gin
#
# Foreign Keys
#
#  fk_rails_...  (difficulty_id => difficulties.id)
#
FactoryBot.define do
  factory :passage do
    
  end
end
