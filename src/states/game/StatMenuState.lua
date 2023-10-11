StatMenuState = Class{__includes = BaseState}

local function formatStatIncrease(stat, increase)
    return stat .. ' + ' .. increase .. ' = ' .. (stat + increase)
end

function StatMenuState:init(pokemon, hpIncrease, attackIncrease, defenseIncrease, speedIncrease)
    self.menu = Menu {
        showCursor = false,
        x = VIRTUAL_WIDTH / 2,
        y = 8,
        width = VIRTUAL_WIDTH / 2 - 8,
        height = 128,
        items = {
            {
                text = 'HP: ' .. formatStatIncrease(pokemon.HP, hpIncrease),
            },
            {
                text = 'Attack: ' .. formatStatIncrease(pokemon.attack, attackIncrease),
            },
            {
                text = 'Defense: ' .. formatStatIncrease(pokemon.defense, defenseIncrease),
            },
            {
                text = 'Speed: ' .. formatStatIncrease(pokemon.speed, speedIncrease),
            }
        }
    }
end

function StatMenuState:update(dt)
    self.menu:update(dt)
end

function StatMenuState:render()
    self.menu:render()
end