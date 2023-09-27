Powerup = Class{}

function Powerup:init(skin)
    self.width = 16
    self.height = 16

    self.dy = math.random(50, 60)

    self.x = math.random(16, VIRTUAL_WIDTH - 32)
    self.y = 0

    self.skin = skin
end

function Powerup:update(dt)
    self.y = self.y + self.dy * dt
end

function Powerup:render()
    love.graphics.draw(gTextures['main'], gFrames['powerups'][self.skin], self.x, self.y)
end
