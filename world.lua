-- World class
World = class('World')

function World:initialize()
  self.gravity = 1800
  self.playerFocus = false
  self.stageSpeed = 100
  self.yFloor = love.graphics.getHeight()/2
  self.xBound = love.graphics.getWidth()*4
  self.showBackground = true
  self.showTrees = true
  self.showTruck = true
  self.stageX = 0
  self.isRunning = true

  camera:setBounds(0, -1 * love.graphics.getHeight(), self.xBound - love.graphics.getWidth(), love.graphics.getHeight())
end

function World:newLayer(scale, draw)
  camera:newLayer(scale, draw)
end

function World:stop()
  self.isRunning = false
end

function World:update(dt)
  local cameraX = 0
  local cameraY = player.y - love.graphics.getHeight()/2 + player.height/2

  if self.playerFocus then
    cameraX = player.x - love.graphics.getWidth()/2 + player.width/2
  else
    cameraX = self.stageX
  end

  camera:setPosition(cameraX, cameraY)

  if self.isRunning then
    self.stageX = self.stageX + (self.stageSpeed * dt)
  end
end

function World:draw()
  camera:draw()
end

function World:keypressed(key)
  if DEBUG then
    if key == "up" then self.yFloor = self.yFloor - 10 end
    if key == "down" then self.yFloor = self.yFloor + 10 end
    if key == "f" then self.playerFocus = not self.playerFocus end
    if key == "b" then self.showBackground = not self.showBackground end
    if key == "t" then self.showTrees = not self.showTrees end
    if key == "r" then self.showTruck = not self.showTruck end
  end
end