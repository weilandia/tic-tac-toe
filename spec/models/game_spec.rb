require_relative "../test_helper"

class GameTest < Minitest::Test
  def game_data
    mode = ["human", "human"]
    player_1 = Player.new(:x, "#0062FF", mode[0])
    player_2 = Player.new(:o, "#FF0099", mode[1])
    {
      board: Board.new,
      mode: mode,
      player_1: player_1,
      player_2: player_2,
      turn: player_1,
      move_count: 0
    }
  end

  def test_game_initializes
    assert_equal Game, Game.new(game_data).class
  end

  def test_game_turn_changes_after_move
    g = Game.new(game_data)
    assert_equal :x, g.turn.sym
    g.move([1,2])
    assert_equal :o, g.turn.sym
  end

  def test_game_does_not_respond_to_invalid_input
    g = Game.new(game_data)
    game = g.game
    assert_equal :x, g.turn.sym
    g.move([1,3])
    assert_equal :x, g.turn.sym
    assert_equal game, g.game
  end

  def test_games_end_in_draws
    g = Game.new(game_data)
    g.move([0,0])
    g.move([0,1])
    g.move([0,2])
    g.move([1,0])
    g.move([1,1])
    g.move([1,2])
    g.move([2,0])
    g.move([2,1])
    g.move([2,2])
    assert g.draw?
  end

  def test_games_end_in_wins
    g = Game.new(game_data)
    g.move([0,0])
    g.move([1,1])
    g.move([0,1])
    g.move([1,0])
    g.move([0,2])
    assert g.win?
  end
end
