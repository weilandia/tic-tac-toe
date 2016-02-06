class Game
  include ComputerMoves

  attr_reader :player_1, :player_2, :turn, :on_deck, :game, :move_count, :winner, :moves
  def initialize(data)
    @game = data[:board]
    @mode = data[:mode]
    @player_1 = data[:player_1]
    @player_2 = data[:player_2]
    @turn = data[:turn]
    @on_deck = data[:on_deck]
    @move_count = data[:move_count]
    @winner = winner
  end

  def move(space)
    return if !@game.open_spaces.include?(space)
    @move_count += 1
    @game.move_response(@turn, space)
    check_winner
    return if win?
    change_turns
    @game.board
  end

  def check_winner
    win? ? @winner = turn : nil
  end

  def change_turns
    turn.sym == :x ? @turn = player_2 : @turn = player_1
    turn.sym == :o ? @on_deck = player_1 : @on_deck = player_2
  end

  def win?
    return if @move_count < (@game.dimension * 2) - 1
    status = lines.select { |l, v| !v.include?(nil) }
    w = status.select { |l, v| v.map(&:sym).uniq.length == 1 }
    !w.empty?
  end

  def draw?
    @game.open_spaces.length == 0
  end

  def game_board
    @game.board
  end

  def open_spaces
    @game.open_spaces
  end

  def lines
    { r1: game_board[0].to_a,
      r2: game_board[1].to_a,
      r3: game_board[2].to_a,
      c1: [game_board[0][0],game_board[1][0],game_board[2][0]].to_a,
      c2: [game_board[0][1],game_board[1][1],game_board[2][1]].to_a,
      c3: [game_board[0][2],game_board[1][2],game_board[2][2]].to_a,
      d1: [game_board[0][0],game_board[1][1],game_board[2][2]].to_a,
      d2: [game_board[2][0],game_board[1][1],game_board[0][2]].to_a,
    }
  end
end
