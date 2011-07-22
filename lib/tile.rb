class Tile
  include Entity
  
  Z_LEVEL = 1
  
  attr_accessor :x, :y, :width, :height
  
  def initialize(game, image, x, y)
    @image = Gosu::Image.new(game, "res/tiles/#{image}", false)
    @x, @y, @width, @height = x, y, @image.width, @image.height
  end
  
  def draw
    @image.draw(@x, @y, Z_LEVEL)
  end

  def contactable?
    respond_to?(:contact)
  end
  
  def solid?
    false
  end
  
end