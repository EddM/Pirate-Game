class Parrot
  include Entity
  
  attr_reader :x, :y, :ex_parrot
  
  DISTANCE = 400
  SPEED = 10
  ANIMATION_SPEED = 200
  
  def initialize(game, player, start_x, start_y, direction)
    @start_x, @start_y = start_x, start_y
    @x, @y = @start_x, @start_y
    @ex_parrot = false
    @direction = direction
    @game = game
    
    @images = Gosu::Image.load_tiles(@game, "res/parrot.png", 90, 82, false)
    @width, @height = @images[0].width, @images[0].height
    
    @game.soundbank.play(:squark)
  end
  
  def update
    if @direction == 0 && @x < @start_x + DISTANCE
      @x += SPEED
    elsif @direction == 1 && @x > @start_x - DISTANCE
      @x -= SPEED
    else
      @ex_parrot = true and return
    end
    
    enemies = @game.map.enemies.select { |e| e.rect.intersects?(rect) }
    
    if enemies.size > 0
      @game.map.enemies.reject! { |e| enemies.include?(e) } 
      @game.soundbank.play(:pop)
      @ex_parrot = true
    end
  end
  
  def draw
    @images[Gosu.milliseconds % ANIMATION_SPEED < (ANIMATION_SPEED / 2) ? 0 : 1].draw(@x, @y, 15, @direction == 1 ? -1 : 1, 1)
  end
  
end