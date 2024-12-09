class CreatePronunciations < ActiveRecord::Migration[8.0]
  def change
    create_table :pronunciations, id: :uuid do |t|
      t.references :word, type: :uuid, foreign_key: true, null: false
      t.references :tts_voice, type: :uuid, foreign_key: true, null: false
      t.text :text

      t.timestamps
    end

    add_index :pronunciations, [:word_id, :tts_voice_id], unique: true
  end
end
