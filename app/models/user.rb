require 'rubygems'
require 'role_model'
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  has_many :bets
  has_many :gambles, through: :bets
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  include RoleModel
  roles_attribute :roles_mask
  roles :admin, :player, :guest
  before_save :set_default_role

  def set_default_role
    self.roles = [:player] if self.roles.empty?
  end

  def has_bet?(gamble)
    bets.find{|bet|bet.gamble == gamble}
  end

  def bet_on(gamble_id, gamble_item_id, amount)
    gamble = Gamble.find(gamble_id)
    if bet=has_bet?(gamble)
      bet.update({:gamble_id => gamble_id, :gamble_item_id => gamble_item_id, :amount => amount})
    else
      bet = Bet.new({:gamble_id => gamble_id, :gamble_item_id => gamble_item_id, :amount => amount, :user_id => self.id})
    end
    return bet
  end
end
