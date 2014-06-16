class Account < ActiveRecord::Base
  TAX_CYCLE=23.hours
  TAX_THRESHOLD=0.5
  TAX_RATIO = 0.10
  belongs_to :user

  def self.dole
    poors = Account.where("available < ?", 100).where("frozen_value < ?", 1)
    poors.each do|account|
      account.available=100
      account.save
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
          logger.info "#{user.email} is taxed for #{tax_money}"
        end
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
