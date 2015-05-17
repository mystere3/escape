class AddLastGamePlayedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_game_played, :integer
  end
end
