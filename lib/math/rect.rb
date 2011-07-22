class Rect
  attr_reader :x, :y, :width, :height, :bottom, :right
  
  def initialize(x, y, width = 1, height = 1)
    @x, @y, @width, @height = x, y, width, height
    @bottom, @right = @y + height, @x + width
  end
  
  def surface_rect
    Rect.new(@x, @y, @width, 1)
  end
  
  def mid_point
    [@x + (@width / 2), @y + (@height / 2)]
  end
  
  def intersects_line?(x1, y1, x2, y2)
    p = q = r = 0.0

    x_delta = x2 - x1
    y_delta = y2 - y1

    (0..3).each do |edge|
      if edge == 0 # left edge
        p = -x_delta
        q = -(@x - x1)
      end

      if edge == 1 # right edge
        p = x_delta
        q = @right - x1
      end

      if edge == 2 # top edge
        p = -y_delta
        q = -(@y - y1)
      end

      if edge == 3 # bottom edge
        p = y_delta
        q = @bottom - y1
      end

      return false if p == 0 && q < 0

      r = q.to_f / p
      return false if (p < 0 && r > 1.0) || (p > 0 && r < 0.0)
    end

    true
  end
  
  def intersects_point?(x, y)
    (@x < x && @right > x) && (@y < y && @bottom > y)
  end
  
  def intersects_rect?(rect)
    !(
      rect.x > @right ||
      rect.right < @x ||
      rect.y > @bottom ||
      rect.bottom < @y
    )
  end
  alias :intersects? :intersects_rect?
  
end