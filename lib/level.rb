class Level
  
  attr_reader :map, :number
  
  def initialize(game, number)
    @game, @number = game, number
  end
  
  def map
    @map ||= Map.new(@game, "res/levels/level#{@number}.txt")
  end
  
end