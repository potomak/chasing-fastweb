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
  self.state = ""
  self.canJump = false
  self.animation = nil
  self.animationDx = nil
  self.animationSx = nil
end

-- Movement functions
function Player:jump()
  if self.canJump then
    self.ySpeed = self.jumpSpeed
    self.canJump = false
  end
end

function Player:moveRight()
  self.xSpeed = self.runSpeed
  self.animation = self.animationDx
end

function Player:moveLeft()
  self.xSpeed = -1 * (self.runSpeed)
  self.animation = self.animationSx
end

function Player:stop()
  self.xSpeed = 0
end

function Player:hitFloor(maxY)
  self.y = maxY - self.height
  self.ySpeed = 0
  self.canJump = true
end

-- Update function
function Player:update(dt)
  self.animation:update(dt)

  -- update the player's position
  newX = self.x + (self.xSpeed * dt)
  newY = self.y + (self.ySpeed * dt)

  if not self:isColliding(newX, self.y) then
    self.x = newX
  end

  if not self:isColliding(self.x, newY) then
    self.y = newY
  else
    self.canJump = self.ySpeed > 0
    self.ySpeed = 0
  end

  -- apply gravity
  self.ySpeed = self.ySpeed + (GRAVITY * dt)

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

  -- stop the player when they hit the borders
  if self.x > X_BOUND - self.width then self.x = X_BOUND - self.width end
  if self.x < 0 then self.x = 0 end
  if self.y < -1 * self.width*4 then self.y = -1 * self.width*4 end
  if self.y > Y_FLOOR - self.height then self:hitFloor(Y_FLOOR) end
end

function Player:draw()
  love.graphics.setColor(255, 255, 255)
  self.animation:draw(self.x, self.y, 0, 1, 1, (self.animation.fw-self.width)/2)

  if DEBUG then
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
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