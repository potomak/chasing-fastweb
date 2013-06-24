-- Game class
Game = class('Game')

function Game:initialize()
  self.scenes = {}
  self.currentScene = nil
end

function Game:addScene(scene, sceneName)
  self.scenes[sceneName] = scene
  print("add scene: "..sceneName)
  print(scene)
end

function Game:loadScene(sceneName)
  self.currentScene = self.scenes[sceneName]
  print("load scene: "..sceneName)
  print(self.currentScene)
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