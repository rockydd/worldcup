class Game < ActiveRecord::Base
  DEALER_BET_CHIPS = 100
  STATUS_NOT_STARTED = 0
  STATUS_ON_GOING= 1
  STATUS_END = 2
  STATUS_MAP={
    STATUS_NOT_STARTED => "Not Started",
    STATUS_ON_GOING => "OnGoing",
    STATUS_END => "END"
  }

  belongs_to :host, :class_name => Team
  belongs_to :guest, :class_name => Team
  belongs_to :gamble
  belongs_to :bet_for_win, :class_name => GambleItem
  belongs_to :bet_for_draw, :class_name => GambleItem
  belongs_to :bet_for_lose, :class_name => GambleItem

  attr_accessor :host_win_odds, :draw_odds, :guest_win_odds

  before_save :create_gamble
  after_save :update_gamble

  def initialize(params={})
    @host_win_odds = params.delete(:host_win_odds)
    @draw_odds = params.delete(:draw_odds)
    @guest_win_odds = params.delete(:guest_win_odds)
    super(params)
  end

  def readable_status
    STATUS_MAP[self.status]
  end
  def gamble_items
    [self.bet_for_win, self.bet_for_draw, self.bet_for_lose]
  end

  def host_win_odds
    return nil if self.bet_for_win.nil?
    self.bet_for_win.odds
  end
  def draw_odds
    return nil if self.bet_for_draw.nil?
    self.bet_for_draw.odds
  end
  def guest_win_odds
    return nil if self.bet_for_lose.nil?
    self.bet_for_lose.odds
  end
  def bet_desc_for_host
    "#{host.name} win"
  end
  def bet_desc_for_guest
    "#{guest.name} win"
  end

  def ended?
    status == STATUS_END
  end

  #you can bet on the game until 1 hour before the game start
  def betable?
    status == STATUS_NOT_STARTED && self.date && (self.date - 1.hour) > Time.now
  end

  def update_gamble_items
    return nil unless self.ended?
    case self.host_score + self.balance <=> self.guest_score
    when 1
      return gamble.set_win_item(self.bet_for_win)
    when 0
      return gamble.set_win_item(self.bet_for_draw)
    when -1
      return gamble.set_win_item(self.bet_for_lose)
    end
  end

  private
  def create_gamble
    if self.gamble.nil?
      dealer = User.find_dealer
      self.gamble=Gamble.create(:status => Gamble::STATUS_OPEN, :gamble_type => 'match')
      self.bet_for_win = GambleItem.create(:description => "#{host.name} win", :odds => @host_win_odds)
      self.gamble.items << self.bet_for_win

      self.bet_for_draw = GambleItem.create(:description => "draw", :odds => @draw_odds )
      self.gamble.items << self.bet_for_draw

      self.bet_for_lose = GambleItem.create(:description => "#{guest.name} win", :odds => @guest_win_odds)
      self.gamble.items << self.bet_for_lose
    end
  end

  def update_gamble
    begin
      if self.ended?
        update_gamble_items
        gamble.pay_up
      end
    rescue => e
      self.errors[:base] << (e.message)
      logger.error(e.message)
      return false
    end
  end

end
