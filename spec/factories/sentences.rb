# == Schema Information
#
# Table name: sentences
#
#  id           :uuid             not null, primary key
#  content      :text             default("")
#  hints        :text             default([]), is an Array
#  order_idx    :integer          default(0)
#  prefix       :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  language_id  :uuid
#  passage_id   :uuid
#  tts_voice_id :uuid             not null
#
# Indexes
#
#  index_sentences_on_language_id   (language_id)
#  index_sentences_on_passage_id    (passage_id)
#  index_sentences_on_tts_voice_id  (tts_voice_id)
#
# Foreign Keys
#
#  fk_rails_...  (language_id => languages.id)
#  fk_rails_...  (passage_id => passages.id)
#  fk_rails_...  (tts_voice_id => tts_voices.id)
#
FactoryBot.define do
  factory :sentence do
    
  end
end
