class BetValidator < ActiveModel::Validator
  def validate(record)
    if record.bet_on.gamble != record.gamble
      record.errors[:base] << "invalid bet item"
    end
  end
end

class Bet < ActiveRecord::Base
  belongs_to :gamble
  belongs_to :gamble_item
  belongs_to :user
  validates :gamble_item, presence:  true
  validates_associated :gamble
  validates_with BetValidator

  def bet_on
    gamble_item
  end

  def pay_up
    if self.gamble_item.win?
      return self.user.won_bet(self)
    else
      return self.user.lost_bet(self)
    end
  end
end
