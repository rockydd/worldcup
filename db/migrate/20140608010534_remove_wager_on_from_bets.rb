class RemoveWagerOnFromBets < ActiveRecord::Migration
  def change
    remove_column :bets, :wager_on, :integer
  end
end
