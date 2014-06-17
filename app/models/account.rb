require 'util'

class Account < ActiveRecord::Base
  extend Util
  TAX_CYCLE=23.hours
  TAX_THRESHOLD=0.5
  TAX_RATIO = 0.10
  belongs_to :user
  has_many :logs, :class_name => AccountLog

  def self.dole
    dole_value = get_value_from_config("dole_value")||100
    poors = Account.where("available < ?", dole_value).where("frozen_value < ?", 1)
    poors.each do|account|
      change=dole_value-account.available
      account.available=dole_value
      account.save
      #create a change log
      AccountLog.create(account_id: account.id, change: change, source:AccountLog::DOLE, description: "get dole of #{change}")

    end
  end
  def self.tax
    #tax if frozen_value/(frozen_value+available) < 50%

    Account.all.each do|account|

      frozen_value = account.frozen_value
      available = account.available
      if frozen_value/(frozen_value+available) < TAX_THRESHOLD and not account.taxed_in_last_cycle?
        user=account.user
        next if user and user.is_dealer?
        tax_money = available*TAX_RATIO
        account.available -= tax_money
        if user
          msg = "#{user.email} is taxed for #{tax_money}"
          logger.info msg
        end
        AccountLog.create(account_id: account.id, change: -tax_money, source:AccountLog::TAX, description: "taxed #{tax_money}")
        account.last_tax_time=Time.now
        account.save
      end
    end
  end

  def taxed_in_last_cycle?
    return false if self.last_tax_time.nil?
    return (self.last_tax_time + TAX_CYCLE )> Time.now
  end

  def balance
    self.available + self.frozen_value
  end
  alias :total :balance


end
