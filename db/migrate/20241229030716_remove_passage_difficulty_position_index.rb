class RemovePassageDifficultyPositionIndex < ActiveRecord::Migration[8.0]
  def change
    remove_index :passages, [:difficulty_id, :position]
  end
end
