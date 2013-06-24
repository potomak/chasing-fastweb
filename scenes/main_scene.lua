-- MainScene class
MainScene = class('MainScene', Scene)

function MainScene:initialize(game)
  Scene.initialize(self, game)

  PLAYER_FOCUS = false
  STAGE_SPEED = 100
  GRAVITY = 1800
  Y_FLOOR = love.graphics.getHeight()/2
  X_BOUND = love.graphics.getWidth()*4
  SHOW_BACKGROUND = true
  SHOW_TREES = true
  SHOW_TRUCK = true

  stageX = 0

  camera:setBounds(0, -1 * love.graphics.getHeight(), X_BOUND - love.graphics.getWidth(), love.graphics.getHeight())

  -- love.graphics.setBackgroundColor(220, 248, 244)

  -- background
  skyline = love.graphics.newImage("assets/skyline.gif")
  skyline:setFilter("nearest", "nearest")

  camera:newLayer(.5, function()
    if SHOW_BACKGROUND then
      love.graphics.setColor(255, 255, 255)
      love.graphics.draw(skyline, 0, 0, 0, 2)
    end
  end)

  -- floor
  camera:newLayer(.5, function()
    love.graphics.setColor(25, 200, 25)
    love.graphics.rectangle("fill", 0, Y_FLOOR, X_BOUND, love.graphics.getHeight())
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
      t.x = X_BOUND/treesNum * i * (j-1) - (treeImage:getWidth()*scale/2) + (love.graphics.getWidth()/2)
      t.y = Y_FLOOR - treeImage:getWidth()*scale
      t.scale = scale
      t.image = treeImage
      table.insert(trees, t)
    end

    camera:newLayer(i, function()
      if SHOW_TREES then
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
    {0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,1,1,0,0,0,1,0,0,0,0,1,0,0,0,0,1,0,},
    {0,0,0,0,0,0,0,1,1,0,0,0,0,1,0,0,0,1,1,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,},
    {0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,1,1,0,0,0,1,0,0,0,0,1,0,0,0,0,1,0,},
    {0,0,0,1,0,0,0,1,1,0,0,0,0,1,0,0,0,1,1,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,},
  }
  m.tiles = { rockTile }

  camera:newLayer(1, function() m:draw() end)

  -- truck
  truck = love.graphics.newImage("assets/truck.png")
  truck:setFilter("nearest", "nearest")
  truckX = love.graphics.getWidth() - 16*4 - 20

  camera:newLayer(1, function()
    if SHOW_TRUCK then
      love.graphics.setColor(255, 255, 255)
      love.graphics.draw(truck, truckX, Y_FLOOR - 16*4, 0, 4)
    end
  end)

  -- player
  officeGuySx = love.graphics.newImage("assets/office_guy_sx.png")
  officeGuySx:setFilter("nearest", "nearest")
  officeGuyDx = love.graphics.newImage("assets/office_guy_dx.png")
  officeGuyDx:setFilter("nearest", "nearest")

  p = Player:new(20, 32, 32*2, Y_FLOOR - 32, -500, 200)
  p.animationDx = newAnimation(officeGuyDx, 32, 32, 0.1, 0)
  p.animationSx = newAnimation(officeGuySx, 32, 32, 0.1, 0)
  p.animation = p.animationDx

  camera:newLayer(1, function() p:draw() end)
end

function MainScene:update(dt)
  if love.keyboard.isDown("right") then p:moveRight() end
  if love.keyboard.isDown("left") then p:moveLeft() end
  if love.keyboard.isDown("x") then p:jump() end

  p:update(dt)

  if PLAYER_FOCUS then
    stageX = p.x - love.graphics.getWidth()/2 + p.width/2
  else
    stageX = stageX + (STAGE_SPEED * dt)
  end

  stageY = p.y - love.graphics.getHeight()/2 + p.height/2

  truckX = truckX + (STAGE_SPEED * dt)
  
  camera:setPosition(stageX, stageY)
end

function MainScene:draw()
  camera:draw()
  
  -- debug information
  if DEBUG then
    love.graphics.setNewFont(12)
    love.graphics.setColor(255, 255, 255)
    love.graphics.print("Player coordinates: ("..p.x..","..p.y..")", 5, 5)
    love.graphics.print("Current state: "..p.state, 5, 20)
    love.graphics.print("FPS: "..love.timer.getFPS(), 5, 35)
    love.graphics.print("Player runSpeed (+/-): "..p.runSpeed, 5, 50)
    love.graphics.print(string.format("Player occupies cells(%d): %s", #p:onCells(p.x, p.y), table.concat(p:onCells(p.x, p.y), " | ")), 5, 65)

    local x, y = love.mouse.getPosition()
    love.graphics.print("("..x..","..y..")", x, y)
  end
end

function MainScene:keyreleased(key)
  Scene.keyreleased(self, key)

  if key == "right" or key == "left" then p:stop() end

  if key == "d" then DEBUG = not DEBUG end

  if DEBUG then
    if key == "up" then Y_FLOOR = Y_FLOOR - 10 end
    if key == "down" then Y_FLOOR = Y_FLOOR + 10 end
    if key == "+" then p.runSpeed = p.runSpeed + 10 end
    if key == "-" then p.runSpeed = p.runSpeed - 10 end
    if key == "f" then PLAYER_FOCUS = not PLAYER_FOCUS end
    if key == "b" then SHOW_BACKGROUND = not SHOW_BACKGROUND end
    if key == "t" then SHOW_TREES = not SHOW_TREES end
  end
end
