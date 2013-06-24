-- Scene class
Scene = class('Scene')

function Scene:initialize(game)
  self.game = game
end

function Scene:keyreleased(key)
  if key == "escape" or key == "q" then love.event.quit() end
  if key == "d" then DEBUG = not DEBUG end
end