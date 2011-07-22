class Vine
  include Entity
  
  LENGTH = 230
  ANGLE_MAX = 65
  SPEED = 1
  
  attr_reader :x, :y
  attr_accessor :player
  
  def initialize(game, x, y)
    @game, @x, @y = game, x, y
    @angle = 225
    @image = Gosu::Image.new(game, "res/vine.png", true)
    @dir = 0
    @speed = SPEED
  end
  
  def contact_point
    [@x + Gosu.offset_x(@angle, LENGTH), @y + Gosu.offset_y(@angle, LENGTH)]
  end
  
  def update
    @speed = 1 + 1.8 * (1 - ((180 - @angle).abs / ANGLE_MAX))

    if @dir == 0
      @angle -= @speed
      
      if @angle <= (180 - ANGLE_MAX)
        @game.soundbank.play_at_distance(:swoosh, self, 1500)
        @dir = 1
        @speed = SPEED
      end
    else
      @angle += @speed
      
      if @angle >= (180 + ANGLE_MAX)
        @game.soundbank.play_at_distance(:swoosh, self, 1500)
        @dir = 0
        @speed = SPEED
      end
    end
  end
  
  def draw
    @image.draw_rot(@x, @y - 7, 0, @angle, 0.5, 1)
  end
  
end