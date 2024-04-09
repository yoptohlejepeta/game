local love = require("love")

function love.load()
    player = {}
    player.x = 50
    player.y = 50
    player.speed = 100
    player.direction = "down"
    player.idle = true
    -- 128x256
    player.spriteSheet = love.graphics.newImage("sprites/images/Characters/Civilian1_Move(weapon1).png")

    player.quads = {}
    cols = 4
    rows = 8
    -- 52x52
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
    love.graphics.scale(3)
    love.graphics.draw(player.spriteSheet, player.quads[row][player.currentFrame], player.x, player.y)

end