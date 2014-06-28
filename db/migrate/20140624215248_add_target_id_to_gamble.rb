class AddTargetIdToGamble < ActiveRecord::Migration
  def up
    add_column :gambles, :target_id, :integer
    Game.all.each do|game|
      game.gamble.target_id=game.id
      game.gamble.save
    end
  end
  def down
    remove_column :gambles, :target_id
  end
end
