local love = require("love")
local math = require("math")

function love.load()
    -- disable blur
    love.graphics.setDefaultFilter("nearest", "nearest")

    enemies = {}
    player = {}
    player.x = love.graphics.getWidth() / 2
    player.y = love.graphics.getHeight() / 2
    player.speed = 200
    player.direction = "down"
    player.idle = true
    -- 128x256
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
end

function love.update(dt)
    if #enemies == 0 then
        local number_of_enemies = math.random(1, 5)
        for i = 1, number_of_enemies do
            enemies[i] = {}
            enemies[i].x = 0
            enemies[i].y = math.random(0, love.graphics.getHeight())
            enemies[i].speed = math.random(50, 150)
        end
    -- going after player
    else
        for i = 1, #enemies do
            local vector = {x = enemies[i].x - player.x, y = enemies[i].y - player.y}
            local length = math.sqrt(vector.x^2 + vector.y^2)
            vector.x = vector.x / length
            vector.y = vector.y / length
            enemies[i].x = enemies[i].x - vector.x * enemies[i].speed * dt
            enemies[i].y = enemies[i].y - vector.y * enemies[i].speed * dt
        end
    end

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
      moveX = moveX + 1
      moveY = moveY - 1
      player.direction = "up_right"
      player.idle = false
  end
  if love.keyboard.isDown("up") and love.keyboard.isDown("left") then
      moveX = moveX - 1
      moveY = moveY - 1
      player.direction = "up_left"
      player.idle = false
  end
  if love.keyboard.isDown("down") and love.keyboard.isDown("right") then
      moveX = moveX + 1
      moveY = moveY + 1
      player.direction = "down_right"
      player.idle = false
  end
  if love.keyboard.isDown("down") and love.keyboard.isDown("left") then
      moveX = moveX - 1
      moveY = moveY + 1
      player.direction = "down_left"
      player.idle = false
  end
  

    if moveX == 0 and moveY == 0 then
        player.idle = true
    end

    local length = math.sqrt(moveX^2 + moveY^2)
    if length ~= 0 then
        moveX = moveX / length
        moveY = moveY / length
    end

    player.x = player.x + moveX * player.speed * dt
    player.y = player.y + moveY * player.speed * dt

    if player.idle then
        player.currentFrame = 1
    else
        player.animationTimer = player.animationTimer - dt
        if player.animationTimer <= 0 then
            player.currentFrame = player.currentFrame % cols + 1
            player.animationTimer = player.animationSpeed
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

    for i = 1, #enemies do
        love.graphics.setColor(1, 0, 0)
        love.graphics.rectangle("fill", enemies[i].x, enemies[i].y, 50, 50)
    end

    love.graphics.setColor(1, 1, 1)
    love.graphics.setBackgroundColor(0.5, 0.5, 0.5)
    local scaleFactor = 5

    local drawX = player.x - (frameWidth / 2) * scaleFactor
    local drawY = player.y - (frameHeight / 2) * scaleFactor

    love.graphics.draw(player.spriteSheet, player.quads[row][player.currentFrame], drawX, drawY, 0, scaleFactor)

    love.graphics.circle("fill", player.x, player.y, 5)
end
