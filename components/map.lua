-- Map class
Map = class('Map')
Map.static.TILE_SIZE = 48

-- Constructor
function Map:initialize()
  self.tileMap = {}
  self.tiles = {}
end

function Map:draw()
  for y = 1, #self.tileMap do
    for x = 1, #self.tileMap[y] do
      if self.tileMap[y][x] ~= 0 then
        self.tiles[self.tileMap[y][x]]:draw((x-1)*Map.TILE_SIZE, (y-1)*Map.TILE_SIZE)
      end

      if DEBUG then
        love.graphics.setLineWidth(1)
        love.graphics.rectangle("line", (x-1)*Map.TILE_SIZE, (y-1)*Map.TILE_SIZE, Map.TILE_SIZE, Map.TILE_SIZE)
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