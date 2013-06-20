-- Tree class

Tree = {}
Tree.__index = Tree

-- Constructor
function Tree:new()
  -- define our parameters here
  local tree = {
    x = 0,
    y = 0,
    scale = 1,
    image = nil
  }

  return setmetatable(tree, Tree)
end

function Tree:draw()
  love.graphics.setColor(255, 255, 255)
  love.graphics.draw(self.image, self.x, self.y, 0, self.scale)
end