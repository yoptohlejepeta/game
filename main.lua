local love = require("love")

function love.load()
  player = {}
  player.x = 50
  player.y = 50
  player.speed = 300

  end
  
  
  function love.update(dt)
    local moveX, moveY = 0, 0
  
    if love.keyboard.isDown("right") then
      moveX = moveX + 1
    end
    if love.keyboard.isDown("left") then
      moveX = moveX - 1
    end
    if love.keyboard.isDown("down") then
      moveY = moveY + 1
    end
    if love.keyboard.isDown("up") then
      moveY = moveY - 1
    end
  
    local length = math.sqrt(moveX^2 + moveY^2)
    if length ~= 0 then
      moveX = moveX / length
      moveY = moveY / length
    end
  
    player.x = player.x + moveX * player.speed * dt
    player.y = player.y + moveY * player.speed * dt
  end
  
  
  function love.draw()

    love.graphics.circle("fill", player.x, player.y, 60)
  end