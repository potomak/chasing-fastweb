-- Tile class
Tile = class('Tile')

-- Constructor
function Tile:initialize()
  self.image = {}
end

function Tile:draw(x, y)
  love.graphics.setColor(255, 255, 255)
  love.graphics.draw(self.image, x, y, 0, Map.TILE_SIZE/self.image:getWidth())
end