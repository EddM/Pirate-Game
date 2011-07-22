class Map

  TILE_SIZE = 50

  attr_reader :width, :height, :width_in_pixels, :height_in_pixels, :tiles, :enemies, :coins, :lives, :spawn_point, :exit, :vines
  attr_reader :fire_tiles, :water_tiles
  attr_accessor :clear

  def initialize(game, file)
    @game = game
    @lines = File.readlines(file).map { |line| line.chomp }
    @height = @lines.size
    @width = @lines.max_by { |l| l.size }.size
    @tiles, @coins, @enemies, @lives, @scenery, @vines = [], [], [], [], [], []
    @clear = false
    
    @width_in_pixels  = @width * TILE_SIZE
    @height_in_pixels = @height * TILE_SIZE
    
    @song = Gosu::Song.new("res/music/#{File.basename(file).split(".")[0]}.mp3")
    
    build
  end
  
  def tile?(x, y)
    @tiles[x / TILE_SIZE][y / TILE_SIZE]
  end

  def build
    @enemy = nil
    @enemy_row = nil
    
    @tiles = Array.new(@width) do |x|
      Array.new(@height) do |y|
        case @lines[y][x, 1]
        when '='
          GroundTile.new(@game, x * TILE_SIZE, y * TILE_SIZE)
        when '"'
          GrassTile.new(@game, x * TILE_SIZE, y * TILE_SIZE)
        when '%'
          FireTile.new(@game, x * TILE_SIZE, y * TILE_SIZE)
        when '~'
          WaterTile.new(@game, x * TILE_SIZE, y * TILE_SIZE)
        when '^'
          JumpPadTile.new(@game, x * TILE_SIZE, y * TILE_SIZE)
        when 'V'
          @vines << Vine.new(@game, x * TILE_SIZE, y * TILE_SIZE)
          nil
        when 'T'
          @scenery << Tree.new(@game, x * TILE_SIZE, y * TILE_SIZE)
          nil
        when 't'
          @scenery << Tree.new(@game, x * TILE_SIZE, y * TILE_SIZE, true)
          nil
        when 'o'
          @coins << Coin.new(@game, x * TILE_SIZE, y * TILE_SIZE)
          nil
        when '+'
          @lives << Life.new(@game, x * TILE_SIZE, y * TILE_SIZE)
          nil
        when '#'
          @exit = [x * TILE_SIZE, y * TILE_SIZE]
          nil
        when 'S'
          @spawn_point = [x * TILE_SIZE, y * TILE_SIZE]
          nil
        when 'm'
          if @enemy && @enemy_row == y
            @enemy.x_bound += TILE_SIZE
          else
            @enemy = Enemy.new(@game, [x * TILE_SIZE, y * TILE_SIZE])
            @enemy_row = y
          end
          nil
        else
          if @enemy && @enemy_row == y
            @enemies << @enemy
            @enemy = @enemy_row = nil
          end
          nil
        end
      end
    end
    
    # optimisations
    tiles = @tiles.flatten
    %w(Fire Water).each do |type|
      _tiles = tiles.select { |t| t.is_a?(Kernel.const_get("#{type}Tile")) }
      instance_variable_set("@#{type.downcase}_tiles", _tiles)
    end
  end

  def update
    @vines.each do |v|
      v.update
    end
    
    @enemies.each do |enemy|
      enemy.update
    end
  end

  def draw
    game_x, game_y = @game.camera_x - TILE_SIZE, @game.camera_y - TILE_SIZE
    @tiles.flatten.select { |t| t && t.x > game_x && t.y > game_y && t.x < (game_x + @game.width + TILE_SIZE) && t.y < (game_y + @game.height + TILE_SIZE) }.each do |tile|
      tile.draw if tile
    end
    
    @vines.each do |v|
      v.draw
    end
    
    @coins.each do |coin|
      coin.draw
    end
    
    @enemies.each do |enemy|
      enemy.draw
    end
    
    @lives.each do |life|
      life.draw
    end
    
    @scenery.each do |item|
      item.draw
    end
  end
  
  def init
    @song.play(true)
  end
  
  def deinit
    @song.stop
  end

end