class QuickHelpScreen
  
  CORNER_OFFSET = 85
  COLOR = Gosu::Color.new(175, 0, 0, 0)
  
  attr_accessor :showing
  
  def initialize(game)
    @game = game
    @showing = false
    @arial = Gosu::Font.new(game, "Arial", 16)
  end
  
  def draw
    @game.draw_quad(
      CORNER_OFFSET, CORNER_OFFSET, COLOR,
      @game.width - CORNER_OFFSET, CORNER_OFFSET, COLOR,
      CORNER_OFFSET, @game.height - CORNER_OFFSET, COLOR,
      @game.width - CORNER_OFFSET, @game.height - CORNER_OFFSET, COLOR,
      99
    )
    
    [
      "Use the LEFT and RIGHT keys to move,",
      "the UP key to jump,",
      "and the space bar to unleash the parrot.",
      "",
      "Press ESC to quit, or H to hide/show this help.",
      ""
    ].each_with_index do |line, i|
      @arial.draw(line, (@game.width / 2) - (@arial.text_width(line) / 2), (CORNER_OFFSET * 2) + ((i+1) * @arial.height), 100)
    end
  end
  
  def toggle
    @showing = !@showing
  end
  
end