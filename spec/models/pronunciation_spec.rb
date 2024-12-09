# == Schema Information
#
# Table name: pronunciations
#
#  id           :uuid             not null, primary key
#  text         :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  tts_voice_id :uuid             not null
#  word_id      :uuid             not null
#
# Indexes
#
#  index_pronunciations_on_tts_voice_id              (tts_voice_id)
#  index_pronunciations_on_word_id                   (word_id)
#  index_pronunciations_on_word_id_and_tts_voice_id  (word_id,tts_voice_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (tts_voice_id => tts_voices.id)
#  fk_rails_...  (word_id => words.id)
#
require 'rails_helper'

RSpec.describe Pronunciation, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
