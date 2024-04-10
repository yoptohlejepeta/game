local love = require("love")
local math = require("math")
local utils = require("utils")

local player = require("characters/player/player")

function beginContact(a, b, col)
    local aData = a:getUserData()
    local bData = b:getUserData()

    if aData.type == "player" and bData.type == "enemy" then
        local playerBody = a:getBody()
        local nx, ny = col:getNormal()
        local impulseMagnitude = 10000

        playerBody:applyLinearImpulse(-nx * impulseMagnitude, -ny * impulseMagnitude)

        playerBody:setLinearDamping(5)
    elseif aData.type == "weapon" and bData.type == "enemy" then
        print("hit")
        b:getBody():destroy()
        for i, enemy in ipairs(enemies) do

            if i == bData.id then
                table.remove(enemies, i)
                break
            end
        end
    elseif aData.type == "enemy" and bData.type == "weapon" then
        print("hit")
        a:getBody():destroy()
        for i, enemy in ipairs(enemies) do
            if i == aData.id then
                table.remove(enemies, i)
                break
            end
        end
    end
end



function love.load()
    -- disable blur
    love.graphics.setDefaultFilter("nearest", "nearest")

    world = love.physics.newWorld(0, 0, true)
    world:setCallbacks(beginContact, nil, nil, nil)

    enemies = {}
    player = player_load(world)

    -- Initialize enemies
    for i = 1, 1 do
        enemies[i] = {}
        enemies[i].width = 60
        enemies[i].height = 60
        enemies[i].speed = math.random(50, 150)
        enemies[i].body = love.physics.newBody(world, utils.random_choice(0, love.graphics.getWidth()), math.random(0, love.graphics.getHeight()), "dynamic")
        enemies[i].shape = love.physics.newRectangleShape(enemies[i].width, enemies[i].height)
        enemies[i].fixture = love.physics.newFixture(enemies[i].body, enemies[i].shape)
        enemies[i].fixture:setUserData({type = "enemy", id = i})

        enemies[i].spriteSheet = love.graphics.newImage("sprites/demon_shug.png")
        demonFrameWidth = enemies[i].spriteSheet:getWidth()
        demonFrameHeight = enemies[i].spriteSheet:getHeight() / 4

        enemies[i].quads = {}
        for row = 1, 4 do
            local x = 0
            local y = (row - 1) * demonFrameHeight
            enemies[i].quads[row] = love.graphics.newQuad(x, y, demonFrameWidth, demonFrameHeight, enemies[i].spriteSheet:getDimensions())
    
        end

    end
end

function love.update(dt)
    world:update(dt)
    player:update(dt)

    for i, enemy in ipairs(enemies) do
        local playerX, playerY = player.body:getPosition()
        local enemyX, enemyY = enemy.body:getPosition()
        local vector = {x = enemyX - playerX, y = enemyY - playerY}
        local length = math.sqrt(vector.x^2 + vector.y^2)
        vector.x = vector.x / length
        vector.y = vector.y / length
        enemy.body:setLinearVelocity(-vector.x * enemy.speed, -vector.y * enemy.speed)

        if vector.x > 0 and math.abs(vector.x) > math.abs(vector.y) then
            enemy.row = 3
        elseif vector.y < 0 and math.abs(vector.y) > math.abs(vector.x) then
            enemy.row = 1
        elseif vector.y > 0 and math.abs(vector.y) > math.abs(vector.x) then
            enemy.row = 4
        elseif vector.x < 0 and math.abs(vector.x) > math.abs(vector.y) then
            enemy.row = 2
        end
    end
end

function love.draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.setBackgroundColor(0.5, 0.5, 0.5)

    player:draw(true)


    for i, enemy in ipairs(enemies) do
        love.graphics.setColor(1, 0, 0)

        local playerX, playerY = player.body:getPosition()
        local enemyX, enemyY = enemy.body:getPosition()
        love.graphics.rectangle("line", enemyX - enemy.width / 2, enemyY - enemy.height / 2, enemy.width, enemy.height)
        local vector = {x = enemyX - playerX, y = enemyY - playerY}
        local length = math.sqrt(vector.x^2 + vector.y^2)
        vector.x = vector.x / length
        vector.y = vector.y / length
        enemy.body:setLinearVelocity(-vector.x * enemy.speed, -vector.y * enemy.speed)
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(enemy.spriteSheet, enemy.quads[enemy.row], enemyX - enemy.width / 2, enemyY - enemy.height / 2, 0, 2)
    end
    
end
