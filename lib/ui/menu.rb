class Menu
  
  BUTTON_WIDTH = 150
  BUTTON_HEIGHT = 30
  
  def initialize(game)
    @game = game
    @logo = Gosu::Image.new(game, "res/menu-logo.png", false)
    @height, @width = @game.height, @game.width
    
    @song = Gosu::Song.new("res/music/menu.mp3")
    @song.play(false)
    
    @button = SimpleButton.new(
      game, 
      (@width / 2) - (BUTTON_WIDTH / 2), 
      @height - 75, 
      BUTTON_WIDTH, 
      BUTTON_HEIGHT, 
      Gosu::Color::BLACK, 
      "Start Game",
      Proc.new { start_game }
    )
  end
  
  def start_game
    @song.stop
    @game.initialize_game
  end
  
  def draw
    top = Gosu::Color.new(255, 129, 160, 195)
    bottom = Gosu::Color.new(255, 149, 211, 232)
    
    @game.draw_quad(
      0, 0, top,
      @width, 0, top,
      0, @height, bottom,
      @width, @height, bottom
    )
    
    @logo.draw((@width / 2) - (@logo.width / 2), 0, 2)
    
    @button.draw
  end
  
  def update
    
  end
  
  def click_at(x, y)
    if @button.rect.intersects_point?(x, y)
      @button.click!
    end
  end
  
end