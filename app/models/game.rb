class Game < ActiveRecord::Base
  DEALER_BET_CHIPS = 100
  belongs_to :host, :class_name => Team
  belongs_to :guest, :class_name => Team
  belongs_to :gamble
  belongs_to :bet_for_win, :class_name => GambleItem
  belongs_to :bet_for_draw, :class_name => GambleItem
  belongs_to :bet_for_lose, :class_name => GambleItem

  before_save :create_gamble

  def gamble_items
    [self.bet_for_win, self.bet_for_draw, self.bet_for_lose]
  end

  def bet_desc_for_host
    "#{host.name} win"
  end
  def bet_desc_for_guest
    "#{guest.name} win"
  end

  private
  def create_gamble
    if self.gamble.nil?
      dealer = User.find_dealer
      self.gamble=Gamble.create(:status => 'not started', :gamble_type => 'match')
      self.bet_for_win = GambleItem.create(:description => "#{host.name} win")
      self.gamble.items << self.bet_for_win
      dealer.bet_on(gamble, self.bet_for_win, DEALER_BET_CHIPS)

      self.bet_for_draw = GambleItem.create(:description => "draw" )
      self.gamble.items << self.bet_for_draw
      dealer.bet_on(gamble, self.bet_for_draw, DEALER_BET_CHIPS)

      self.bet_for_lose = GambleItem.create(:description => "#{guest.name} win")
      self.gamble.items << self.bet_for_lose
      dealer.bet_on(gamble, self.bet_for_lose, DEALER_BET_CHIPS)
    end
  end
end
