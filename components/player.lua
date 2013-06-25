-- Player class
Player = class('Player', Component)

-- Constructor
function Player:initialize(width, height, x, y, jumpSpeed, runSpeed)
  Component.initialize(self, width, height)
  self.x = x
  self.y = y
  self.jumpSpeed = jumpSpeed
  self.runSpeed = runSpeed
  self.xSpeed = 0
  self.ySpeed = 0
  self.xAcc = 0
  self.friction = 2
  self.state = ""
  self.canJump = false
  self.animation = nil
  self.animationDx = nil
  self.animationSx = nil
  self.isDead = false
end

-- Movement functions
function Player:jump()
  if self.canJump then
    self.ySpeed = self.jumpSpeed
    self.canJump = false
  end
end

function Player:moveRight()
  self.xAcc = self.runSpeed
  self.animation = self.animationDx
end

function Player:moveLeft()
  self.xAcc = -1 * self.runSpeed
  self.animation = self.animationSx
end

function Player:stop()
  self.xAcc = 0
end

function Player:hitFloor(maxY)
  self.y = maxY - self.height
  self.ySpeed = 0
  self.canJump = true
end

-- Update function
function Player:update(dt)
  self.animation:update(dt)

  if not self.isDead then
    if love.keyboard.isDown("right") then self:moveRight() end
    if love.keyboard.isDown("left") then self:moveLeft() end
  end

  -- update the player's position
  local newX = self.x + (self.xSpeed * dt)
  local newY = self.y + (self.ySpeed * dt)

  if not self:isColliding(newX, self.y) then
    self.x = newX
  else
    self.xSpeed = 0
  end

  if not self:isColliding(self.x, newY) then
    self.y = newY
  else
    self.canJump = self.ySpeed > 0
    self.ySpeed = 0
  end

  -- apply gravity
  self.ySpeed = self.ySpeed + (world.gravity * dt)
  -- apply acceleration and friction
  self.xSpeed = self.xSpeed + (self.xAcc * dt)
  self.xSpeed = self.xSpeed * (1 - math.min(dt*self.friction, 1))

  if self.xAcc == 0 and self.xSpeed < 10 and self.xSpeed > -10 then
    self.xSpeed = 0
  end

  -- update the player's state
  if not self.canJump then
    if self.ySpeed < 0 then
      self.state = "jump"
      self.animation:stop()
      self.animation:seek(2)
    elseif self.ySpeed > 0 then
      self.state = "fall"
      self.animation:seek(3)
    end
  else
    if self.xSpeed > 0 then
      self.state = "moveRight"
      self.animation:play()
    elseif self.xSpeed < 0 then
      self.state = "moveLeft"
      self.animation:play()
    else
      self.state = "stand"
      self.animation:stop()
      self.animation:seek(1)
    end
  end

  -- stop animation if player is dead
  if self.isDead then
    self.animation:stop()
    self.animation:seek(1)
  end

  -- hitting left bound kills player
  if not self.isDead and self.x < world.stageX then
    self.isDead = true
    world:stop()
  end

  -- stop the player when they hit the borders
  if self.x > world.xBound - self.width then self.x = world.xBound - self.width end
  if self.x < 0 then self.x = 0 end
  if self.y < -1 * self.width*4 then self.y = -1 * self.width*4 end
  if self.y > world.yFloor - self.height then self:hitFloor(world.yFloor) end
end

function Player:draw()
  love.graphics.setColor(255, 255, 255)
  self.animation:draw(self.x, self.y, self:orientation(), 1, 1, self:offset())

  if DEBUG then
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
    love.graphics.line(world.stageX, 0, world.stageX, love.graphics.getHeight())
    love.graphics.print("("..math.floor(world.stageX)..")", world.stageX, 200)
    love.graphics.line(self.x, 0, self.x, love.graphics.getHeight())
    love.graphics.print("("..math.floor(self.x)..")", self.x, 200)
  end
end

function Player:isColliding(x, y)
  local collision = false
  
  for k, v in ipairs(self:onCells(x, y)) do
    local x, y = v:match('(%d+),(%d+)')
    x, y = tonumber(x), tonumber(y)
    
    if x and y then
      if not m.tileMap[y+1] or not m.tileMap[y+1][x+1] then
        collision = false -- off-map
      elseif m.tileMap[y+1][x+1] ~= 0 then
        collision = true
      end
    end
  end

  return collision
end

function Player:orientation()
  if self.isDead then
    return math.rad(90)
  else
    return math.rad(0)
  end
end

function Player:offset()
  if self.isDead then
    return (self.animation.fw - self.width) / 2, self.height
  else
    return (self.animation.fw - self.width) / 2, 0
  end
end

function Player:keyreleased(key)
  if not self.isDead then
    if key == "x" then self:jump() end
  end
end