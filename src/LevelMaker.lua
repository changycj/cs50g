--[[
    GD50
    Super Mario Bros. Remake

    -- LevelMaker Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

LevelMaker = Class{}

function LevelMaker.generate(width, height)
    local tiles = {}
    local entities = {}
    local objects = {}

    local tileID = TILE_ID_GROUND

    local keyGenerated = false
    
    -- whether we should draw our tiles with toppers
    local topper = true
    local tileset = math.random(20)
    local topperset = math.random(20)

    -- insert blank tables into tiles for later access
    for x = 1, height do
        table.insert(tiles, {})
    end

    local xToBlockHeight = {}

    -- column by column generation instead of row; sometimes better for platformers
    for x = 1, width do
        local tileID = TILE_ID_EMPTY
        
        -- lay out the empty space
        for y = 1, 6 do
            table.insert(tiles[y],
                Tile(x, y, tileID, nil, tileset, topperset))
        end

        local blockHeight
        -- chance to just be emptiness
        if math.random(7) == 1 then
            for y = 7, height do
                table.insert(tiles[y],
                    Tile(x, y, tileID, nil, tileset, topperset))
            end

            blockHeight = 0
        else
            tileID = TILE_ID_GROUND

            -- height at which we would spawn a potential jump block
            blockHeight = 4

            for y = 7, height do
                table.insert(tiles[y],
                    Tile(x, y, tileID, y == 7 and topper or nil, tileset, topperset))
            end

            -- chance to generate a pillar
            if math.random(8) == 1 then
                blockHeight = 2
                
                -- chance to generate bush on pillar
                if math.random(8) == 1 then
                    table.insert(objects,
                        GameObject {
                            texture = 'bushes',
                            x = (x - 1) * TILE_SIZE,
                            y = (4 - 1) * TILE_SIZE,
                            width = 16,
                            height = 16,
                            
                            -- select random frame from bush_ids whitelist, then random row for variance
                            frame = BUSH_IDS[math.random(#BUSH_IDS)] + (math.random(4) - 1) * 7,
                            collidable = false
                        }
                    )
                end
                
                -- pillar tiles
                tiles[5][x] = Tile(x, 5, tileID, topper, tileset, topperset)
                tiles[6][x] = Tile(x, 6, tileID, nil, tileset, topperset)
                tiles[7][x].topper = nil
            
            -- chance to generate bushes
            elseif math.random(8) == 1 then
                table.insert(objects,
                    GameObject {
                        texture = 'bushes',
                        x = (x - 1) * TILE_SIZE,
                        y = (6 - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,
                        frame = BUSH_IDS[math.random(#BUSH_IDS)] + (math.random(4) - 1) * 7,
                        collidable = false
                    }
                )
            end

            -- chance to spawn a block
            if math.random(10) == 1 then
                table.insert(objects,
                    -- jump block
                    GameObject {
                        texture = 'jump-blocks',
                        x = (x - 1) * TILE_SIZE,
                        y = (blockHeight - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,

                        -- make it a random variant
                        frame = math.random(#JUMP_BLOCKS),
                        collidable = true,
                        hit = false,
                        solid = true,

                        -- collision function takes itself
                        onCollide = function(obj)

                            -- spawn a gem if we haven't already hit the block
                            if not obj.hit then

                                -- chance to spawn gem, not guaranteed
                                if math.random(5) == 1 then

                                    -- maintain reference so we can set it to nil
                                    local gem = GameObject {
                                        texture = 'gems',
                                        x = (x - 1) * TILE_SIZE,
                                        y = (blockHeight - 1) * TILE_SIZE - 4,
                                        width = 16,
                                        height = 16,
                                        frame = math.random(#GEMS),
                                        collidable = true,
                                        consumable = true,
                                        solid = false,

                                        -- gem has its own function to add to the player's score
                                        onConsume = function(player, object)
                                            gSounds['pickup']:play()
                                            player.score = player.score + 100
                                        end
                                    }
                                    
                                    -- make the gem move up from the block and play a sound
                                    Timer.tween(0.1, {
                                        [gem] = {y = (blockHeight - 2) * TILE_SIZE}
                                    })
                                    gSounds['powerup-reveal']:play()

                                    table.insert(objects, gem)
                                end

                                obj.hit = true
                            end

                            gSounds['empty-block']:play()
                        end
                    }
                )
            elseif not keyGenerated and math.random(10) == 1 then
                keyGenerated = true
                local lock = GameObject {
                    texture = 'keys-and-locks',
                    x = (x - 1) * TILE_SIZE,
                    y = (blockHeight - 1) * TILE_SIZE,
                    width = 16,
                    height = 16,

                    -- make it a random variant
                    frame = LOCKS[math.random(#LOCKS)],
                    collidable = true,
                    hit = false,
                    solid = true,

                    -- collision function takes itself
                    onCollide = function(obj)
                        gSounds['empty-block']:play()
                    end
                }
                table.insert(objects, lock)

                local key = GameObject {
                    texture = 'keys-and-locks',
                    x = (x - 1) * TILE_SIZE,
                    y = (blockHeight - 2) * TILE_SIZE,
                    width = 16,
                    height = 16,
                    frame = KEYS[math.random(#KEYS)],
                    collidable = true,
                    consumable = true,
                    solid = false,

                    -- gem has its own function to add to the player's score
                    onConsume = function(player, object)
                        gSounds['pickup']:play()
                        player.score = player.score + 100

                        Timer.tween(1, {
                            [lock] = {opacity = 0}
                        }):finish(function ()
                            -- lock disappears
                            for k, obj in pairs(player.level.objects) do
                                if obj.x == object.x and math.abs(obj.y - object.y) == 16 then
                                    table.remove(player.level.objects, k)
                                    player:changeState('falling')
                                    break
                                end
                            end

                            -- spawn goal post, put at last flat ground tile
                            local goalX
                            for i = #xToBlockHeight - 1, 1, -1 do
                                if xToBlockHeight[i] == 4 then
                                    goalX = i
                                    break
                                end
                            end

                            local goal = GameObject {
                                texture = 'poles',
                                -- x = (width - 3) * TILE_SIZE,
                                -- x = (x + 5) * TILE_SIZE,
                                x = (goalX - 1) * TILE_SIZE,
                                y = (xToBlockHeight[goalX] - 1) * TILE_SIZE,
                                width = 16,
                                height = 48,
                                frame = math.random(#POLES),
                                collidable = true,
                                consumable = true,
                                solid = false,
                                onConsume = function(player, object)
                                    gStateMachine:change('play', { 
                                        score = player.score,
                                        width = player.level.tileMap.width + 10
                                    })
                                end
                            }

                            -- flag
                            local flag = GameObject {
                                texture = 'flags',
                                x = (goalX - 1) * TILE_SIZE + 8,
                                y = (xToBlockHeight[goalX] - 1) * TILE_SIZE,
                                width = 16,
                                height = 16,
                                frame = math.random(#FLAGS),
                                collidable = true,
                                consumable = true,
                                solid = false,
                                onConsume = function(player, object)
                                    gStateMachine:change('play', { 
                                        score = player.score,
                                        width = player.level.tileMap.width + 10
                                    })
                                end
                            }
                            table.insert(objects, flag)
                            table.insert(objects, goal)
                        end)
                    end
                }
                table.insert(objects, key)
            end
        end

        xToBlockHeight[x] = blockHeight
    end

    local map = TileMap(width, height)
    map.tiles = tiles
    
    return GameLevel(entities, objects, map)
end