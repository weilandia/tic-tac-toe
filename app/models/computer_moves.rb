module ComputerMoves
  MAP =
    {r1: [[0,0], [0,1], [0,2]],
      r2: [[1,0], [1,1], [1,2]],
      r3: [[2,0], [2,1], [2,2]],
      c1: [[0,0], [1,0], [2,0]],
      c2: [[0,1], [1,1], [2,1]],
      c3: [[0,2], [1,2], [2,2]],
      d1: [[0,0], [1,1], [2,2]],
      d2: [[0,2], [1,1], [2,0]]
      }

  def cpu_move
    return move([1,1]) if center_open?
    return go_for_win if !win_line.nil?
    return block if !danger_line.nil?
    attack
  end

  def center_open?
    open_spaces.include?([1,1])
  end

  def open?(space)
    open_spaces.include?(space)
  end

  def smart_move(input)
    line = input
    y = line.values[0].index(nil)
    space = MAP[line.keys[0]][y]
    if !open_spaces.include?(space) then space = MAP[line.keys[y]][0] end
    move(space)
  end

  def go_for_win
    smart_move(win_line)
  end

  def block
    smart_move(danger_line)
  end

  def win_line
    check_win(check_lines)
  end

  def danger_line
    check_warning(check_lines)
  end

  def check_warning(warning)
    line_hash = warning.select do |l, v|
       v.compact.to_s == [on_deck, on_deck].to_s
    end
    return nil if line_hash.empty?
    line_hash
  end

  def check_win(win_line)
    line_hash = win_line.select do |l, v|
       v.compact.to_s == [turn, turn].to_s
    end
    return nil if line_hash.empty?
    line_hash
  end

  def check_lines
    lines.select { |l, v| v.compact.length == 2 }
  end

  def check_corners
    @game.moves.select do |space| #finds corners occupied by opponent
      require "pry"; binding.pry
      space[1] == turn
    end
    #select opposite corners
  end

  def attack
    return move(check_corners[0]) if !check_corners.empty?
  end
end
