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
  attr_accessor :game_id
  before_destroy :return_funds

  def bet_on
    gamble_item
  end

  def profit
    item=self.gamble_item
    case item.win?
    when true
      return self.amount * (item.odds - 1)
    when false
      return - self.amount
    else
      return 0
    end
  end

  def pay_up
    if self.gamble_item.win?
      return self.user.won_bet(self)
    else
      return self.user.lost_bet(self)
    end
  end

  #check if this can be cancelled
  def cancellable?
    begin
      gamble = self.gamble
      game=Game.find_by_gamble_id(gamble.id)
      debugger
      return game.betable?
    rescue
      return false
    end
  end

  def return_funds
    unless self.cancellable?
      errors.add :base, "cannot cancel this bet"
      return false
    end
    ac = self.user.account
    ac.frozen_value -= self.amount
    ac.available += self.amount
    ac.save
  end
end
