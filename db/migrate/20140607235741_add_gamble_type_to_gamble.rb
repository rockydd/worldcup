class AddGambleTypeToGamble < ActiveRecord::Migration
  def change
    add_column :gambles, :gamble_type, :string
  end
end
