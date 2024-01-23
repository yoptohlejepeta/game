local love = require("love")
local player = require("characters/player")

function love.load()
    love.physics.setMeter(64)
    world = love.physics.newWorld(0, (9.81*64), true)
    world:setCallbacks(beginContact, endContact)
  
    ground = {}
    ground.body = love.physics.newBody(world, 650/2, 650-50/2)
    ground.shape = love.physics.newRectangleShape(love.graphics.getWidth(), 50)
    ground.fixture = love.physics.newFixture(ground.body, ground.shape)
    ground.fixture:setUserData("Ground")
    ground.fixture:setFriction(0.5)
  
    player = player:load(world)
    animation = newAnimation(love.graphics.newImage("sprites/run.png"), 32, 32, 1)
    love.graphics.setBackgroundColor(0.4, 0.4, 0.4)
  end
  
  
  function love.update(dt)
    world:update(dt)
    player:update(dt)

    animation.currentTime = animation.currentTime + dt
    if animation.currentTime >= animation.duration then
        animation.currentTime = animation.currentTime - animation.duration
    end

  end
  
  function love.draw()
    -- camera
    love.graphics.translate(
      -player.body:getX() + love.graphics.getWidth()/2 - player.width/2,
      -player.body:getY() + love.graphics.getHeight()/2 - player.height/2
    )

    love.graphics.setColor(0, 0, 0)
    love.graphics.polygon("fill", ground.body:getWorldPoints(ground.shape:getPoints()))
  
    love.graphics.setColor(0,0,0)
    love.graphics.polygon("fill", player.body:getWorldPoints(player.shape:getPoints()))

    love.graphics.setColor(1, 1, 1)
    local spriteNum = math.floor(animation.currentTime / animation.duration * #animation.quads) + 1
    love.graphics.draw(animation.spriteSheet, animation.quads[spriteNum], player.body:getX(), player.body:getY(), 0, 4, 4, 16, 16)

  end


function newAnimation(image, width, height, duration)
  local animation = {}
  animation.spriteSheet = image;
  animation.quads = {};

  for y = 0, image:getHeight() - height, height do
      for x = 0, image:getWidth() - width, width do
          table.insert(animation.quads, love.graphics.newQuad(x, y, width, height, image:getDimensions()))
      end
  end

  animation.duration = duration or 1
  animation.currentTime = 0

  return animation
end

function beginContact(a, b, coll)
    local x, y = coll:getNormal()
    if (x == 0 and y == -1) and (a == player.fixture or b == player.fixture) then
        player.grounded = true
    end
end


function endContact(a, b, coll)
    local x, y = coll:getNormal()
    if a == player.fixture or b == player.fixture then
        player.grounded = false
    end
end