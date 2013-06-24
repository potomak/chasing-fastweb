require 'lib.middleclass'
require 'lib.AnAL'
require 'lib.camera'

require 'components.component'
require 'components.player'
require 'components.tree'
require 'components.forest'
require 'components.tile'
require 'components.map'

require 'scenes.scene'
require 'scenes.splash'
require 'scenes.main_scene'

require 'game'

function love.load()
  game = Game:new()
  splash = Splash:new(game)
  game:addScene(splash, "splash")
  mainScene = MainScene:new(game)
  game:addScene(mainScene, "mainScene")
  
  game:loadScene("splash")

  DEBUG = true
end

function love.update(dt)
  game:update(dt)
end

function love.draw()
  game:draw()
end

function love.keyreleased(key)
  game:keyreleased(key)
end