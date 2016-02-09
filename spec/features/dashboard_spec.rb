require_relative '../test_helper'

class DashboardTest < Minitest::Test
  include Capybara::DSL

  def test_home_page_gives_three_options
    visit '/'
    within("#human") do
      assert page.has_content?("Human vs. Human")
    end
    within("#human-cpu") do
      assert page.has_content?("Human vs. CPU")
    end
    within("#cpu-human") do
      assert page.has_content?("CPU vs. Human")
    end
  end
end
