class CreateSentenceTranslations < ActiveRecord::Migration[8.0]
  def change
    create_table :sentence_translations, id: :uuid do |t|
      t.references :sentence, type: :uuid, foreign_key: true, null: false
      t.references :language, type: :uuid, foreign_key: true, null: false
      t.text :text, null: false

      t.timestamps
    end

    add_index :sentence_translations, [:sentence_id, :language_id], unique: true
  end
end
