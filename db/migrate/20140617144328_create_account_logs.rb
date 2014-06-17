class CreateAccountLogs < ActiveRecord::Migration
  def change
    create_table :account_logs do |t|
      t.integer :account_id
      t.float :change
      t.integer :source
      t.string :description

      t.timestamps
    end
  end
end
