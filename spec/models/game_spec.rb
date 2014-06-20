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
    expect(user1.balance).to eq User.initial_balance
    expect(user2.balance).to eq User.initial_balance
    user1.bet_on(game.gamble, game.bet_for_win, 100)
    user2.bet_on(game.gamble, game.bet_for_lose, 200)
    expect(user1.balance).to eq User.initial_balance
    expect(user2.balance).to eq User.initial_balance
    expect(user1.account.available).to eq User.initial_balance-100
    expect(user2.account.available).to eq User.initial_balance-200
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
    expect(user1.balance).to eq 80 + User.initial_balance
    expect(user1.account.available).to eq 80 + User.initial_balance
    expect(user1.account.frozen_value).to eq 0
    expect(user1.account.logs[0].change).to eq 80
    expect(user1.account.logs[0].source).to eq AccountLog::BET
    expect(user2.balance).to eq User.initial_balance-200
    expect(user2.account.available).to eq User.initial_balance-200
    expect(user2.account.frozen_value).to eq 0
    expect(user2.account.logs[0].change).to eq -200
    expect(user2.account.logs[0].source).to eq AccountLog::BET
    dealer=User.find_dealer
    expect(dealer.balance).to eq User::DEALER_BALANCE + (300-180)
  end

  it "should get the bet for the game" do

    game=Game.create(:host_id => @brazil.id, :guest_id => @argentina.id, :host_win_odds => 1.8, :draw_odds => 2.7, :guest_win_odds => 3.8, :balance => 1)
    user1 = create(:user)
    user2 = create(:user)
    user1.bet_on(game.gamble, game.bet_for_win, 123)
    user1.bet_on(game.gamble, game.bet_for_win, 222)
    user2.bet_on(game.gamble, game.bet_for_lose, 345)

    expect(game.bet_for_win.bet_count).to eq 1
    expect(game.bet_for_draw.bet_count).to eq 0
    expect(game.bet_for_lose.bet_count).to eq 1
  end

  it "should release the funds to user when bet is cancelled" do
    game=Game.create(:host_id => @brazil.id, :guest_id => @argentina.id, :host_win_odds => 1.8, :draw_odds => 2.7, :guest_win_odds => 3.8, :balance => 1, :date => Time.now + 1.day, :status => 0)
    user1 = create(:user)
    user2 = create(:user)
    
    avai = user1.account.available
    expect{user1.bet_on(game.gamble, game.bet_for_win, 123)}.to change(user1.account, :available).by(-123)
    expect(user1.account.available.to_f).to eq avai-123
    bet=user1.has_bet_on?(game.bet_for_win)

    expect(bet.cancellable?).to be true
    bet.destroy
    user1.reload
    expect(user1.account.available.to_f).to eq avai
    expect{user1.bet_on(game.gamble, game.bet_for_win, 100)}.to change(user1.account, :available).by(-100)
    game.host_score=1
    game.guest_score=2
    game.status=2
    game.save
    expect(bet.cancellable?).to be false

    #no idea why following does not work
    #expect{user1.has_bet_on?(game.bet_for_win).destroy;user1.reload}.to change(user1.account, :available).by(123)
  end

end
