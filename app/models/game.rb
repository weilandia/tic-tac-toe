$LOAD_PATH.unshift(File.expand_path("./", __dir__))

require 'board'
require 'player'
class Game

  attr_reader :player_1, :player_2, :turn, :game
  def initialize
    @game = Board.new
    @player_1 = Player.new(:x, "#0062FF")
    @player_2 = Player.new(:o, "#FF0099")
    @turn = @player_1
    @move_count = 0
  end

  def move(space)
    return if !@game.spaces.include?(space)
    @game.move_response(@turn, space)
    @move_count += 1
    @turn == player_1 ? @turn = player_2 : @turn = player_1
    return draw if @game.open_spaces.length == 0
    check_for_win
  end

  def check_for_win
    return @turn if @move_count < (@game.dimension * 2) - 1
    status = lines.select { |l, v| v.uniq.length == 1 && v[1] != nil }
    return @turn if status.empty?
    win(status.values[0][0])
  end

  def win(player)
    "#{player.sym} wins!"
  end

  def draw
    "It's a draw!"
  end

  def game_board
    @game.board
  end

  def lines
    { r1: game_board[0].to_a,
      r2: game_board[1].to_a,
      r3: game_board[2].to_a,
      c1: [game_board[0][0],game_board[1][0],game_board[2][0]].to_a,
      c2: [game_board[0][1],game_board[1][1],game_board[1][2]].to_a,
      c3: [game_board[0][2],game_board[1][2],game_board[2][2]].to_a,
      d1: [game_board[0][0],game_board[1][1],game_board[2][2]].to_a,
      d2: [game_board[2][0],game_board[1][1],game_board[0][2]].to_a,
    }
  end
end
