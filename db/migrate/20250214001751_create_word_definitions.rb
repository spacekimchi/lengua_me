class CreateWordDefinitions < ActiveRecord::Migration[8.0]
  def change
    create_table :word_definitions, id: :uuid do |t|
      t.references :word, type: :uuid, foreign_key: true, null: false
      t.text :definition, null: false
      t.text :part_of_speech
      t.text :example_sentence

      t.timestamps
    end
  end
end
