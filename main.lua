local love = require("love")

function love.load()
    love.physics.setMeter(64)
    world = love.physics.newWorld(0, 9.81*64, true)
  
    objects = {}
  
    objects.ground = {}
    objects.ground.body = love.physics.newBody(world, 650/2, 650-50/2)
    objects.ground.shape = love.physics.newRectangleShape(650, 50)
    objects.ground.fixture = love.physics.newFixture(objects.ground.body,
                                                     objects.ground.shape)
  
    objects.player = {}
    objects.player.body = love.physics.newBody(world, 650/2, 650/2, "dynamic")
    objects.player.shape = love.physics.newRectangleShape(40, 60)
    objects.player.fixture = love.physics.newFixture(objects.player.body,
                                                   objects.player.shape, 1)
    objects.player.body:setLinearDamping(0.1)
  
    love.graphics.setBackgroundColor(0.4, 0.4, 0.4)
    love.window.setMode(650, 650)
  end
  
  
  function love.update(dt)
    world:update(dt)
  
    if love.keyboard.isDown("right") then
      objects.player.body:applyForce(400, 0)
    elseif love.keyboard.isDown("left") then
      objects.player.body:applyForce(-400, 0)
    elseif love.keyboard.isDown("up") then
        objects.player.body:applyLinearImpulse(0, -30)
    end
  end
  
  function love.draw()
    love.graphics.translate(-objects.player.body:getX() + 650/2,
                            -objects.player.body:getY() + 650/2)

    love.graphics.setColor(0, 0, 0)
    love.graphics.polygon("fill", objects.ground.body:getWorldPoints(
                             objects.ground.shape:getPoints()))
  
    love.graphics.setColor(0.76, 0.18, 0.05)
    love.graphics.polygon("fill", objects.player.body:getWorldPoints(
                             objects.player.shape:getPoints()))
  
  end