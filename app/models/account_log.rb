class AccountLog < ActiveRecord::Base
  BET=0
  TAX=1
  DOLE=2

  belongs_to :account
  def user
    self.account.user
  end

  def is_bet?
    self.source == BET
  end
end
