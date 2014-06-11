require 'rails_helper'

RSpec.describe Game, :type => :model do
  before :each do
    @brazil = create(:team)
    @argentina = create(:team)
  end

  it "should create gamble with the game" do
    game=Game.create(:host_id => @brazil.id, :guest_id => @argentina.id, :host_win_odds => 1.8, :draw_odds => 2.7, :guest_win_odds => 3.8)
    expect(game.gamble).not_to be_nil
    expect(game.gamble.items.size).to eq 3
    items = game.gamble.items
    expect(game.bet_for_win.odds).to eq 1.8
    expect(game.bet_for_draw.odds).to eq 2.7
    expect(game.bet_for_lose.odds).to eq 3.8
  end
end
