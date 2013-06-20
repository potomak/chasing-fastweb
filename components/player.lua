-- Player class

Player = {}
Player.__index = Player

-- Constructor
function Player:new()
  -- define our parameters here
  local player = {
    x = 0,
    y = 0,
    width = 0,
    height = 0,
    jumpSpeed = 0,
    runSpeed = 0,
    xSpeed = 0,
    ySpeed = 0,
    state = "",
    canJump = false,
    animation = nil,
    animationDx = nil,
    animationSx = nil
  }

  return setmetatable(player, Player)
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

  if not self:isColliding(newX, newY) then
    self.x = newX
    self.y = newY
  end

  -- apply gravity
  self.ySpeed = self.ySpeed + (GRAVITY * dt)

  -- update the player's state
  if not(self.canJump) then
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
  if self.y < 0 then self.y = 0 end
  if self.y > Y_FLOOR - self.height then self:hitFloor(Y_FLOOR) end
end

function Player:draw()
  love.graphics.setColor(255, 255, 255)
  self.animation:draw(self.x, self.y)

  if DEBUG then
    love.graphics.point(self.x, self.y)
  end
end

-- see https://love2d.org/wiki/BoundingBox.lua
function Player:isColliding(x, y)
  for _, obstacle in ipairs(obstacles) do
    if x < obstacle.x+32 and x+32 > obstacle.x and y < obstacle.y+32 and y+32 > obstacle.y then
      return true
    end
  end

  return false
end