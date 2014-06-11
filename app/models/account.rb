class Account < ActiveRecord::Base
  def balance
    self.available + self.frozen_value
  end
  alias :total :balance

end
