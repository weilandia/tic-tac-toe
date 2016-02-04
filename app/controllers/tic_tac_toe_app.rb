require 'yaml/store'
class TicTacToeApp < Sinatra::Base
  get '/' do
    erb :dashboard
  end

  get '/game/draw' do
    erb :draw
  end

  get '/game/win' do
    @game = game_manager.create_game
    game_manager.update(@game)
    game_manager.scrub(@game)
    game_manager.reset
    erb :win
  end

  get '/game/human' do
    @game = game_manager.create_game
    erb :human
  end

  post '/game/human/move' do
    @game = game_manager.create_game
    @game.move(params[:space].split(",").map(&:to_i))
    if @game.win?
      redirect '/game/win'
    end
    @game.change_turns
    game_manager.update(@game)
    game_manager.scrub(@game)
    if @game.draw?
      game_manager.reset
      redirect '/game/draw'
    else
      redirect '/game/human'
    end
  end

  get '/computer' do
    erb :computer
  end

  def game_manager
    if ENV["RACK_ENV"] == "test"
      database = YAML::Store.new('db/games_test')
    else
      database = YAML::Store.new('db/games')
    end
    @games ||= GameManager.new(database)
  end
end
