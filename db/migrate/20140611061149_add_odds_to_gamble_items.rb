class AddOddsToGambleItems < ActiveRecord::Migration
  def change
    add_column :gamble_items, :odds, :float
  end
end
