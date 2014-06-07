class AddBalanceToGames < ActiveRecord::Migration
  def change
    add_column :games, :balance, :float
  end
end
