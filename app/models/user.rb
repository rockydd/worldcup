require 'rubygems'
require 'role_model'
class User < ActiveRecord::Base
  INITIAL_BALANCE=1000
  DEALER_EMAIL="worldcupdealer@gmail.com"
  DEALER_BALANCE=100000000
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  has_many :bets
  has_many :gambles, through: :bets
  has_one :account
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  include RoleModel
  roles_attribute :roles_mask
  roles :admin, :player, :guest
  before_save :set_default_role
  after_save :initial_account

  def self.dealer_password
    'password'
    #:password => (0...8).map { (65 + rand(26)).chr }.join)
  end

  def self.find_dealer
    User.find_by_email(DEALER_EMAIL) || User.create(:email => DEALER_EMAIL, :password => dealer_password, :roles_mask => 1)
  end

  def self.regular_user
    users = User.where.not(email: DEALER_EMAIL)
  end
  def self.top_10(user=nil)
    sorted_users = regular_user.sort{|u1, u2| - (u1.balance <=> u2.balance) }
    my_rank = user.nil? ? nil : sorted_users.find_index(user)
    return sorted_users[0,10], my_rank
  end

  def balance
    self.save unless self.account
    self.account.available + self.account.frozen_value
  end

  def is_dealer?
    self.email == DEALER_EMAIL
  end

  def set_default_role
    self.roles = [:player] if self.roles.empty?
  end

  def initial_account
    unless self.account
      self.account = Account.create(:available => is_dealer? ? DEALER_BALANCE : INITIAL_BALANCE,:frozen_value => 0)
    end
  end

  def has_bet?(gamble)
    bets.find{|bet|bet.gamble == gamble}
  end

  def has_bet_on?(gamble_item)
    bets.find{|bet|bet.gamble_item == gamble_item}
  end

  def bets_for_gamble(gamble)
    bets.select{|bet| bet.gamble == gamble}
  end

  def bet_on(gamble, gamble_item, amount)
    raise 'invalid bet chips' if amount < 1
    raise 'not enough chips' if amount > self.account.available
    raise 'invalid gamble' if gamble.nil? || gamble_item.nil? || gamble_item.gamble != gamble
    raise 'gamble is closed' if gamble.closed?

    if bet=has_bet_on?(gamble_item)
      bet.update({:gamble_id => gamble.id, :gamble_item_id => gamble_item.id, :amount => bet.amount + amount})
    else
      bet = Bet.create({:gamble_id => gamble.id, :gamble_item_id => gamble_item.id, :amount => amount, :user_id => self.id})
      self.bets<<bet
    end
    self.account.available -= amount
    self.account.frozen_value += amount
    self.account.save
    return bet
  end

  def won_bet(bet)
    raise 'invalid bet' unless bet.user == self
    chips = bet.amount * bet.gamble_item.odds
    self.account.available += chips
    self.account.frozen_value -= bet.amount
    self.account.save
    self.save
    return chips
  end

  def lost_bet(bet)
    raise 'invalid bet' unless bet.user == self
    self.account.frozen_value -= bet.amount
    self.account.save
    self.save
    return bet.amount
  end
end
