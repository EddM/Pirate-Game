class Enemy
  include Entity
  
  ANIMATION_SPEED = 200
  
  attr_accessor :x_bound
  
  def initialize(game, spawn, speed = 5)
    @speed, @spawn, @game = speed, spawn, game
    @x_bound = @dir = 0
  
    @images = Gosu::Image.load_tiles(@game, "res/enemy.png", 100, 45, false)
    @width, @height = @images[0].width, @images[0].height
    
    spawn!
  end
  
  def spawn!
    @x, @y = @spawn
  end
  
  def update
    if @dir == 1
      if @x - @spawn[0] < @x_bound
        @x += @speed
      else
        @dir = 0
      end
    else
      if @x > @spawn[0]
        @x -= @speed
      else
        @dir = 1
      end
    end
  end
  
  def draw
    @images[Gosu.milliseconds % ANIMATION_SPEED < (ANIMATION_SPEED / 2) ? 0 : 1].draw(@x, @y, 15, @direction == 1 ? -1 : 1, 1)
  end
  
  def dist
    player_mid_point = @game.player.rect.mid_point
    this_mid_point = rect.mid_point
    Gosu.distance(player_mid_point[0], player_mid_point[1], this_mid_point[0], this_mid_point[1])
  end
  
  def distance_from(point)
    this_mid_point = rect.mid_point
    Gosu.distance(point[0], point[1], this_mid_point[0], this_mid_point[1])
  end
    
end