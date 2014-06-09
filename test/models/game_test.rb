require 'test_helper'

class GameTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "create a game should create the gamble accordingly" do
    game = Game.create(:host_id => 1, :guest_id => 2)
    assert game.gamble
  end
end
