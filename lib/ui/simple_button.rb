class SimpleButton
  
  PADDING = 2
  
  def initialize(game, x, y, width, height, color, text, callback)
    @game, @x, @y, @width, @height, @color, @text, @callback = game, x, y, width, height, color, text, callback
    @font = Gosu::Font.new(game, "Arial", height - (PADDING * 2))
  end
  
  def draw
    #@game.draw_quad(
    #  @x, @y, @color,
    #  @x + @width, @y, @color,
    #  @x, @y + @height, @color,
    #  @x + @width, @y + @height, @color
    #)
    
    @font.draw(@text, @x + ((@width - @font.text_width(@text)) / 2), @y + PADDING, 3, 1, 1, @color)
  end
  
  def click!
    @callback.call
  end
  
  def rect
    @rect ||= Rect.new(@x, @y, @width, @height)
  end
  
end