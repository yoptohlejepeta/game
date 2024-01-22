local player = require("characters/player")
local love = require("love")
local config = require("config")

local WORLD = love.physics.newWorld(0, config.GRAVITY, true)
WORLD:setCallbacks(beginContact, endContact)

function beginContact(a, b, coll)
    local x, y = coll:getNormal()
    if x == 0 and y == -1 then
        player.grounded = true
    end
end


function endContact(a, b, coll)
    local x, y = coll:getNormal()
    if a == player.fixture or b == player.fixture then
        player.grounded = false
    end
end

return {
    WORLD = WORLD
}
