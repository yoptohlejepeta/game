local love = require("love")
local math = require("math")
local utils = require("utils")

function beginContact(a, b, col)
    local aData = a:getUserData()
    local bData = b:getUserData()

    if aData == "player" and bData == "enemy" then
        local playerBody = a:getBody()
        local nx, ny = col:getNormal()
        local impulseMagnitude = 5000

        playerBody:applyLinearImpulse(-nx * impulseMagnitude, -ny * impulseMagnitude)
    end
end


function love.load()
    -- disable blur
    love.graphics.setDefaultFilter("nearest", "nearest")

    world = love.physics.newWorld(0, 0, true)
    world:setCallbacks(beginContact, nil, nil, nil)

    enemies = {}
    player = {}
    player.width = 60
    player.height = 80
    player.speed = 200
    player.direction = "down"
    player.idle = true
    player.body = love.physics.newBody(world, love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, "dynamic")
    player.shape = love.physics.newRectangleShape(player.width, player.height)
    player.fixture = love.physics.newFixture(player.body, player.shape)
    player.fixture:setUserData("player")

    player.spriteSheet = love.graphics.newImage("sprites/images/Characters/Civilian1_Move(weapon1).png")

    player.quads = {}
    cols = 4
    rows = 8

    frameWidth = player.spriteSheet:getWidth() / cols
    frameHeight = player.spriteSheet:getHeight() / rows

    for row = 1, rows do
        player.quads[row] = {}
        for col = 1, cols do
            local x = (col - 1) * frameWidth
            local y = (row - 1) * frameHeight
            player.quads[row][col] = love.graphics.newQuad(x, y, frameWidth, frameHeight, player.spriteSheet:getDimensions())
        end
    end

    player.currentFrame = 1
    player.animationSpeed = 0.1
    player.animationTimer = player.animationSpeed

    -- Initialize enemies
    for i = 1, 5 do
        enemies[i] = {}
        enemies[i].width = 60
        enemies[i].height = 60
        enemies[i].speed = math.random(50, 150)
        enemies[i].body = love.physics.newBody(world, utils.random_choice(0, love.graphics.getWidth()), math.random(0, love.graphics.getHeight()), "dynamic")
        enemies[i].shape = love.physics.newRectangleShape(enemies[i].width, enemies[i].height)
        enemies[i].fixture = love.physics.newFixture(enemies[i].body, enemies[i].shape)
        enemies[i].fixture:setUserData("enemy")

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

    local moveX, moveY = 0, 0

    if love.keyboard.isDown("right") then
        moveX = moveX + 1
        player.direction = "right"
        player.idle = false
    end
    if love.keyboard.isDown("left") then
        moveX = moveX - 1
        player.direction = "left"
        player.idle = false
    end
    if love.keyboard.isDown("down") then
        moveY = moveY + 1
        player.direction = "down"
        player.idle = false
    end
    if love.keyboard.isDown("up") then
        moveY = moveY - 1
        player.direction = "up"
        player.idle = false
    end
    if love.keyboard.isDown("up") and love.keyboard.isDown("right") then
        player.direction = "up_right"
        player.idle = false
    end
    if love.keyboard.isDown("up") and love.keyboard.isDown("left") then
        player.direction = "up_left"
        player.idle = false
    end
    if love.keyboard.isDown("down") and love.keyboard.isDown("right") then
        player.direction = "down_right"
        player.idle = false
    end
    if love.keyboard.isDown("down") and love.keyboard.isDown("left") then
        player.direction = "down_left"
        player.idle = false
    end


    local length = math.sqrt(moveX^2 + moveY^2)
    if length ~= 0 then
        moveX = moveX / length
        moveY = moveY / length
    end

    player.body:setLinearVelocity(moveX * player.speed, moveY * player.speed)

    if player.idle then
        player.currentFrame = 1
    else
        player.animationTimer = player.animationTimer - dt
        if player.animationTimer <= 0 then
            player.currentFrame = player.currentFrame % cols + 1
            player.animationTimer = player.animationSpeed
        end
    end

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
    local row = 1
    if player.direction == "up" then
        row = 5
    elseif player.direction == "down" then
        row = 1
    elseif player.direction == "left" then
        row = 7
    elseif player.direction == "right" then
        row = 3
    elseif player.direction == "up_right" then
        row = 4
    elseif player.direction == "up_left" then
        row = 6
    elseif player.direction == "down_right" then
        row = 2
    elseif player.direction == "down_left" then
        row = 8
    end


    love.graphics.setColor(1, 1, 1)
    love.graphics.setBackgroundColor(0.5, 0.5, 0.5)
    local scaleFactor = 5

    local drawX, drawY = player.body:getPosition()

    drawX = drawX - (frameWidth / 2) * scaleFactor
    drawY = drawY - (frameHeight / 2) * scaleFactor

    love.graphics.draw(player.spriteSheet, player.quads[row][player.currentFrame], drawX, drawY, 0, scaleFactor)
    -- draw player hitboxes
    love.graphics.setColor(1, 0, 0)
    local playerX, playerY = player.body:getPosition()
    love.graphics.rectangle("line", playerX - player.width / 2, playerY - player.height / 2, player.width, player.height)

    for i, enemy in ipairs(enemies) do
        local playerX, playerY = player.body:getPosition()
        local enemyX, enemyY = enemy.body:getPosition()
        love.graphics.rectangle("line", enemyX - enemy.width / 2, enemyY - enemy.height / 2, enemy.width, enemy.height)
        local vector = {x = enemyX - playerX, y = enemyY - playerY}
        local length = math.sqrt(vector.x^2 + vector.y^2)
        vector.x = vector.x / length
        vector.y = vector.y / length
        enemy.body:setLinearVelocity(-vector.x * enemy.speed, -vector.y * enemy.speed)
    
        -- Set demon_row to 1 for all enemies to draw the first row of the sprite sheet
        -- Draw the demon (using the first row of the sprite sheet)
        -- love.graphics.draw(enemy.spriteSheet, enemyX, enemyY, 0, scaleFactor)
        love.graphics.draw(enemy.spriteSheet, enemy.quads[enemy.row], enemyX - enemy.width / 2, enemyY - enemy.height / 2, 0, 2)
    end
    
end
