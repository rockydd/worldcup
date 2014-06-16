class AddTaxTimeToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :last_tax_time, :datetime
  end
end
