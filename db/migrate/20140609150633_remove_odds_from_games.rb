class RemoveOddsFromGames < ActiveRecord::Migration
  def change
    remove_column :games, :host_odds, :float
    remove_column :games, :guest_odds, :float
  end
end
