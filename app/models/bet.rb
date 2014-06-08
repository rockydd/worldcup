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
  validates :gamble_item, presence:  true
  validates_associated :gamble
  validates_with BetValidator

  def bet_on
    gamble_item
  end
end
