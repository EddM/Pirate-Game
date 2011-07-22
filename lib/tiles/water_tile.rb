class WaterTile < Tile
  
  OVERHEAD_Y = 10
  
  def initialize(game, x, y)
    super(game, "water.png", x, y)
  end
  
  def draw
    @image.draw(@x, @y, 5, 1, 1, 0x55ffffff)
  end
  
  def rect
    Rect.new(@x, @y + OVERHEAD_Y, @width, @height)
  end
  
end