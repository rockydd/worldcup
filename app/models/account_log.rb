class AccountLog < ActiveRecord::Base
  BET=0
  TAX=1
  DOLE=2
  TAX_REFUND=3
  after_save :notify_mail

  belongs_to :account
  def user
    self.account.user
  end

  def is_bet?
    self.source == BET
  end

  def notify_mail
    UserMailer.account_change(self.user, self).deliver
  end

end
