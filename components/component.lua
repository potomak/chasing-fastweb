-- Component class

Component = {}
Component.__index = Component

-- Constructor
function Component:new()
  -- define our parameters here
  local component = {
    x = 0,
    y = 0,
    width = 0,
    height = 0
  }

  return setmetatable(component, Component)
end

function Component:onCells()
  local cells = {}
  local tx, ty = posToTile(self.x, self.y)
  local key = tx..","..ty
  cells[key] = true
  cells[#cells+1] = key

  tx, ty = posToTile(self.x+self.width, self.y)
  key = tx..","..ty
  if not cells[key] then
    cells[key] = true
    cells[#cells+1] = key
  end

  tx, ty = posToTile(self.x+self.width, self.y+self.height)
  key = tx..","..ty
  if not cells[key] then
    cells[key] = true
    cells[#cells+1] = key
  end

  tx, ty = posToTile(self.x, self.y+self.height)
  key = tx..","..ty
  if not cells[key] then
    cells[key] = true
    cells[#cells+1] = key
  end
  
  return cells
end