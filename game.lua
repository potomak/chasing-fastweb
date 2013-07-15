-- Game class
Game = class('Game')

function Game:initialize()
  self.scenes = {}
  self.currentScene = nil
end

function Game:addScene(scene, sceneName)
  self.scenes[sceneName] = scene
end

function Game:loadScene(sceneName)
  self.currentScene = self.scenes[sceneName]
  self.currentScene:load()
end

function Game:draw()
  self.currentScene:draw()
end

function Game:update(dt)
  self.currentScene:update(dt)
end

function Game:keyreleased(key)
  self.currentScene:keyreleased(key)
end

function Game:keypressed(key)
  self.currentScene:keypressed(key)
end

function Game:lose()
  world:stop()
  score:stop()
  player.isDead = true
  score.value = 0

  self.currentScene.showRestart = 'lose'
end

function Game:win()
  world:stop()
  truck:stop()

  self.currentScene.showRestart = 'win'
end

function Game:restart()
  self:loadScene("mainScene")
end