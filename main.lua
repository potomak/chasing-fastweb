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

  tree_image = love.graphics.newImage('assets/tree.png')
  tree_image:setFilter('nearest', 'nearest')

  office_guy_sx = love.graphics.newImage('assets/office_guy_sx.png')
  office_guy_sx:setFilter('nearest', 'nearest')
  office_guy_dx = love.graphics.newImage('assets/office_guy_dx.png')
  office_guy_dx:setFilter('nearest', 'nearest')

  camera:setBounds(0, -love.graphics.getHeight(), X_BOUND - love.graphics.getWidth(), love.graphics.getHeight())

  camera:newLayer(.5, function()
    love.graphics.setColor(25, 200, 25)
    love.graphics.rectangle('fill', 0, Y_FLOOR, X_BOUND, love.graphics.getHeight())
  end)
  
  for _, i in ipairs({.5, 1, 2}) do
    local trees = {}
    local trees_n = 10
    local scale = i*8

    for j = 1, trees_n do
      table.insert(trees, {
        x = X_BOUND/trees_n * i * (j-1) - (tree_image:getWidth()*scale/2) + (love.graphics.getWidth()/2),
        y = Y_FLOOR - tree_image:getWidth()*scale
      })
    end
    
    camera:newLayer(i, function()
      for _, tree in ipairs(trees) do
        love.graphics.setColor(255, 255, 255)
        love.graphics.draw(tree_image, tree.x, tree.y, 0, scale)
      end
    end)
  end

  p = Player:new()
  p.width = 32
  p.height = 32
  p.x = 0
  p.y = Y_FLOOR - p.width
  p.jumpSpeed = -600
  p.runSpeed = 600
  p.animationDx = newAnimation(office_guy_dx, 32, 32, 0.1, 0)
  p.animationSx = newAnimation(office_guy_sx, 32, 32, 0.1, 0)
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
    love.graphics.print("Player runSpeed (+/-): "..p.runSpeed.., 5, 50)
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