class Game < Gosu::Window

  attr_reader :current_level, :map, :player, :soundbank, :camera_x, :camera_y
  
  def initialize(w, h)
    super(w, h, false)
    self.caption = 'The Adventures of Pirate Pete and Pickle the Parrot'
    
    @background_image = Gosu::Image.new(self, "res/back.png", false)
    @soundbank = SoundBank.new(self)
    @state = GameState::MENU
    
    @camera_x = @camera_y = 0
    
    @player = Player.new(self)
    
    @coin = Gosu::Image.new(self, "res/coin.png", false)
    @life = Gosu::Image.new(self, "res/life.png", false)
    
    @levels = [
      Level.new(self, 1),
      Level.new(self, 2)
    ]
    @current_level = 0
    
    load_level
    spawn_player
    
    @arial = Gosu::Font.new(self, "Arial", 16)
    
    @soundbank.add(:squark,     "res/squark.wav")
    @soundbank.add(:pop,        "res/pop.wav")
    @soundbank.add(:die,        "res/die.wav")
    @soundbank.add(:land,       "res/land.wav")
    @soundbank.add(:heartbeat,  "res/heartbeat.wav")
    @soundbank.add(:sizzle,     "res/sizzle.wav")
    @soundbank.add(:grunt,      "res/grunt.wav", "res/grunt2.wav")
    @soundbank.add(:ding,       "res/ding1.wav", "res/ding2.wav", "res/ding3.wav")
    @soundbank.add(:growl,      "res/monster.wav")
    @soundbank.add(:splash,     "res/splash.wav")
    @soundbank.add(:boing,      "res/boing.wav")
    @soundbank.add(:swoosh,     "res/swoosh.wav")
    
    @growl_instance = @soundbank.play(:growl, 0, 1, true)
    @growl_instance.pause
    
    @menu = Menu.new(self)
  end
  
  def load_level
    @map = @levels[@current_level].map
  end
  
  def spawn_player
    @player.x, @player.y = @map.spawn_point
  end
  
  def next_level
    if last_level?
      game_over
    else
      @map.deinit
      @current_level += 1
      load_level
      @map.init
      spawn_player
    end
  end
  
  def initialize_game
    @state = GameState::PLAYING
    @quick_help = QuickHelpScreen.new(self)
    @map.init
  end
  
  def update
    if @state == GameState::MENU
      #initialize_game
      @menu.update
      @menu.click_at(self.mouse_x, self.mouse_y) if button_down? Gosu::MsLeft
    elsif @state == GameState::PLAYING
      @camera_x = [[@player.x - (width/2), 0].max, @map.width_in_pixels - width].min
      @camera_y = [[@player.y - (height/2), 0].max, @map.height_in_pixels - height].min

      @player.go_left if button_down? Gosu::KbLeft
      @player.go_right if button_down? Gosu::KbRight
      @player.jump if button_down? Gosu::KbUp
      @player.fire if button_down? Gosu::KbSpace
      
      next_level if button_down? Gosu::KbN

      @map.update
      @player.update
    end
    
    close if button_down? Gosu::KbEscape
  end
    
  def toggle_quick_help
    @quick_help.toggle
  end
  
  def button_up(id)
    inputs = {
      4 => :toggle_quick_help
    }
    
    send(inputs[id]) if inputs[id]
    super(id)
  end
  
  def needs_cursor?
    @state == GameState::MENU
  end
  
  def draw
    draw_debug
    
    if @state == GameState::MENU
      @menu.draw
    elsif @state == GameState::PLAYING
      draw_score
      draw_background
      draw_help
    
      translate (-@camera_x), (-@camera_y) do
        @player.draw
        @map.draw
      end
    end
  end
  
  def draw_help
    @quick_help.draw if @quick_help.showing
  end
  
  def draw_debug
    @arial.draw("#{Gosu.fps} FPS", 0, 0, 6, 1, 1, Gosu::Color::BLACK)
  end
  
  def draw_score
    @player.lives.times do |i|
      @life.draw(width - (@life.width * (i+1)), 0, 15)
    end
    
    @arial.draw(@player.score, width - @coin.width - @arial.text_width(@player.score.to_s) - 10, @life.height + (@coin.height / 2) - 10, 6, 1, 1, Gosu::Color::BLACK)
    @coin.draw(width - (@coin.width), @life.height, 15)
  end
  
  def draw_background
    @background_image.draw(parallax_offset, 0, 0)
  end
  
  def parallax_offset
    0 - ((@background_image.width - width).to_f / (100 / (100 / (@map.width_in_pixels / @camera_x.to_f))))
  end

  def stop_growl
    if @growl_instance
      @growl_instance.stop
      @growl_instance = nil
    end
  end

  def pause_growl
    @growl_instance.pause unless @growl_instance.paused?
  end

  def play_growl(enemy)
    if enemy
      dist = enemy.dist
      if dist < 500
        @growl_instance.volume = (1.0 - (dist * (1.0 / 500))) / 2
        @growl_instance.resume unless @growl_instance.playing?
      else
        @growl_instance.pause unless @growl_instance.paused?
      end
    else
      @growl_instance.pause unless @growl_instance.paused?
    end
  end
  
  def game_over
    exit(0)
  end
  
  def last_level?
    @current_level == (@levels.size - 1)
  end
  
end
