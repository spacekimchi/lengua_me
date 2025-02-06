class AddNullToDecksName < ActiveRecord::Migration[8.0]
  def change
    change_column_null :decks, :name, false
  end
end
