$LOAD_PATH.unshift(File.expand_path("./", __dir__))

require 'board'
require 'player'
class Game

  attr_reader :player_1, :player_2, :turn, :game, :move_count
  def initialize(data)
    @game = data[:board]
    @player_1 = data[:player_1]
    @player_2 = data[:player_2]
    @turn = data[:turn]
    @move_count = data[:move_count]
  end

  def move(space)
    return if !@game.open_spaces.include?(space)
    @game.move_response(@turn, space)
    @move_count += 1
  end

  def change_turns
    @turn.sym == :x ? @turn = player_2 : @turn = player_1
  end

  def win?
    return if @move_count < (@game.dimension * 2) - 1
    status = lines.select { |l, v| !v.include?(nil) }
    winner = status.select do |l, v|
      v.map(&:sym).uniq.length == 1
    end
    !winner.empty?
  end

  def draw?
    @game.open_spaces.length == 0
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
