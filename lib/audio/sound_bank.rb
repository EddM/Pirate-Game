class SoundBank
  
  MAX_DIST = 500
  
  def initialize(game)
    @game = game
    @samples = {}
  end
  
  def add_sample(key, *filenames)
    if filenames.size > 1
      @samples[key] = filenames.map { |filename| Gosu::Sample.new(@game, filename) }
    else
      @samples[key] = Gosu::Sample.new(@game, filenames[0]) unless @samples[key]
    end
  end
  alias :add :add_sample
  
  def play_sample(key, vol = 1.0, speed = 1.0, looping = false)
    if @samples[key]
      if @samples[key].is_a? Gosu::Sample
        @samples[key].play(vol, speed, looping)
      elsif @samples[key].is_a? Array
        @samples[key][rand(@samples[key].size)].play(vol, speed, looping)
      end
    end
  end
  alias :play :play_sample
  
  def play_at_distance(key, source, max_dist = MAX_DIST)
    dist = Gosu.distance(source.x, source.y, @game.player.x, @game.player.y)
    play(key, (1.0 - (dist * (1.0 / max_dist))) / 2) if dist < max_dist
  end
  
  def [](key)
    @samples[key]
  end
  
end