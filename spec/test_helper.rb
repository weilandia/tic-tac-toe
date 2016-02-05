ENV["RACK_ENV"] ||= "test"

require File.expand_path('../../config/environment', __FILE__)
require 'minitest/autorun'
require 'minitest/pride'
require 'capybara/dsl'
require 'tilt/erb'

Capybara.app = TicTacToeApp

Capybara.save_and_open_page_path = 'tmp/capybara'

module TestHelpers
  def teardown
    game_manager.reset
    super
  end

  def task_manager
    database = YAML::Store.new('db/games_test')
    @games ||= TaskManager.new(database)
  end
end

class FeatureTest < Minitest::Test
  include Capybara::DSL
  include TestHelpers
end
