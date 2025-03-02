class AddBaseWordReferenceToWords < ActiveRecord::Migration[8.0]
  def change
    add_reference :words, :base_word, type: :uuid, foreign_key: { to_table: :words }
  end
end
