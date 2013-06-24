-- Tree class
Tree = class('Tree')

function Tree:initialize()
  self.x = 0
  self.y = 0
  self.scale = 1
  self.image = nil
  self.alpha = 255
end

function Tree:draw()
  love.graphics.setColor(255, 255, 255, self.alpha)
  love.graphics.draw(self.image, self.x, self.y, 0, self.scale)

  if DEBUG then
    love.graphics.point(self.x, self.y)
  end
end