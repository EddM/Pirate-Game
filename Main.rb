require 'rubygems'
require 'bundler/setup'
require 'gosu'

require 'lib/game'
require 'lib/game_state'
require 'lib/ui/menu'
require 'lib/ui/simple_button'
require 'lib/ui/quick_help_screen'
require 'lib/entity'
require 'lib/level'
require 'lib/map'
require 'lib/objects/player'
require 'lib/objects/enemy'
require 'lib/objects/parrot'
require 'lib/objects/vine'
require 'lib/objects/items/coin'
require 'lib/objects/items/life'
require 'lib/tile'
require 'lib/tiles/solid_tile'
require 'lib/tiles/fire_tile'
require 'lib/tiles/water_tile'
require 'lib/tiles/ground_tile'
require 'lib/tiles/grass_tile'
require 'lib/tiles/jump_pad_tile'
require 'lib/scenery'
require 'lib/scenery/tree'
require 'lib/math/rect'
require 'lib/audio/sound_bank'

Game.new(800, 500).show