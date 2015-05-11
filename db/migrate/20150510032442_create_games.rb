class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.boolean :gloves_has
      t.boolean :mop_has
      t.boolean :knife_has
      t.boolean :door_locked
      t.boolean :door_open
      t.boolean :desk_open
      t.boolean :pen_has
      t.boolean :paper_has
      t.text :paper_content
      t.boolean :puzzlebox_open
      t.boolean :key_has
      t.boolean :glassbox_open
      t.boolean :circuitbox_open
      t.boolean :lights_on
      t.boolean :outlets_on
      t.boolean :horror_in_room
      t.boolean :horror_staggered
      t.boolean :horror_stabbed
      t.boolean :floor_wet
      t.integer :turns_remain
      t.boolean :game_over
      t.integer :end_count



      t.timestamps null: false
    end
  end
end
