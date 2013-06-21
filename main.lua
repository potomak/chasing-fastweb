require 'lib.AnAL'
require 'lib.camera'
require 'components.player'
require 'components.tree'
require 'components.forest'

function love.load()
  DEBUG = false
  GRAVITY = 1800
  Y_FLOOR = love.graphics.getHeight()/2
  X_BOUND = love.graphics.getWidth()*4
  CELLSIZE=32
  PLAYERSIZE=32

  map = {
    {0,0,0,0,0,0,0,0,0,0,},
    {0,0,0,1,0,0,0,0,0,0,},
    {0,0,0,0,0,0,0,0,1,0,},
    {0,0,0,0,0,0,0,1,0,0,},
    {0,0,0,1,0,0,0,0,0,0,},
    {0,0,0,0,0,0,1,0,0,0,},
    {1,1,1,1,1,1,1,1,1,1,},
  }

  camera:setBounds(0, -love.graphics.getHeight(), X_BOUND - love.graphics.getWidth(), love.graphics.getHeight())

  -- floor
  camera:newLayer(.5, function()
    love.graphics.setColor(25, 200, 25)
    love.graphics.rectangle('fill', 0, Y_FLOOR, X_BOUND, love.graphics.getHeight())
  end)
  
  -- trees
  treeImage = love.graphics.newImage('assets/tree.png')
  treeImage:setFilter('nearest', 'nearest')

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
      for _, tree in ipairs(trees) do
        tree:draw()
      end
    end)
  end

  -- obstacles
  camera:newLayer(1, function()
    for y = 1, #map do
      for x = 1, #map[y] do
        if map[y][x] == 1 then
          love.graphics.rectangle('fill', x*CELLSIZE, y*CELLSIZE, CELLSIZE, CELLSIZE)
        else
          if DEBUG then
            love.graphics.rectangle('line', x*CELLSIZE, y*CELLSIZE, CELLSIZE, CELLSIZE)
          end
        end
      end
    end
  end)

  -- player
  officeGuySx = love.graphics.newImage('assets/office_guy_sx.png')
  officeGuySx:setFilter('nearest', 'nearest')
  officeGuyDx = love.graphics.newImage('assets/office_guy_dx.png')
  officeGuyDx:setFilter('nearest', 'nearest')

  p = Player:new()
  p.width = 32
  p.height = 32
  p.x = 0
  p.y = Y_FLOOR - p.width
  p.jumpSpeed = -500
  p.runSpeed = 200
  p.animationDx = newAnimation(officeGuyDx, 32, 32, 0.1, 0)
  p.animationSx = newAnimation(officeGuySx, 32, 32, 0.1, 0)
  p.animation = p.animationDx

  camera:newLayer(1, function() p:draw() end)
end

function love.update(dt)
  if love.keyboard.isDown("right") then p:moveRight() end
  if love.keyboard.isDown("left") then p:moveLeft() end
  if love.keyboard.isDown("x") then p:jump() end

  p:update(dt)
  
  camera:setPosition(p.x - love.graphics.getWidth()/2 + p.width/2, p.y - love.graphics.getHeight()/2 + p.height/2)
end

function love.draw()
  camera:draw()
  
  -- debug information
  if DEBUG then
    love.graphics.setColor(255, 255, 255)
    love.graphics.print("Player coordinates: ("..p.x..","..p.y..")", 5, 5)
    love.graphics.print("Current state: "..p.state, 5, 20)
    love.graphics.print("FPS: "..love.timer.getFPS(), 5, 35)
    love.graphics.print("Player runSpeed (+/-): "..p.runSpeed, 5, 50)
  end
end

function love.keyreleased(key)
  if key == "escape" then
    love.event.quit()
  end
  if (key == "right") or (key == "left") then
    p:stop()
  end

  if key == "d" then
    DEBUG = not DEBUG
  end

  if DEBUG then
    if key == "up" then
      Y_FLOOR = Y_FLOOR - 10
    end
    if key == "down" then
      Y_FLOOR = Y_FLOOR + 10
    end
    if key == "+" then
      p.runSpeed = p.runSpeed + 10
    end
    if key == "-" then
      p.runSpeed = p.runSpeed - 10
    end
  end
end

function posToTile(x, y)
  local tx=math.floor(x/CELLSIZE)
  local ty=math.floor(y/CELLSIZE)
  return tx, ty
end

function playerOnCells(x, y)
  local Cells={}
  local tx,ty=posToTile(x, y)
  local key=tx..','..ty
  Cells[key]=true
  Cells[#Cells+1]=key

  tx,ty=posToTile(x+PLAYERSIZE, y)
  key=tx..','..ty
  if not Cells[key] then
    Cells[key]=true
    Cells[#Cells+1]=key
  end

  tx,ty=posToTile(x+PLAYERSIZE, y+PLAYERSIZE)
  key=tx..','..ty
  if not Cells[key] then
    Cells[key]=true
    Cells[#Cells+1]=key
  end

  tx,ty=posToTile(x, y+PLAYERSIZE)
  key=tx..','..ty
  if not Cells[key] then
    Cells[key]=true
    Cells[#Cells+1]=key
  end
  return Cells
end

function isColliding(T)
  local collision=false
  for k,v in ipairs(T) do
    local x,y=v:match('(%d+),(%d+)')
    x,y=tonumber(x), tonumber(y)
    if not map[y] or not map[y][x] then
      collision=false -- off-map
    elseif map[tonumber(y)][tonumber(x)] == 1 then
      collision=true
    end
  end
  return collision
end


























-- function love.load()
--   CELLSIZE=32
--   PLAYERSIZE=16

--   Player={x=92, y=100, G=-100, S=100, jumping=false, falling=false, Cells={}}
--   createMap()
-- end

-- function love.update(dt)
--   playermove(dt)
-- end

-- function love.draw()
--   love.graphics.setColor(255,255,255)
--   for y=1,#map do
--     for x=1,#map[y] do
--       if map[y][x] == 1 then
--         love.graphics.rectangle("fill",x*CELLSIZE,y*CELLSIZE,CELLSIZE,CELLSIZE)
--       else
--         if DEBUG then
--           love.graphics.rectangle("line",x*CELLSIZE,y*CELLSIZE,CELLSIZE,CELLSIZE)
--         end
--       end
--     end
--   end
--   love.graphics.setColor(255,0,0,128)
--   love.graphics.rectangle("fill",Player.x,Player.y,PLAYERSIZE, PLAYERSIZE)
--   if DEBUG then
--     love.graphics.setColor(0,255,0)
--     love.graphics.print(string.format("Player at (%06.2f , %06.2f) jumping=%s falling=", Player.x, Player.y, tostring(Player.jumping), tostring(Player.falling)), 50,0)
--     love.graphics.print(string.format("Player occupies cells(%d): %s", #Player.Cells, table.concat(Player.Cells, ' | ')), 450,0)
--   end
-- end

-- -- is user off map?
-- function isOffMap(x, y)
--   if x<CELLSIZE or x+PLAYERSIZE> (1+#map[1])*CELLSIZE
--    or y<CELLSIZE or y+PLAYERSIZE>(1+#map)*CELLSIZE 
--   then
--     return true
--   else
--     return false
--   end
-- end

-- function createMap()
--   map = {
--       {0,0,0,0,0,0,0,0,0,0,},
--       {0,0,0,1,0,0,0,0,0,0,},
--       {0,0,0,0,0,0,0,0,1,0,},
--       {0,0,0,0,0,0,0,1,0,0,},
--       {0,0,0,1,0,0,0,0,0,0,},
--       {0,0,0,0,0,0,1,0,0,0,},
--       {1,1,1,1,1,1,1,1,1,1,},
--   }
-- end

-- -- which tile is that?
-- function posToTile(x, y)
--   local tx=math.floor(x/CELLSIZE)
--   local ty=math.floor(y/CELLSIZE)
--   return tx, ty
-- end

-- -- Find out which cells are occupied by a player (check for each corner)
-- function playerOnCells(x, y)
--   local Cells={}
--   local tx,ty=posToTile(x, y)
--   local key=tx..','..ty
--   Cells[key]=true
--   Cells[#Cells+1]=key

--   tx,ty=posToTile(x+PLAYERSIZE, y)
--   key=tx..','..ty
--   if not Cells[key] then
--     Cells[key]=true
--     Cells[#Cells+1]=key
--   end

--   tx,ty=posToTile(x+PLAYERSIZE, y+PLAYERSIZE)
--   key=tx..','..ty
--   if not Cells[key] then
--     Cells[key]=true
--     Cells[#Cells+1]=key
--   end

--   tx,ty=posToTile(x, y+PLAYERSIZE)
--   key=tx..','..ty
--   if not Cells[key] then
--     Cells[key]=true
--     Cells[#Cells+1]=key
--   end
--   return Cells
-- end

-- local isDown = love.keyboard.isDown
-- function playermove(dt)
--   -- Moving right or left?
--   local newX, newY
--   if isDown("left") then
--     newX=Player.x-Player.S*dt
--   end
--   if isDown("right") then
--     newX=Player.x+Player.S*dt
--   end
--   if newX then -- trying to move to a side
--     local offmap=isOffMap(newX, Player.y)
--     local colliding=isColliding(playerOnCells(newX, Player.y))
--     if not offmap and not colliding then
--       Player.x=newX
--     end
--   end

--   -- jumping up or falling down
--   Player.G = Player.G + Player.S*dt

--   if not Player.jumping and isDown(" ") and not Player.falling then
--     Player.jumping = true 
--     Player.G = -100
--   end

--     -- check only for upper or lower collision
--   newY= Player.y + Player.G*dt -- always falling

--   local coll=isColliding(playerOnCells(Player.x, newY))
--   if coll then
--     if Player.G>=0 then -- falling down on the ground
--       Player.jumping=false
--       Player.falling=false
--     end
--     Player.G=0
--   else
--     Player.falling=true -- falling down
--   end

--   if not isOffMap(Player.x, newY) and not coll then
--     Player.y=newY
--   end
--   if DEBUG then
--     Player.Cells=playerOnCells(Player.x, Player.y) -- 
--   end
-- end

-- -- list of tiles
-- function isColliding(T)
--   local collision=false
--   for k,v in ipairs(T) do
--     local x,y=v:match('(%d+),(%d+)')
--     x,y=tonumber(x), tonumber(y)
--     if not map[y] or not map[y][x] then
--       collision=true -- off-map
--     elseif map[tonumber(y)][tonumber(x)] == 1 then
--       collision=true
--     end
--   end
--   return collision
-- end

-- function love.keypressed(k)
--   if k=='escape' then
--     love.event.push('q')
--   end
--   if k=='d' then DEBUG=not DEBUG end
-- end

