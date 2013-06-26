-- Score class
Score = class('Score')

-- Constructor
function Score:initialize()
  self.value = world.xBound
  self.isRunning = true
end

function Score:stop()
  self.isRunning = false
end

function Score:update(dt)
  if self.isRunning then
    self.value = math.floor(world.xBound - (world.stageX + love.graphics.getWidth()))
  end
end

function Score:draw()
  love.graphics.setFont(font)
  love.graphics.setColor(30, 30, 30)
  love.graphics.printf("Score: "..self.value, 5, 5, 200, "left")
end