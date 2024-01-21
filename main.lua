local love = require("love")
local player = require("characters/player")
local config = require("config")

function love.load()
    love.physics.setMeter(64)
    world = love.physics.newWorld(0, config.GRAVITY, true)
  

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
    elseif love.keyboard.isDown("up") then
      player.body:applyLinearImpulse(0, -30)
    end
  end
  
  function love.draw()
    love.graphics.translate(-player.body:getX() + 650/2, -player.body:getY() + 650/2)

    love.graphics.setColor(0, 0, 0)
    love.graphics.polygon("fill", ground.body:getWorldPoints(ground.shape:getPoints()))
  
    love.graphics.setColor(0.76, 0.18, 0.05)
    love.graphics.polygon("fill", player.body:getWorldPoints(player.shape:getPoints()))
  
  end