require_relative '../test_helper'

class HumanHumanTest < Minitest::Test
  include Capybara::DSL

  def test_can_play_human_vs_human_and_win
    visit '/'
    click_link("Human vs. Human")
    assert_equal "/game/human", current_path
    click_button("1")
    click_button("2")
    click_button("5")
    click_button("3")
    click_button("9")
    assert_equal "/game/human/win", current_path
  end

  def test_can_play_human_vs_human_and_draw
    visit '/'
    click_link("Human vs. Human")
    assert_equal "/game/human", current_path
    click_button("1")
    click_button("3")
    click_button("2")
    click_button("4")
    click_button("6")
    click_button("5")
    click_button("7")
    click_button("8")
    click_button("9")
    assert_equal "/game/draw", current_path
  end
end
