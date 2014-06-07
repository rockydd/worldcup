class AddOddsToGame < ActiveRecord::Migration
  def change
    add_column :games, :host_odds, :float
    add_column :games, :guest_odds, :float
  end
end
