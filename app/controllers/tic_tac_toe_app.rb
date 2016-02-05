require 'yaml/store'
class TicTacToeApp < Sinatra::Base
  get '/' do
    erb :dashboard
  end

  get '/game/draw' do
    game_manager.reset([])
    erb :draw
  end

  get '/game/human' do
    if game_manager.gather_data([])[0][:move_count] == 0
      game_manager.reset(["human","human"])
    end
    @game = game_manager.create_game(["human","human"])
    erb :game
  end

  get '/game/cpu_human' do
    if game_manager.gather_data([])[0][:move_count] == 0
      game_manager.reset(["chc","chh"])
    end
    @game = game_manager.create_game(["chc","chh"])
    erb :game
  end

  get '/game/cpu_human/first' do
    if game_manager.gather_data([])[0][:move_count] == 0
      game_manager.reset(["chc","chh"])
    end
    @game = game_manager.create_game(["chc","chh"])
    @game.cpu_move
    @game.change_turns
    game_manager.update(@game)
    game_manager.scrub(@game)
    redirect '/game/cpu_human'
  end

  get '/game/human_cpu' do
    if game_manager.gather_data([])[0][:move_count] == 0
      game_manager.reset(["hch","hcc"])
    end
    @game = game_manager.create_game(["hch","hcc"])
    erb :game
  end

  post '/game/chh/move' do
    @game = game_manager.create_game(["chc","chh"])
    if @game.game.open_spaces.include?(params[:space].split(",").map(&:to_i))
      @game.move(params[:space].split(",").map(&:to_i))
      if @game.win?
        game_manager.update(@game)
        game_manager.scrub(@game)
        redirect '/game/cpu_human/win'
      end
      @game.change_turns
      @game.cpu_move
      if @game.win?
        game_manager.update(@game)
        game_manager.scrub(@game)
        redirect '/game/cpu_human/win'
      end
      @game.change_turns
      game_manager.update(@game)
      game_manager.scrub(@game)
      if @game.draw?
        redirect '/game/draw'
      else
        redirect '/game/cpu_human'
      end
    else
    redirect '/game/cpu_human'
    end
  end

  post '/game/hch/move' do
    @game = game_manager.create_game(["hch","hcc"])
    if @game.game.open_spaces.include?(params[:space].split(",").map(&:to_i))
      @game.move(params[:space].split(",").map(&:to_i))
      if @game.win?
        game_manager.update(@game)
        game_manager.scrub(@game)
        redirect '/game/human_cpu/win'
      end
      @game.change_turns
      @game.cpu_move
      if @game.win?
        game_manager.update(@game)
        game_manager.scrub(@game)
        redirect '/game/human_cpu/win'
      end
      @game.change_turns
      game_manager.update(@game)
      game_manager.scrub(@game)
      if @game.draw?
        redirect '/game/draw'
      else
        redirect '/game/human_cpu'
      end
    else
    redirect '/game/human_cpu'
    end
  end

  post '/game/human/move' do
    @game = game_manager.create_game(["human","human"])
    if @game.game.open_spaces.include?(params[:space].split(",").map(&:to_i))
      @game.move(params[:space].split(",").map(&:to_i))
      if @game.win?
        redirect '/game/human/win'
      end
      @game.change_turns
      game_manager.update(@game)
      game_manager.scrub(@game)
      if @game.draw?
        redirect '/game/draw'
      else
        redirect '/game/human'
      end
    else
    redirect '/game/human'
    end
  end

  get '/game/human/win' do
    @game = game_manager.create_game(["human","human"])
    game_manager.update(@game)
    game_manager.scrub(@game)
    game_manager.reset(["human","human"])
    erb :win
  end

  get '/game/human_cpu/win' do
    @game = game_manager.create_game(["hch","hcc"])
    game_manager.update(@game)
    game_manager.scrub(@game)
    game_manager.reset(["hch","hcc"])
    erb :win
  end

  get '/game/cpu_human/win' do
    @game = game_manager.create_game(["chc","chh"])
    game_manager.reset(["chc","chh"])
    erb :win
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
