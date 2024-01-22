local love = require("love")
local player = require("characters/player")
local config = require("config")
local level = require("level")

function love.load()
    love.physics.setMeter(64)
    world = love.physics.newWorld(0, config.GRAVITY, true)
    world:setCallbacks(beginContact, endContact)
  
    ground = {}
    ground.body = love.physics.newBody(world, 650/2, 650-50/2)
    ground.shape = love.physics.newRectangleShape(650, 50)
    ground.fixture = love.physics.newFixture(ground.body, ground.shape)
  
    player = player:load(world)
  
    love.graphics.setBackgroundColor(0.4, 0.4, 0.4)
    love.window.setMode(650, 650)
  end
  
  
  function love.update(dt)
    world:update(dt)

    if love.keyboard.isDown("right") then
      player.body:applyForce(400, 0)
    elseif love.keyboard.isDown("left") then
      player.body:applyForce(-400, 0)
    elseif love.keyboard.isDown("up") and player.grounded == true then
      player.body:applyLinearImpulse(0, -100)
    end
  end
  
  function love.draw()
    love.graphics.translate(-player.body:getX() + 650/2, -player.body:getY() + 650/2)

    love.graphics.setColor(0, 0, 0)
    love.graphics.polygon("fill", ground.body:getWorldPoints(ground.shape:getPoints()))
  
    love.graphics.setColor(0.76, 0.18, 0.05)
    love.graphics.polygon("fill", player.body:getWorldPoints(player.shape:getPoints()))
  
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