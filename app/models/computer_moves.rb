module ComputerMoves
  def cpu_move
    move(@game.open_spaces.sample)
  end
end
