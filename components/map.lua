-- Map class

Map = {}
Map.__index = Map

-- Constructor
function Map:new()
  -- define our parameters here
  local map = {
    tileMap = {},
    tiles = {}
  }

  return setmetatable(map, Map)
end

function Map:draw()
  for y = 1, #self.tileMap do
    for x = 1, #self.tileMap[y] do
      if self.tileMap[y][x] ~= 0 then
        self.tiles[self.tileMap[y][x]]:draw(x-1, y-1)
      end

      if DEBUG then
        love.graphics.setLineWidth(1)
        love.graphics.rectangle('line', (x-1)*CELLSIZE, (y-1)*CELLSIZE, CELLSIZE, CELLSIZE)
      end
    end
  end
end

function Map:print()
  for y = 1, #self.tileMap do
    for x = 1, #self.tileMap[y] do
      print(self.tileMap[y][x])
    end
  end
end