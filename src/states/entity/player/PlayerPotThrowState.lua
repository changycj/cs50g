PlayerPotThrowState = Class{__includes = BaseState}

function PlayerPotThrowState:init(player)
    self.player = player
    self.player:changeAnimation('pot-throw-' .. self.player.direction)
end

function PlayerPotThrowState:update(dt)
    if self.player.currentAnimation.timesPlayed > 0 then
        self.player.currentAnimation.timesPlayed = 0
        self.player.carryingPot = false
        self.player:changeState('idle')
    end
end

function PlayerPotThrowState:render()
    local anim = self.player.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.player.x - self.player.offsetX), math.floor(self.player.y - self.player.offsetY))
end