class EditProviderUniqIndex < ActiveRecord::Migration[8.0]
  def change
    remove_index :tts_voices, name: "index_tts_voices_on_provider_id_and_provider"
    add_index :tts_voices, [:provider_id, :provider, :language_code], unique: true
  end
end
