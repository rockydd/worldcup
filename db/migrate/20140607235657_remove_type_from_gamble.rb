class RemoveTypeFromGamble < ActiveRecord::Migration
  def change
    remove_column :gambles, :type, :string
  end
end
