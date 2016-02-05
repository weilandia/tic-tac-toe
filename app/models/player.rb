class Player
  attr_reader :sym, :color, :mode

  def initialize(sym, color, mode)
    @mode = mode
    @sym = sym
    @color = color
  end

  # def inspect
  #   "#{self.sym}"
  # end
end
