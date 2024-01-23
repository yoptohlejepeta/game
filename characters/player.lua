local love = require("love")

local player = {
    width = 60,
    height = 90,
    grounded = false,
    spriteSheet = love.graphics.newImage("sprites/run.png"),
} 

function player:load(world)
    self.x = 0
    self.y = 0
    self.speed = 300
    self.body = love.physics.newBody(world, self.x, self.y, "dynamic")
    self.shape = love.physics.newRectangleShape(self.width, self.height)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setUserData("Player")

    return self
end

function player:update(dt)
    if love.keyboard.isDown("right") then
      player.body:applyLinearImpulse(0, -10)
        player.body:applyForce(600, 0)
      elseif love.keyboard.isDown("left") then
        player.body:applyForce(-600, 0)
      elseif love.keyboard.isDown("up") and player.grounded == true then
        player.body:applyLinearImpulse(0, -300)
      end
end

function player:draw()
    love.graphics.setColor(0, 0.4, 0.4)
    love.graphics.rectangle("fill", self.body:getX(), self.body:getY(), self.width, self.height)
end


function player:animate(width, height, duration)
    local animation = {}
    animation.spriteSheet = self.spriteSheet
    animation.quads = {}
    for y = 0, self.spriteSheet:getHeight() - height, height do
        for x = 0, self.spriteSheet:getWidth() - width, width do
            table.insert(animation.quads, love.graphics.newQuad(x, y, width, height, self.spriteSheet:getDimensions()))
        end
    end
    animation.duration = duration or 1
    animation.currentTime = 0

    return animation

end


return player
