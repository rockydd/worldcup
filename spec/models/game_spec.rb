require 'rails_helper'

RSpec.describe Game, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
  it "should create gamble with the game" do
    game=Game.create(:host_id => 1, :guest_id => 2)
    game.gamble.should_not be_nil
  end
end
