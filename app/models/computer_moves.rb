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
    return move([0,0]) if first_three?
    go_for_win
    block
    attack
  end

  def center_open?
    open_spaces.include?([1,1])
  end

  def first_three?
    move_count < 3
  end

  def open?(space)
    open_spaces.include?(space)
  end

  def smart_move(input)
    line = input
    y = line.values[0].index(nil)
    space = MAP[line.keys[0]][y]
    move(space)
  end

  def go_for_win
    return if win_line.nil?
    smart_move(win_line)
  end

  def block
    return if danger_line.nil?
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
       v.compact == [on_deck, on_deck]
    end
    return nil if line_hash.empty?
    line_hash
  end

  def check_win(win_line)
    line_hash = win_line.select do |l, v|
       v.compact == [turn, turn]
    end
    return nil if line_hash.empty?
    line_hash
  end

  def check_lines
    lines.select { |l, v| v.compact.length == 2 }
  end

  def check_corners
    open_spaces.select do |space|
      space == [0,0] || [0,2] || [2,0] || [2,2]
    end
  end

  def attack
    return move(check_corners[0]) if !check_corners.empty?
  end
end
