require_relative "../test_helper"

class CPUHumanGameTest < Minitest::Test
  def game_data
    mode = []
    player_1 = Player.new(:x, "#0062FF", mode[0])
    player_2 = Player.new(:o, "#FF0099", mode[1])
    {
      board: Board.new,
      mode: mode,
      player_1: player_1,
      player_2: player_2,
      turn: player_1,
      on_deck: player_2,
      move_count: 0
    }
  end

  def test_cpu_plays_center_first
    ch = Game.new(game_data)
    ch.cpu_move
    refute ch.open_spaces.include?([1,1])

    hc = Game.new(game_data)
    hc.move([0,0])
    hc.cpu_move
    refute hc.open_spaces.include?([1,1])
  end

  def test_cpu_plays_top_left_if_center_taken
    g = Game.new(game_data)
    g.move([1,1])
    g.cpu_move
    refute g.open_spaces.include?([0,0])
  end

  def test_check_for_danger_lines
    g = Game.new(game_data)
    g.move([1,0])
    g.move([0,1])
    g.move([1,1])
    assert_equal :r2, g.danger_line.keys[0]
  end

  def test_check_for_danger_lines_returns_nil
    g = Game.new(game_data)
    g.move([1,0])
    g.move([0,1])
    assert_equal nil, g.danger_line
  end

  def test_cpu_goes_for_win
    g = Game.new(game_data)
    g.cpu_move
    g.move([0,1]) #human
    g.move([0,0])
    g.move([0,2]) #human
    g.cpu_move
    assert g.win?
    refute g.open_spaces.include?([2,2])
  end

  def test_cpu_blocks
    g = Game.new(game_data)
    g.move([1,0])
    g.move([0,1])
    g.move([1,1])
    g.cpu_move
    refute g.open_spaces.include?([1,2])
  end

  def test_cpu_attacks_corners
    g = Game.new(game_data)
    g.cpu_move
    g.move([0,1])
    g.cpu_move
    refute g.open_spaces.include?([0,0])
  end
end
