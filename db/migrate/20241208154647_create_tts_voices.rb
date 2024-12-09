class CreateTtsVoices < ActiveRecord::Migration[8.0]
  def change
    create_table :tts_voices, id: :uuid do |t|
      t.text :accent
      t.text :language_code, null: false
      t.text :gender, null: false
      t.text :name, null: false
      t.text :provider_id, null: false
      t.integer :provider, null: false, default: 0
    end

    add_index :tts_voices, [:name, :provider], unique: true
    add_index :tts_voices, :language_code
    add_index :tts_voices, :provider
  end
end
