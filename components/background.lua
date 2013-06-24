-- Background class
Background = class('Background')

function Background:initialize(image, backgroundWidth)
  self.image = image
  self.backgroundWidth = backgroundWidth

  if world.showBackground then
    love.graphics.setBackgroundColor(220, 248, 244)
  end
end

function Background:draw()
  if world.showBackground then
    local tilesNumber = math.ceil(self.backgroundWidth / self.image:getWidth())
    
    love.graphics.setColor(255, 255, 255)
    for i = 1, tilesNumber do
      love.graphics.draw(self.image, (i-1)*self.image:getWidth(), 0, 0, 2)
    end
  end
end