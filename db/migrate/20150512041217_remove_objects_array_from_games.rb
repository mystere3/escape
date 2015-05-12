class RemoveObjectsArrayFromGames < ActiveRecord::Migration
  def change
    remove_column :games , :objects_array , :string, array: true , default: []
  end
end
