class CreateGambles < ActiveRecord::Migration
  def change
    create_table :gambles do |t|
      t.string :type
      t.string :status

      t.timestamps
    end
  end
end
