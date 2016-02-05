class GameManager
  attr_reader :database

  def initialize(database)
    @database = database
  end

  def gather_data(mode)
    database.transaction do
      database['game'] ||= []
      database['board'] ||= Board.new
      database['mode'] ||= mode
      database['player_1'] ||= Player.new(:x, "#0062FF", mode[0])
      database['player_2'] ||= Player.new(:o, "#FF0099", mode[1])
      database['turn'] ||= database['player_1']
      database['on_deck'] ||= database['player_2']
      database['move_count'] ||= 0
      database['game'] << { board:      database['board'],
                            player_1:   database['player_1'],
                            player_2:   database['player_2'],
                            turn:       database['turn'],
                            on_deck:    database['on_deck'],
                            move_count: database['move_count'],
                            mode:       database['mode']
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

  def create_game(mode)
    gather_data(mode)
    Game.new(raw_game)
  end

  def scrub(game)
    database.transaction do
      database['game'].delete_if do |data|
        data[:move_count] < game.move_count
      end
    end
  end

  def reset(mode)
    database.transaction do
      database['game'] = []
      database['board'] = Board.new
      database['player_1'] = Player.new(:x, "#0062FF", mode[0])
      database['player_2'] = Player.new(:o, "#FF0099", mode[1])
      database['turn'] = database['player_1']
      database['on_deck'] ||= database['player_2']
      database['move_count'] = 0
      database['mode'] = mode
    end
  end

  def update(game)
    database.transaction do
      database['board'] = game.game
      database['turn'] = game.turn
      database['on_deck'] = game.on_deck
      database['move_count'] = game.move_count
    end
  end
end
