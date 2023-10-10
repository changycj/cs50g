--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerIdleState = Class{__includes = EntityIdleState}

function PlayerIdleState:init(entity, dungeon)
    self.entity = entity
    self.dungeon = dungeon
    local anim = entity.carryingPot and 'pot-idle-' or nil
    EntityIdleState:init(entity, anim)
end

function PlayerIdleState:enter(params)
    
    -- render offset for spaced character sprite (negated in render function of state)
    self.entity.offsetY = 5
    self.entity.offsetX = 0
end

function PlayerIdleState:update(dt)
    if love.keyboard.isDown('left') or love.keyboard.isDown('right') or
       love.keyboard.isDown('up') or love.keyboard.isDown('down') then
        self.entity:changeState('walk')
    end

    if not self.entity.carryingPot then
        if love.keyboard.wasPressed('space') then
            self.entity:changeState('swing-sword')
        end

        if love.keyboard.wasPressed('return') or love.keyboard.wasPressed('enter') then
            local pot = self.entity:canPickupPot(self.dungeon.currentRoom)
            if pot then
                self.entity.carryingPot = pot
                self.entity:changeState('pot-lift')
            end
        end
    else
        if love.keyboard.wasPressed('return') or love.keyboard.wasPressed('enter') then
            self.entity:changeState('pot-throw')
        end
    end
end