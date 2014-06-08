class AddGambleIdToBets < ActiveRecord::Migration
  def change
    add_column :bets, :gamble_id, :integer
  end
end
