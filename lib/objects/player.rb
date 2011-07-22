class Player
  include Entity
  
  JUMP_SIZE = 20
  INITIAL_LIVES = 3
  INITIAL_SPEED = 4

  attr_accessor :x, :y
  attr_reader :speed, :score, :closest_enemy, :lives, :game, :jumping, :crosshair
    
  def initialize(game)
    @game = game
    @jump = @fallen_distance = @score = @dir = 0
    @width, @height = 52, 75
    @jumping = false
    
    @lives = INITIAL_LIVES
    @speed = INITIAL_SPEED
    
    @images = Gosu::Image.load_tiles(@game, "res/player.png", 55, 75, false)
  end
  
  def spawn!
    @x, @y = @game.map.spawn_point
  end
  
  def go_right
    @dir = 0
    @x += @speed if fits_right?
  end
  
  def go_left
    @dir = 1
    @x -= @speed if fits_left?
  end
  
  def jump(jump_height = JUMP_SIZE)
    if @jumping == false and @jump == 0
      @landed = false if @vine
      @vine = nil
      @jumping = true
      @jump = (-jump_height)
      @game.soundbank.play(:grunt)
    end
  end
  
  def update
    if @parrot
      @parrot.update
      @parrot = nil if @parrot.ex_parrot
    end
    
    if @vine
      @jump = 0
      @jumping = false
      
      @x = @vine.contact_point[0] - (@width / 2)
      @y = @vine.contact_point[1] - (@height / 2)
    else
      @jump += 1
      if @jump > 0
        @jumping = true
        @jump.times do
          if fits_below?
            @y += 1
            @fallen_distance += 1
          else
            @landed = true
            if @game.map.water_tiles.any? { |t| t.rect.intersects?(rect) }
              @game.soundbank.play(:splash) if @fallen_distance > 25
            else
              @game.soundbank.play(:land) if @fallen_distance > 100
            end
            @fallen_distance = @jump = 0
            @jumping = false
          end 
        end
      end

      if @jump < 0
        @jumping = true
        (-@jump).times do
          if fits_top?
            @y -= 1
          else
            @jump = 0
          end
        end
      end
    end
    
    tb = tile_below?
    tb.contact(self) if tb && tb.contactable?
  
    check_level_exit
    grab_vines if @game.map.vines.size > 0
    collect_coins if @game.map.coins.size > 0
    collect_lives if @game.map.lives.size > 0
    check_enemies unless @game.map.clear
  end
  
  def check_level_exit
    @game.next_level if rect.intersects_point?(@game.map.exit[0], @game.map.exit[1])
  end
  
  def grab_vines
    if @landed
      vines = @game.map.vines.select { |v| rect.intersects_point?(v.contact_point[0], v.contact_point[1]) }
      
      if vines.size > 0
        @vine = vines[0]
        @vine.player = self
      end
    end
  end
  
  def collect_coins
    taken_coins = @game.map.coins.select { |c| c.rect.intersects?(rect) }
    
    if taken_coins.size > 0
      @game.map.coins.reject! { |c| taken_coins.include?(c) }
      @score += taken_coins.size
      taken_coins.size.times do
        @game.soundbank.play(:ding)
      end
    end
  end
  
  def collect_lives
    taken_lives = @game.map.lives.select { |c| c.rect.intersects?(rect) }
    
    if taken_lives.size > 0
      @game.map.lives.reject! { |c| taken_lives.include?(c) }
      @lives += taken_lives.size
      taken_lives.size.times do
        @game.soundbank.play(:heartbeat)
      end
    end
  end
  
  def draw
    @parrot.draw if @parrot
    @images[@jumping ? @dir + 2 : @dir].draw(@x, @y, 1)
  end
  
  def die
    @lives -= 1
    
    if @lives < 1
      @game.game_over
    else
      @game.soundbank.play(:die)
      spawn!
    end
  end
  
  def fits_top?
    fits?(0, -1) && fits?(@width, -1)
  end
  
  def fits_below?
    fits?(0, @height) && fits?(@width, @height)
  end
  
  def fits_right?
    fits?(@width + @speed, 0) && fits?(@width + @speed, @height-1)
  end
  
  def fits_left?
    fits?(-@speed, 0) && fits?(-@speed, @height-1)
  end
  
  def tile_below?
    @game.map.tile?(@x + (@width / 2), @y + @height)
  end
  alias :tile_below :tile_below?
  
  def fits?(x_off, y_off)
    tile = @game.map.tile?(@x + x_off, @y + y_off)
    !tile || !tile.solid?
  end
  
  def enemy?
    @game.map.enemies.any? { |e| e.rect.intersects?(rect) }
  end
  
  def check_enemies
    if @game.map.enemies.size > 0
      die if enemy?
      @game.play_growl(closest_enemy)
    else
      @game.map.clear = true
      @game.stop_growl
    end
  end
  
  def closest_enemy
    return nil if @game.map.enemies.size == 0
    @game.map.enemies.min_by { |e| e.distance_from(rect.mid_point) }
  end
  
  def fire
    @parrot = Parrot.new(@game, self, @x, @y, @dir) unless @parrot
  end
  
end