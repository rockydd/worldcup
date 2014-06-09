class RemoveOddsFromGambleItems < ActiveRecord::Migration
  def change
    remove_column :gamble_items, :odds, :float
  end
end
