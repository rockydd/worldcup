class Account < ActiveRecord::Base
  def self.dole
    poors = Account.where("available < ?", 100).where("frozen_value < ?", 0.0000001)
    poors.each do|account|
      account.available=100
      account.save
    end
  end
  def balance
    self.available + self.frozen_value
  end
  alias :total :balance


end
