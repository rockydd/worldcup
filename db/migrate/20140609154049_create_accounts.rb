class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.integer :user_id
      t.decimal :available
      t.decimal :frozen_value

      t.timestamps
    end
  end
end
