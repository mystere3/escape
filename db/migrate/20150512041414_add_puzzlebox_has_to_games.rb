class AddPuzzleboxHasToGames < ActiveRecord::Migration
  def change
    add_column :games, :puzzlebox_has, :boolean
  end
end
