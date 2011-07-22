class FireTile < SolidTile
  
  def initialize(game, x, y)
    super(game, "fire.png", x, y)
  end
  
  def contact(player)
    player.die
    player.game.soundbank.play(:sizzle)
  end
  
end