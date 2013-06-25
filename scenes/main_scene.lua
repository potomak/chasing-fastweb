-- MainScene class
MainScene = class('MainScene', Scene)

function MainScene:initialize(game)
  Scene.initialize(self, game)
end

function MainScene:load()
  love.graphics.setNewFont(12)

  world = World:new()

  camera:setBounds(0, -1 * love.graphics.getHeight(), world.xBound - love.graphics.getWidth(), love.graphics.getHeight())

  -- background
  skyline = love.graphics.newImage("assets/skyline.gif")
  skyline:setFilter("nearest", "nearest")

  background = Background:new(skyline, world.xBound - love.graphics.getWidth())

  camera:newLayer(.25, function() background:draw() end)

  -- floor
  camera:newLayer(.5, function()
    love.graphics.setColor(25, 200, 25)
    love.graphics.rectangle("fill", 0, world.yFloor, world.xBound, love.graphics.getHeight())
  end)
  
  -- trees
  treeImage = love.graphics.newImage("assets/tree.png")
  treeImage:setFilter("nearest", "nearest")

  for _, i in ipairs({.5, 2}) do
    local trees = {}
    local treesNum = 10
    local scale = i*8

    for j = 1, treesNum do
      t = Tree:new()
      t.x = world.xBound/treesNum * i * (j-1) - (treeImage:getWidth()*scale/2) + (love.graphics.getWidth()/2)
      t.y = world.yFloor - treeImage:getWidth()*scale
      t.scale = scale
      t.image = treeImage
      if i == 2 then t.alpha = 192 end
      table.insert(trees, t)
    end

    camera:newLayer(i, function()
      if world.showTrees then
        for _, tree in ipairs(trees) do
          tree:draw()
        end
      end
    end)
  end

  -- obstacles
  rockImage = love.graphics.newImage("assets/rock.png")
  rockImage:setFilter("nearest", "nearest")
  rockTile = Tile:new()
  rockTile.image = rockImage

  m = Map:new()
  m.tileMap = {
    {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,1,1,0,0,0,1,0,0,0,0,1,0,0,0,0,1,0,},
    {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,},
    {0,0,0,0,0,0,0,0,1,1,1,0,0,1,0,0,0,0,1,0,0,0,0,1,1,0,0,0,1,0,0,0,0,1,0,0,0,0,1,0,},
    {0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,1,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,},
  }
  m.tiles = { rockTile }

  camera:newLayer(1, function() m:draw() end)

  -- truck
  truckImage = love.graphics.newImage("assets/truck.png")
  truckImage:setFilter("nearest", "nearest")

  truck = Truck:new(16*4, 16*4, love.graphics.getWidth() - 16*4 - 20, world.yFloor - 16*4)
  truck.image = truckImage

  camera:newLayer(1, function() truck:draw() end)

  -- player
  officeGuySx = love.graphics.newImage("assets/office_guy_sx.png")
  officeGuySx:setFilter("nearest", "nearest")
  officeGuyDx = love.graphics.newImage("assets/office_guy_dx.png")
  officeGuyDx:setFilter("nearest", "nearest")

  p = Player:new(20, 32, 32*4, world.yFloor - 32, -500, 400)
  p.animationDx = newAnimation(officeGuyDx, 32, 32, 0.1, 0)
  p.animationSx = newAnimation(officeGuySx, 32, 32, 0.1, 0)
  p.animation = p.animationDx

  camera:newLayer(1, function() p:draw() end)
end

function MainScene:update(dt)
  p:update(dt)
  world:update(dt)
  truck:update(dt)

  local cameraX = 0
  local cameraY = p.y - love.graphics.getHeight()/2 + p.height/2

  if world.playerFocus then
    cameraX = p.x - love.graphics.getWidth()/2 + p.width/2
  else
    cameraX = world.stageX
  end

  camera:setPosition(cameraX, cameraY)
end

function MainScene:draw()
  camera:draw()

  -- debug information
  if DEBUG then
    love.graphics.setColor(50, 50, 50, 180)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), 80)
    love.graphics.setColor(255, 255, 255, 180)
    love.graphics.print("Player coordinates: ("..p.x..","..p.y..")", 5, 5)
    love.graphics.print("state: "..p.state, 5, 20)
    love.graphics.print("Player runSpeed (+/-): "..p.runSpeed, 5, 35)
    love.graphics.print("Player xSpeed: "..p.xSpeed, 5, 50)
    love.graphics.print(string.format("Player occupies cells(%d): %s", #p:onCells(p.x, p.y), table.concat(p:onCells(p.x, p.y), " | ")), 5, 65)

    local x, y = love.mouse.getPosition()
    love.graphics.print("("..x..","..y..")", x, y)
  end

  love.graphics.setColor(50, 128, 50, 255)
  love.graphics.rectangle("fill", love.graphics.getWidth() - 50, 0, love.graphics.getWidth(), 20)
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.print("FPS: "..love.timer.getFPS(), love.graphics.getWidth() - 50, 5)
end

function MainScene:keyreleased(key)
  Scene.keyreleased(self, key)

  p:keyreleased(key)
  world:keyreleased(key)

  if key == "right" or key == "left" then p:stop() end

  if DEBUG then
    if key == "+" then p.runSpeed = p.runSpeed + 10 end
    if key == "-" then p.runSpeed = p.runSpeed - 10 end
  end
end