-- Truck class
Truck = class('Truck', Component)

function Truck:initialize(width, height, x, y)
  Component.initialize(self, width, height)
  self.x = x
  self.y = y
  self.image = nil
  self.isRunning = true
end

function Truck:stop()
  self.isRunning = false
end

function Truck:draw()
  if world.showTruck then
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(self.image, self.x, self.y, 0, 4)

    if DEBUG then
      love.graphics.line(self.x, 0, self.x, love.graphics.getHeight())
      love.graphics.print("("..math.floor(self.x)..")", self.x, 200)
    end
  end
end

function Truck:update(dt)
  if self.isRunning then
    self.x = self.x + (world.stageSpeed * dt)
  end

  if self.x > world.xBound then
    game:lose()
  end
end