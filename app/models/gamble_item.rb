class GambleItem < ActiveRecord::Base
  belongs_to :gamble
  has_many :bets

  def desc
    "#{description}(#{odds.round(2)})"
  end

  def win?
    win
  end

  def chips
    bets.inject(0){|t,b| t + b.amount}
  end
end
