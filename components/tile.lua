-- Tile class
Tile = class('Tile')

-- Constructor
function Tile:initialize()
  self.image = {}
  self.scale = 4
end

function Tile:draw(x, y)
  love.graphics.setColor(255, 255, 255)
  love.graphics.draw(self.image, x, y, 0, self.scale)
end