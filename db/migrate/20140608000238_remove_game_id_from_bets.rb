class RemoveGameIdFromBets < ActiveRecord::Migration
  def change
    remove_column :bets, :game_id, :integer
  end
end
