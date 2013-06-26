-- MainScene class
MainScene = class('MainScene', Scene)

function MainScene:initialize(game)
  Scene.initialize(self, game)
end

function MainScene:load()
  love.graphics.setNewFont(12)

  world = World:new()

  -- background
  skyline = love.graphics.newImage("assets/skyline.gif")

  background = Background:new(skyline, world.xBound - love.graphics.getWidth())

  world:newLayer(.25, function() background:draw() end)

  -- floor
  world:newLayer(.5, function()
    love.graphics.setColor(25, 200, 25)
    love.graphics.rectangle("fill", 0, world.yFloor, world.xBound, love.graphics.getHeight())
  end)
  
  -- trees
  treeImage = love.graphics.newImage("assets/tree.png")

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

    world:newLayer(i, function()
      if world.showTrees then
        for _, tree in ipairs(trees) do
          tree:draw()
        end
      end
    end)
  end

  -- obstacles
  rockImage = love.graphics.newImage("assets/rock.png")
  rockTile = Tile:new()
  rockTile.image = rockImage

  map = Map:new()
  map.tileMap = {
    {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,1,1,0,0,0,1,0,0,0,0,1,0,0,0,0,1,0,},
    {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,},
    {0,0,0,0,0,0,0,0,1,1,1,0,0,1,0,0,0,0,1,0,0,0,0,1,1,0,0,0,1,0,0,0,0,1,0,0,0,0,1,0,},
    {0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,1,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,},
  }
  map.tiles = { rockTile }

  world:newLayer(1, function() map:draw() end)

  -- truck
  truckImage = love.graphics.newImage("assets/truck.png")

  truck = Truck:new(16*4, 16*4, love.graphics.getWidth() - 16*4 - 20, world.yFloor - 16*4)
  truck.image = truckImage

  world:newLayer(1, function() truck:draw() end)

  -- player
  officeGuySx = love.graphics.newImage("assets/office_guy_sx.png")
  officeGuyDx = love.graphics.newImage("assets/office_guy_dx.png")

  player = Player:new(20, 32, 32*4, world.yFloor - 32, -500, 400)
  player.animationDx = newAnimation(officeGuyDx, 32, 32, 0.1, 0)
  player.animationSx = newAnimation(officeGuySx, 32, 32, 0.1, 0)
  player.animation = player.animationDx

  world:newLayer(1, function() player:draw() end)

  -- score
  score = Score:new()
end

function MainScene:update(dt)
  player:update(dt)
  world:update(dt)
  truck:update(dt)
  score:update(dt)
end

function MainScene:draw()
  world:draw()
  score:draw()

  -- debug information
  if DEBUG then
    love.graphics.setColor(50, 50, 50, 180)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), 80)
    love.graphics.setColor(255, 255, 255, 180)
    love.graphics.print("Player coordinates: ("..player.x..","..player.y..")", 5, 5)
    love.graphics.print("state: "..player.state, 5, 20)
    love.graphics.print("Player runSpeed (+/-): "..player.runSpeed, 5, 35)
    love.graphics.print("Player xSpeed: "..player.xSpeed, 5, 50)
    love.graphics.print(string.format("Player occupies cells(%d): %s", #player:onCells(player.x, player.y), table.concat(player:onCells(player.x, player.y), " | ")), 5, 65)

    local x, y = love.mouse.getPosition()
    love.graphics.print("("..x..","..y..")", x, y)
  end

  love.graphics.setFont(font)
  love.graphics.setColor(30, 30, 30)
  love.graphics.print("FPS: "..love.timer.getFPS(), love.graphics.getWidth() - 80, 5)
end

function MainScene:keyreleased(key)
  player:keyreleased(key)
end

function MainScene:keypressed(key)
  Scene.keypressed(self, key)

  player:keypressed(key)
  world:keypressed(key)
end