--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Player = Class{__includes = Entity}

function Player:init(def)
    Entity.init(self, def)

    self.carryingPot = nil
end

function Player:update(dt)
    Entity.update(self, dt)

    if self.carryingPot then
        self.carryingPot.x = self.x
        self.carryingPot.y = self.y - 16
    end
end

function Player:collides(target)
    local selfY, selfHeight = self.y + self.height / 2, self.height - self.height / 2
    
    return not (self.x + self.width < target.x or self.x > target.x + target.width or
                selfY + selfHeight < target.y or selfY > target.y + target.height)
end

function Player:render()
    Entity.render(self)
    
    -- love.graphics.setColor(255, 0, 255, 255)
    -- love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
    -- love.graphics.setColor(255, 255, 255, 255)
end

-- check if player is facing and next to a pot
-- if so, return that pot
function Player:canPickupPot(room)
    for k, obj in pairs(room.objects) do
        if obj.type == 'pot' then
            local dx = self.x - obj.x
            local dy = self.y - obj.y
            -- player is either above or below
            if math.abs(dx) < 32 then
                -- player is below
                if dy > 0 and self.direction == 'up' then
                    return obj
                end
                -- player is above
                if dy < 0 and self.direction == 'down' then
                    return obj
                end
            end

            -- player is either left or right
            if math.abs(dy) < 32 then
                if dx > 0 and self.direction == 'left' then
                    return obj
                end
                if dx < 0 and self.direction == 'right' then
                    return obj
                end
            end
        end
    end
    return nil
end