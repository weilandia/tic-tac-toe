require 'yaml/store'
class TicTacToeApp < Sinatra::Base
  get '/' do
    erb :dashboard
  end

  get '/game/human' do
    @game = start_game(["human","human"])
    erb :game
  end

  get '/game/cpu_human' do
    @game = start_game(["chc","chh"])
    erb :game
  end

  get '/game/human_cpu' do
    @game = start_game(["hch","hcc"])
    erb :game
  end

  get '/game/cpu_human/first' do
    @game = start_game(["chc","chh"])
    @game.cpu_move
    clean_data(@game)
    redirect '/game/cpu_human'
  end

  post '/game/human/move' do
    @game = game_manager.create_game(["human","human"])
    if @game.game.open_spaces.include?(params[:space].split(",").map(&:to_i))
      @game.move(params[:space].split(",").map(&:to_i))
      if @game.win? then redirect '/game/human/win' end
      clean_data(@game)
      if @game.draw? then redirect '/game/draw'
      else redirect '/game/human' end
    else redirect '/game/human' end
  end

  post '/game/chh/move' do
    mode = ["chc","chh"]
    win_path = '/game/cpu_human/win'
    game_path = '/game/cpu_human'
    computer_game_play(mode, win_path, game_path)
  end

  post '/game/hch/move' do
    mode = ["hch","hcc"]
    win_path = '/game/human_cpu/win'
    game_path = '/game/human_cpu'
    computer_game_play(mode, win_path, game_path)
  end

  get '/game/draw' do
    game_manager.reset([])
    erb :draw
  end

  get '/game/human/win' do
    @game = game_manager.create_game(["human","human"])
    game_manager.reset(["human","human"])
    erb :win
  end

  get '/game/human_cpu/win' do
    @game = game_manager.create_game(["hch","hcc"])
    game_manager.reset(["hch","hcc"])
    erb :win
  end

  get '/game/cpu_human/win' do
    @game = game_manager.create_game(["chc","chh"])
    game_manager.reset(["chc","chh"])
    erb :win
  end

  def start_game(mode)
    if game_manager.gather_data([])[0][:move_count] == 0
      game_manager.reset(mode)
    end
    game_manager.create_game(mode)
  end

  def win(win_path)
    clean_data(@game)
    redirect win_path
  end

  def clean_data(game)
    game_manager.update(game)
    game_manager.scrub(game)
  end

  def open_spaces(current_game)
    current_game.game.open_spaces
  end

  def computer_game_play(mode, win_path, game_path)
    @game = game_manager.create_game(mode)
    if open_spaces(@game).include?(params[:space].split(",").map(&:to_i))
      @game.move(params[:space].split(",").map(&:to_i))
      if @game.win? then win(win_path) end
      @game.cpu_move
      if @game.win? then win(win_path) end
      clean_data(@game)
      if @game.draw? then redirect '/game/draw'
      else redirect game_path end
    else
    redirect game_path
    end
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
