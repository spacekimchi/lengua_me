class CreatePassageTopics < ActiveRecord::Migration[8.0]
  def change
    create_table :passage_topics, id: :uuid do |t|
      t.references :passage, type: :uuid, foreign_key: true, null: false
      t.references :topic, type: :uuid, foreign_key: true, null: false

      t.timestamps
    end

    add_index :passage_topics, [:passage_id, :topic_id], unique: true
  end
end
