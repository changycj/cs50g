LockedBrick = Class{__includes = Brick}

function LockedBrick:init(x, y)
    Brick.init(self, x, y)

    self.color = 6

    -- locked is tier 1, unlocked is tier 0
    self.tier = 1

    self.unlockable = false
end

function LockedBrick:hit()
    -- set the particle system to interpolate between two colors; in this case, we give
    -- it our self.color but with varying alpha; brighter for higher tiers, fading to 0
    -- over the particle's lifetime (the second color)
    self.psystem:setColors(
        paletteColors[self.color].r / 255,
        paletteColors[self.color].g / 255,
        paletteColors[self.color].b / 255,
        55 * (self.tier * 3 + 1) / 255,
        paletteColors[self.color].r / 255,
        paletteColors[self.color].g / 255,
        paletteColors[self.color].b / 255,
        0
    )
    self.psystem:emit(64)

    -- sound on hit
    gSounds['key-hit-1']:stop()
    gSounds['key-hit-1']:play()

    -- TODO check if there's key power up
    if self.tier > 0 then
        self.tier = self.tier - 1
    else
        self.inPlay = false
    end

    -- play a second layer sound if the brick is destroyed
    if not self.inPlay then
        gSounds['key-hit-2']:stop()
        gSounds['key-hit-2']:play()
    end
end

function LockedBrick:isLocked()
    return self.tier > 0
end

function LockedBrick:render()
    if self.inPlay then
        local dx = (self.unlockable and self.tier == 1) and math.random() or 0
        local dy = (self.unlockable and self.tier == 1) and math.random() or 0
        love.graphics.draw(gTextures['main'], 
            -- multiply color by 4 (-1) to get our color offset, then add tier to that
            -- to draw the correct tier and color brick onto the screen
            gFrames['bricks'][1 + ((self.color - 1) * 4) + self.tier],
            self.x + dx, self.y + dy)
    end
end
