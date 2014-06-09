class Gamble < ActiveRecord::Base
  has_many :items, :class_name => GambleItem

  def total_chips
    total = items.inject(0){|sum,item| sum + item.chips}
  end

  def odds
    item_odds = items.map{|item|[item, total/item.chips]}
    Hash[*item_odds]
  end
end
