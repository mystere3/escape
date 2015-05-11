class AddObjectsHashToGame < ActiveRecord::Migration
  def change
    add_column :games , :objects_array , :string, array: true , default: []
  end
end
