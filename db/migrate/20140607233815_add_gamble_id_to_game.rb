class AddGambleIdToGame < ActiveRecord::Migration
  def change
    add_column :games, :gamble_id, :integer
  end
end
