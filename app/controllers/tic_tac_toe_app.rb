require 'models/game'

class TicTacToeApp < Sinatra::Base
  set :root, File.expand_path("..", __dir__)

  get '/' do
    erb :dashboard
  end

  get '/game/human' do
    @game = Game.new
    erb :human
  end

  post '/game/move' do
    if @game.over?
      redirect '/game/over'
    else
      erb :game
    end
  end

  get '/computer' do
    erb :computer
  end

end
