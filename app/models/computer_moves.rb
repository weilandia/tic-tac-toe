module ComputerMoves
  def cpu_move
    return first_move if @game.empty_board?
    move(@game.open_spaces.sample)
  end

  def first_move
    move([0,0])
  end
end
