-- Truck class
Truck = class('Truck', Component)

function Truck:initialize(width, height, x, y)
  Component.initialize(self, width, height)
  self.x = x
  self.y = y
  self.image = nil
end

function Truck:draw()
  if world.showTruck then
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(self.image, self.x, self.y, 0, 4)
  end
end

function Truck:update(dt)
  self.x = self.x + (world.stageSpeed * dt)
end