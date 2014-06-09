class AddBetIdToGames < ActiveRecord::Migration
  def change
    add_column :games, :bet_for_win_id, :integer
    add_column :games, :bet_for_draw_id, :integer
    add_column :games, :bet_for_lose_id, :integer
  end
end
