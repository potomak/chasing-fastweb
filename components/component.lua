-- Component class
Component = class('Component')

-- Constructor
function Component:initialize(width, height)
  self.width = width
  self.height = height
end

function Component:onCells(x, y)
  local cells = {}
  local tx, ty = posToTile(x, y)
  local key = tx..","..ty
  cells[key] = true
  cells[#cells+1] = key

  tx, ty = posToTile(x+self.width, y)
  key = tx..","..ty
  if not cells[key] then
    cells[key] = true
    cells[#cells+1] = key
  end

  tx, ty = posToTile(x+self.width, y+self.height)
  key = tx..","..ty
  if not cells[key] then
    cells[key] = true
    cells[#cells+1] = key
  end

  tx, ty = posToTile(x, y+self.height)
  key = tx..","..ty
  if not cells[key] then
    cells[key] = true
    cells[#cells+1] = key
  end
  
  return cells
end

function posToTile(x, y)
  return math.floor(x/Map.TILE_SIZE), math.floor(y/Map.TILE_SIZE)
end