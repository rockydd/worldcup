class CreateRanks < ActiveRecord::Migration
  def change
    create_table :ranks do |t|
      t.string :name
      t.integer :user_id
      t.integer :rank
      t.float :value

      t.timestamps
    end
  end
end
