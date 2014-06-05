class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.datetime :date
      t.integer :host_id
      t.integer :guest_id
      t.integer :host_score
      t.integer :guest_score
      t.integer :status

      t.timestamps
    end
  end
end
