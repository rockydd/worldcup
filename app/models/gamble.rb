class Gamble < ActiveRecord::Base
  has_many :items, :class_name => GambleItem
  STATUS_OPEN = 'open'
  STATUS_FROZEN = 'frozen'
  STATUS_CLOSED = 'closed'

  def total_chips
    total = items.inject(0){|sum,item| sum + item.chips}
  end

  def odds
    item_odds = items.map{|item|[item, total/item.chips]}
    Hash[*item_odds]
  end

  def close
    self.status = STATUS_CLOSED
    self.save
  end

  def closed?
    self.status == STATUS_CLOSED
  end

  #which item won?
  def set_win_item(win_item)
    items.each do|item|
      item.win = item == win_item
      item.save
    end
  end

  def pay_up
    return nil if self.closed?
    chips_balance = 0
    items.each do |item|
      item.bets.each do |bet|
        chips_balance += bet.pay_up
      end
    end
    self.close
    #dealer will fill the balance gap
    dealer = User.find_dealer
    dealer.account.available -= chips_balance
    dealer.save

  end
end
