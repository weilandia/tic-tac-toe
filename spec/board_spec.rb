$LOAD_PATH.unshift(File.expand_path("../app/models", __dir__))
require 'minitest/autorun'
require 'minitest/pride'
require 'board'

# <!-- <% @game.spaces.each do |space| %>
#   <div class="block">
#     <form action="/game/human/move" method="post">
#       <input type='hidden' class='space' name='space' value= '<%=space.first%>,<%=space.last%>'>
#       <input type='hidden' class='space' name='game' value= "<%= @game %>">
#       <input class='space' type='submit' value=''>
#     </form>
#   </div>
# <% end %> -->

class BoardTest < Minitest::Test
  def test_board_initializes
    assert_equal Board, Board.new.class
  end

  def test_board_defaults_to_3_x_3
    board_array = [[0, 0], [0, 1], [0, 2], [1, 0], [1, 1], [1, 2], [2, 0], [2, 1], [2, 2]]
    assert_equal board_array, Board.new.open_spaces
  end

  def test_new_board_is_empty
    assert Board.new.empty_board?
  end

  def test_board_reacts_to_moves
    board_array = [[nil, nil, nil], [nil, nil, nil], [nil, nil, :x]]
    open_s = [[0, 0], [0, 1], [0, 2], [1, 0], [1, 1], [1, 2], [2, 0], [2, 1]]
    b = Board.new
    b.move_response(:x, [2, 2])
    assert_equal board_array, b.board
    assert_equal open_s, b.open_spaces
  end
end
