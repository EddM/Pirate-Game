class Scenery
  include Entity
  
  Z_LEVEL = 0
  
  def initialize(game, image, x, y, reversed = false)
    @image = Gosu::Image.new(game, "res/#{image}", false)
    @x, @y, @width, @height, @reversed = x, y, @image.width, @image.height, reversed
    
    if @height > Map::TILE_SIZE
      @y -= (@height - Map::TILE_SIZE)
    else
      @y += (Map::TILE_SIZE - @height)
    end
  end
  
  def draw
    @image.draw(@reversed ? @x + @width : @x, @y, Z_LEVEL, @reversed ? -1 : 1)
  end
  
end