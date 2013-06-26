require 'lib.middleclass'
require 'lib.AnAL'
require 'lib.camera'

require 'components.component'
require 'components.player'
require 'components.truck'
require 'components.tree'
require 'components.tile'
require 'components.map'
require 'components.background'
require 'components.score'

require 'scenes.scene'
require 'scenes.splash'
require 'scenes.main_scene'

require 'world'
require 'game'

function love.load()
  DEBUG = false

  love.graphics.setDefaultImageFilter("nearest", "nearest")

  titleFont = love.graphics.newFont("assets/font.ttf", 40)
  font = love.graphics.newFont("assets/font.ttf", 20)

  game = Game:new()
  game:addScene(Splash:new(game), "splash")
  game:addScene(MainScene:new(game), "mainScene")
  
  game:loadScene("splash")
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

function love.keypressed(key)
  game:keypressed(key)

  if DEBUG then
    if key == "c" then debug.debug() end
  end
end