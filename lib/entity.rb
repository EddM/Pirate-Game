module Entity
  
  def rect
    Rect.new(@x, @y, @width, @height)
  end

  def draw
    @image.draw(@x, @y, 5)
  end
  
end