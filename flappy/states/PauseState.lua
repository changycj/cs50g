PauseState = Class{__includes = BaseState}

local PAUSE_RECT_WIDTH = 40
local PAUSE_RECT_HEIGHT = 120
local PAUSE_RECT_GAP = 50

function PauseState:init()
    self.isPaused = true
end

function PauseState:enter(params)
    self.playState = params.playState
    sounds['pause']:play()
    sounds['music']:pause()
end

function PauseState:update(dt)
    if love.keyboard.wasPressed('p') then
        gStateMachine:change('play', {
            playState = self.playState
        })
    end
end

function PauseState:render()
    self.playState:render()

    love.graphics.setColor(255, 255, 255, 0.75)
    love.graphics.rectangle("fill",
        VIRTUAL_WIDTH / 2 - PAUSE_RECT_GAP / 2 - PAUSE_RECT_WIDTH,
        VIRTUAL_HEIGHT / 2 -  PAUSE_RECT_HEIGHT / 2,
        PAUSE_RECT_WIDTH,
        PAUSE_RECT_HEIGHT
    )
    love.graphics.rectangle("fill",
        VIRTUAL_WIDTH / 2 + PAUSE_RECT_GAP / 2,
        VIRTUAL_HEIGHT / 2 -  PAUSE_RECT_HEIGHT / 2,
        PAUSE_RECT_WIDTH,
        PAUSE_RECT_HEIGHT
    )
    love.graphics.setColor(255, 255, 255) -- reset colours
end

function PauseState:exit()
    sounds['music']:play()
end
