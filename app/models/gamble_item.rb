class GambleItem < ActiveRecord::Base
  belongs_to :gamble
  has_many :bets

  def desc
    "#{description}(#{odds})"
  end

  def odds
    gamble.total_chips / chips
  end

  def chips
    bets.inject(0){|t,b| t + b.amount}
  end
end
