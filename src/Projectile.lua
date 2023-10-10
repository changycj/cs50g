--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Projectile = Class{__includes = GameObject}

function Projectile:init(def, x, y)
    GameObject.init(self, def, x, y)

    self.flying = false
    self.speed = 120
    self.direction = nil
    self.distanceFlew = 0
    self.destroyed = false
end

function Projectile:update(dt)
    if self.flying then
        local dist = self.speed * dt
        self.distanceFlew = self.distanceFlew + dist

        if self.direction == 'up' then
            self.y = self.y - dist
        end

        if self.direction == 'down' then
            self.y = self.y + dist
        end

        if self.direction == 'left' then
            self.x = self.x - dist
        end

        if self.direction == 'right' then
            self.x = self.x + dist
        end

        if self.distanceFlew > 16 * 4 then
           self.destroyed = true 
        end
    end
end

function Projectile:throw(direction) 
    self.flying = true
    self.direction = direction

    if self.direction == 'down' then
        self.y = self.y + 16 * 2
    end

    if self.direction == 'left' then
        self.x = self.x - 16
        self.y = self.y + 16
    end

    if self.direction == 'right' then
        self.x = self.x + 16
        self.y = self.y + 16
    end
end
