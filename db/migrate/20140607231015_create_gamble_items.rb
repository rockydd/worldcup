class CreateGambleItems < ActiveRecord::Migration
  def change
    create_table :gamble_items do |t|
      t.integer :gamble_id
      t.float :odds
      t.string :description
      t.boolean :win

      t.timestamps
    end
  end
end
