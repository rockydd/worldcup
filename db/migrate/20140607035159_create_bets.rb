class CreateBets < ActiveRecord::Migration
  def change
    create_table :bets do |t|
      t.integer :game_id
      t.integer :user_id
      t.integer :wager_on
      t.float :amount

      t.timestamps
    end
  end
end
