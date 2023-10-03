--[[
    GD50
    Match-3 Remake

    -- Tile Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The individual tiles that make up our game board. Each Tile can have a
    color and a variety, with the varietes adding extra points to the matches.
]]

Tile = Class{}

function Tile:init(x, y, level)
    
    -- board positions
    self.gridX = x
    self.gridY = y

    -- coordinate positions
    self.x = (self.gridX - 1) * 32
    self.y = (self.gridY - 1) * 32

    -- tile appearance/points
    local x = math.random(8)
    local color = 2 * x - (x + 1) % 2
    self.color = color
    self.variety = math.random(math.min(6, level))

    self.shiny = math.random() > 0.9
end

function Tile:render(x, y)
    
    -- draw shadow
    love.graphics.setColor(34/255, 32/255, 52/255, 1)
    love.graphics.draw(gTextures['main'], gFrames['tiles'][self.color][self.variety],
        self.x + x + 2, self.y + y + 2)

    -- draw tile itself
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(gTextures['main'], gFrames['tiles'][self.color][self.variety],
        self.x + x, self.y + y)

    -- make tile shiny if needed
    if self.shiny then
        -- multiply so drawing white rect makes it brighter
        love.graphics.setBlendMode('add')

        love.graphics.setLineWidth(6)
        love.graphics.setColor(255/255, 215/255, 0, 0.45)
        love.graphics.rectangle('line', self.x + x + 2, self.y + y + 2, 28, 28, 4)

        -- back to alpha
        love.graphics.setBlendMode('alpha')
    end
end