class Coin
  include Entity
  
  def initialize(game, x, y)
    @x, @y = x, y
    @image = Gosu::Image.new(game, "res/coin.png", false)
    
    @width = @image.width
    @height = @image.height
  end
  
end