-- Tile class

Tile = {}
Tile.__index = Tile

-- Constructor
function Tile:new()
  -- define our parameters here
  local tile = {
    image = {}
  }

  return setmetatable(tile, Tile)
end

function Tile:draw(x, y)
  love.graphics.setColor(255, 255, 255)
  love.graphics.draw(self.image, x*CELLSIZE, y*CELLSIZE, 0, 4)
end