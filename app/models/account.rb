class Account < ActiveRecord::Base
  TAX_CYCLE=23.hours
  TAX_THRESHOLD=0.5
  TAX_RATIO = 0.10

  def self.dole
    poors = Account.where("available < ?", 100).where("frozen_value < ?", 1)
    poors.each do|account|
      account.available=100
      account.save
    end
  end
  def self.tax
    #tax if frozen_value/(frozen_value+available) < 50%

    if frozen_value/(frozen_value+available) < TAX_THRESHOLD
      tax_money = available*TAX_RATIO
      self.available -= tax_money
      logger.info "#{self.user.email} is taxed for #{tax_money}"
    end
  end

  def taxed_in_last_cycle?
    return self.last_tax_time + TAX_CYCLE > TIME.now
  end

  def balance
    self.available + self.frozen_value
  end
  alias :total :balance


end
