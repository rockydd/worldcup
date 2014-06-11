require 'rails_helper'

RSpec.describe Game, :type => :model do
  before :each do
    @brazil = create(:team)
    @argentina = create(:team)
  end

  it "should create gamble with the game" do
    game=Game.create(:host_id => @brazil.id, :guest_id => @argentina.id, :host_win_odds => 1.8, :draw_odds => 2.7, :guest_win_odds => 3.8, :balance => 1)
    expect(game.gamble).not_to be_nil
    expect(game.gamble.items.size).to eq 3
    items = game.gamble.items
    expect(game.bet_for_win.odds).to eq 1.8
    expect(game.bet_for_draw.odds).to eq 2.7
    expect(game.bet_for_lose.odds).to eq 3.8
    game.host_score = 3
    game.guest_score = 1
    game.save
  end

  it "should close the gamble and pay up when game end" do
    game=Game.create(:host_id => @brazil.id, :guest_id => @argentina.id, :host_win_odds => 1.8, :draw_odds => 2.7, :guest_win_odds => 3.8, :balance => 1)
    user1 = create(:user)
    user2 = create(:user)
    expect(user1.balance).to eq 1000
    expect(user2.balance).to eq 1000
    user1.bet_on(game.gamble, game.bet_for_win, 100)
    user2.bet_on(game.gamble, game.bet_for_lose, 200)
    expect(user1.balance).to eq 1000
    expect(user2.balance).to eq 1000
    expect(user1.account.available).to eq 900
    expect(user2.account.available).to eq 800
    expect(user1.account.frozen_value).to eq 100
    expect(user2.account.frozen_value).to eq 200
    expect(game.gamble.total_chips).to eq(300)
    game.host_score = 3
    game.guest_score = 1
    game.status = 2
    game.save
    expect(game.gamble.closed?).to be true
    expect(game.ended?).to be true
    user1.reload
    user2.reload
    expect(user1.balance).to eq 1080
    expect(user1.account.available).to eq 1080
    expect(user1.account.frozen_value).to eq 0
    expect(user2.balance).to eq 800
    expect(user2.account.available).to eq 800
    expect(user2.account.frozen_value).to eq 0
    dealer=User.find_dealer
    expect(dealer.balance).to eq User::DEALER_BALANCE + (300-180)
  end

end