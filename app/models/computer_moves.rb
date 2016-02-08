module ComputerMoves
  MAP =
      { r1: [[0,0], [0,1], [0,2]],
        r2: [[1,0], [1,1], [1,2]],
        r3: [[2,0], [2,1], [2,2]],
        c1: [[0,0], [1,0], [2,0]],
        c2: [[0,1], [1,1], [2,1]],
        c3: [[0,2], [1,2], [2,2]],
        d1: [[0,0], [1,1], [2,2]],
        d2: [[0,2], [1,1], [2,0]]
      }

  OPP_CORNERS =
      { [0,0] => [[0,2], [2,2], [2,0]],
        [0,2] => [[2,2], [2,0], [0,0]],
        [2,2] => [[2,0], [0,0], [0,2]],
        [2,0] => [[0,0], [0,2], [2,2]]
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
    check_win(check_lines(2))
  end

  def danger_line
    check_warning(check_lines(2))
  end

  def move_line
    check_move(check_lines(1))
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

  def check_move(move_line)
    line_hash = move_line.select do |l, v|
       v.compact.to_s == [turn, turn].to_s
    end
    return open_spaces.sample if line_hash.empty?
    line_hash
  end

  def check_lines(n)
    lines.select { |l, v| v.compact.length == n }
  end

  def check_corners
    opp = @game.moves.select { |space| space[1].sym == on_deck.sym }
    opp = opp.select { |space| OPP_CORNERS.include?(space[0]) }
    return if opp.empty?
    opp = OPP_CORNERS[opp[0][0]].select { |space| open_spaces.include?(space) }
    return [] if opp.nil?
    opp
  end

  def fork_line
    [1,0]
  end

  def open_corners
     OPP_CORNERS.keys.select { |space| open_spaces.include?(space) }
  end

  def attack
    return move(fork_line) if move_count == 3 && check_corners.count == 2
    return move(move_line) if open_corners.empty? || check_corners.nil?
    return move(check_corners[0]) if !check_corners[0].empty?
    return move(check_corners[1]) if !check_corners[1].empty?
    return move(check_corners[2]) if !check_corners[2].empty?
  end
end
