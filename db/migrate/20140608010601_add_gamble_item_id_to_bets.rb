class AddGambleItemIdToBets < ActiveRecord::Migration
  def change
    add_column :bets, :gamble_item_id, :integer
  end
end
