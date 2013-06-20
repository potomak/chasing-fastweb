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
  self.x = self.x + (self.xSpeed * dt)
  self.y = self.y + (self.ySpeed * dt)

  -- apply gravity
  self.ySpeed = self.ySpeed + (GRAVITY * dt)

  -- update the player's state
  if not(self.canJump) then
    if self.ySpeed < 0 then
      self.state = "jump"
    elseif self.ySpeed > 0 then
      self.state = "fall"
    end
  else
    if self.xSpeed > 0 then
      self.state = "moveRight"
    elseif self.xSpeed < 0 then
      self.state = "moveLeft"
    else
      self.state = "stand"
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
end