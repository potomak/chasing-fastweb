-- Splash class
Splash = class('Splash', Scene)

function Splash:initialize(game)
  Scene.initialize(self, game)
end

function Splash:load()
  self.dt_temp = 0
end

function Splash:update(dt)
  -- Update dt_temp
  self.dt_temp = self.dt_temp + dt
  -- Wait 2.5 seconds, then stop in place.
  if self.dt_temp > 2.5 then
    self.dt_temp = 2.5
  end
end

function Splash:draw()
  love.graphics.setFont(titleFont)
  love.graphics.printf("Chasing FASTWEB", 0, (-1*40) + (self.dt_temp/2.5) * (love.graphics.getHeight()/2), love.graphics.getWidth(), "center")
end

function Splash:keyreleased(key)
end

function Splash:keypressed(key)
  Scene.keypressed(self, key)

  self.game:loadScene("mainScene")
end