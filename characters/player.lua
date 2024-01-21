local love = require("love")

local player = {
    width = 40,
    height = 60,
    grounded = false
}

function player:load(world)
    self.x = 0
    self.y = 0
    self.speed = 300
    self.body = love.physics.newBody(world, self.x, self.y, "dynamic")
    self.shape = love.physics.newRectangleShape(self.width, self.height)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setUserData("Player")
end

function player:update(dt)
    if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
        self.body:applyForce(-self.speed, 0)
    elseif love.keyboard.isDown("right") or love.keyboard.isDown("d") then
        self.body:applyForce(self.speed, 0)
    elseif love.keyboard.isDown("up") or love.keyboard.isDown("w") then
        if self.grounded then
            self.body:applyForce(0, -self.speed * 2)
        end
    end
end

function player:draw()
    love.graphics.setColor(0, 0.4, 0.4)
    love.graphics.rectangle("fill", self.body:getX(), self.body:getY(), self.width, self.height)
end

return player
