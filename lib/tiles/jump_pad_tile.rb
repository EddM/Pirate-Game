class JumpPadTile < SolidTile
  
  def initialize(game, x, y)
    @game = game
    super(game, "jump_tile.png", x, y)
  end
  
  def contact(player)
    unless player.jumping
      player.jump(28)
      player.game.soundbank.play(:boing)
    end
  end
  
end