$LOAD_PATH.unshift(File.expand_path("../app/models", __dir__))
require 'minitest/autorun'
require 'minitest/pride'
require 'game'

class GameTest < Minitest::Test
  def test_game_initializes
    assert_equal Game, Game.new.class
  end

  def test_game_turn_changes_after_move
    g = Game.new
    assert_equal :x, g.turn.sym
    g.move([1,2])
    assert_equal :o, g.turn.sym
  end

  def test_game_does_not_respond_to_invalid_input
    g = Game.new
    game = g.game
    assert_equal :x, g.turn.sym
    g.move([1,3])
    assert_equal :x, g.turn.sym
    assert_equal game, g.game
  end

  def test_games_end_in_draws
    g = Game.new
    g.move([0,0])
    g.move([0,1])
    g.move([0,2])
    g.move([1,0])
    g.move([1,1])
    g.move([1,2])
    g.move([2,0])
    g.move([2,1])
    assert_equal "It's a draw!", g.move([2,2])
  end

  def test_games_end_in_draws
    g = Game.new
    g.move([0,0])
    g.move([0,1])
    g.move([0,2])
    g.move([1,0])
    g.move([1,1])
    g.move([1,2])
    g.move([2,0])
    g.move([2,1])
    assert_equal "It's a draw!", g.move([2,2])
  end

  def test_games_end_in_draws
    g = Game.new
    g.move([0,0])
    g.move([1,1])
    g.move([0,1])
    g.move([1,0])
    assert_equal "x wins!", g.move([0,2])
  end
end
