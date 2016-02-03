$LOAD_PATH.unshift(File.expand_path("../app/models", __dir__))
require 'minitest/autorun'
require 'minitest/pride'
require 'player'

class PlayerTest < Minitest::Test
  def test_player_initializes
    assert_equal Player, Player.new(:x, "#000000").class
  end
end
