class Board

  attr_reader :open_spaces, :spaces_count, :board, :spaces, :dimension, :moves
  def initialize(dimension = 3)
    d = dimension - 1
    @dimension = dimension
    @board = Array.new(dimension) { Array.new(dimension) { nil } }
    @spaces = [*0..d].product([*0..d])
    @spaces_count = @spaces.length
    @open_spaces = [*0..d].product([*0..d])
    @moves = []
  end

  def empty_board?
    open_spaces.length == spaces_count
  end

  def move_response(player, s)
    space_status_accessor(s, player)
    @open_spaces.delete(s)
    @moves << s
    self
  end

  def space_status_accessor(s, player = nil)
    return @board[s.first][s.last] if player == nil
    @board[s.first][s.last] = player
  end
end
