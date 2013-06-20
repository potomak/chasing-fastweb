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
  obstacles = {}
  obstaclesNum = 12

  for i = 1, obstaclesNum do
    table.insert(obstacles, {
      x = X_BOUND/obstaclesNum * (i-1) - (32/2) + (love.graphics.getWidth()/2),
      y = Y_FLOOR - 32
    })
  end

  camera:newLayer(1, function()
    for _, obstacle in ipairs(obstacles) do
      love.graphics.setColor(128, 128, 128)
      love.graphics.rectangle('fill', obstacle.x, obstacle.y, 32, 32)

      love.graphics.setColor(255, 255, 255)
      if DEBUG then
        love.graphics.point(obstacle.x, obstacle.y)
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