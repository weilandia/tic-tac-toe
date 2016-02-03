require 'yaml/store'
require 'models/game_manager'

class TicTacToeApp < Sinatra::Base
  set :root, File.expand_path("..", __dir__)

  get '/' do
    erb :dashboard
  end

  get '/game/human' do
    @game = game_manager.create_game
    erb :human
  end

  post '/game/human/move' do
    @game = game_manager.create_game
    @game.move(params[:space].split(",").map(&:to_i))
    require "pry"; binding.pry
    game_manager.update(@game)
    redirect '/game/human'
  end

  get '/computer' do
    erb :computer
  end

  def game_manager
    database = YAML::Store.new('db/games')
    @games ||= GameManager.new(database)
  end
end
