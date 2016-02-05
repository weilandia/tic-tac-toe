require_relative "../test_helper"

class PlayerTest < Minitest::Test
  def test_player_initializes
    assert_equal Player, Player.new(:x, "#000000", ["hch","hcc"]).class
  end
end
