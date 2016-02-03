require_relative 'game'

class GameManager
  attr_reader :database

  def initialize(database)
    @database = database
  end

  def gather_data
    database.transaction do
      database['game'] ||= []
      database['board'] ||= Board.new
      database['player_1'] ||= Player.new(:x, "#0062FF")
      database['player_2'] ||= Player.new(:o, "#FF0099")
      database['turn'] ||= database['player_1']
      database['move_count'] ||= 0
      database['game'] << { board:            database['board'],
                            player_1: database['player_1'],
                            player_2: database['player_2'],
                            turn: database['turn'],
                            move_count: database['move_count'],
                            }
    end
  end

  def raw_games
    database.transaction do
      database['game'] || []
    end
  end

  def raw_game
    raw_games.last
  end

  def create_game
    gather_data
    Game.new(raw_game)
  end

  def update(game)
    database.transaction do
      database['board'] = game.game
      database['turn'] = game.turn
      database['move_count'] = game.move_count
    end
  end
end