class Game < ActiveRecord::Base
  belongs_to :host, :class_name => Team
  belongs_to :guest, :class_name => Team
  belongs_to :gamble

  before_save :create_gamble

  def bet_desc_for_host
    "#{host.name} win"
  end
  def bet_desc_for_guest
    "#{guest.name} win"
  end
  def bet_id_for_host
    gamble.items.find{|i| i.description == bet_desc_for_host}.id
  end
  def bet_id_for_guest
    gamble.items.find{|i| i.description == bet_desc_for_guest}.id
  end

  private
  def create_gamble
    if self.gamble.nil?
      self.gamble=Gamble.create(:status => 'not started', :gamble_type => 'match')
      self.gamble.items << GambleItem.create(:description => "#{host.name} win", :odds => host_odds)
      self.gamble.items << GambleItem.create(:description => "#{guest.name} win", :odds => guest_odds)
    end
  end
end
