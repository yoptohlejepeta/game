local player = require("characters/player")
local love = require("love")

local WORLD = love.physics.newWorld(0, 1000, true)
WORLD:setCallbacks(beginContact, endContact)

function beginContact(a, b, coll)
    local x, y = coll:getNormal()
    if x == 0 and y == -1 then
        player.grounded = true
    end
end

function endContact(a, b, coll)
    local x, y = coll:getNormal()
    if x == 0 and y == -1 then
        player.grounded = false
    end
end

return {
    WORLD = WORLD
}
