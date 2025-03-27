class AddUserToPassages < ActiveRecord::Migration[8.0]
  def change
    add_reference :passages, :user, type: :uuid, foreign_key: true
  end
end
