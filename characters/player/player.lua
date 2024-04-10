local love = require("love")


local player = {
    width = 50,
    height = 90,
    speed = 200,
    direction = "down",
    action = "idle",

}

function player_load(world)
    
    player.body = love.physics.newBody(world, love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, "dynamic")
    player.body:setFixedRotation(true)
    player.shape = love.physics.newRectangleShape(player.width, player.height)
    player.fixture = love.physics.newFixture(player.body, player.shape)
    player.fixture:setUserData("player")

    player.spriteSheet = love.graphics.newImage("sprites/images/Characters/Knight1_Move.png")

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
    player.attackTimer = 0.5

   return player 
end


function player:update(dt)
    self:check_state()

    if self.action == "attack" then
        self.attackTimer = self.attackTimer - dt
        if self.attackTimer <= 0 then
            self.currentFrame = self.currentFrame % cols + 1
            self.attackTimer = 0.5
            self.action = "idle"
        end
    end

    local moveX, moveY = 0, 0
    if self.action ~= "attack" then
        if love.keyboard.isDown("right") then
            moveX = moveX + 1
            self.direction = "right"
            self.action = "move"
        end
        if love.keyboard.isDown("left") then
            moveX = moveX - 1
            self.direction = "left"
            self.action = "move"
        end
        if love.keyboard.isDown("down") then
            moveY = moveY + 1
            self.direction = "down"
            self.action = "move"
        end
        if love.keyboard.isDown("up") then
            moveY = moveY - 1
            self.direction = "up"
            self.action = "move"
        end
        if love.keyboard.isDown("up") and love.keyboard.isDown("right") then
            self.direction = "up_right"
            self.action = "move"
        end
        if love.keyboard.isDown("up") and love.keyboard.isDown("left") then
            self.direction = "up_left"
            self.action = "move"
        end
        if love.keyboard.isDown("down") and love.keyboard.isDown("right") then
            self.direction = "down_right"
            self.action = "move"
        end
        if love.keyboard.isDown("down") and love.keyboard.isDown("left") then
            self.direction = "down_left"
            self.action = "move"
        end
    end


    if moveX == 0 and moveY == 0 and self.action ~= "attack" then
        self.action = "idle"
    end


    local length = math.sqrt(moveX^2 + moveY^2)
    if length ~= 0 then
        moveX = moveX / length
        moveY = moveY / length
    end

    self.body:setLinearVelocity(moveX * self.speed, moveY * self.speed)

    if self.action == "idle" then
        self.currentFrame = 1
    else
        self.animationTimer = self.animationTimer - dt
        if self.animationTimer <= 0 then
            self.currentFrame = self.currentFrame % cols + 1
            self.animationTimer = self.animationSpeed
        end
    end
    
end


function player:draw(hitbox)
    local row = 1
    if self.direction == "up" then
        row = 5
    elseif self.direction == "down" then
        row = 1
    elseif self.direction == "left" then
        row = 7
    elseif self.direction == "right" then
        row = 3
    elseif self.direction == "up_right" then
        row = 4
    elseif self.direction == "up_left" then
        row = 6
    elseif self.direction == "down_right" then
        row = 2
    elseif self.direction == "down_left" then
        row = 8
    end

    
    local scaleFactor = 5

    local drawX, drawY = self.body:getPosition()

    drawX = drawX - (frameWidth / 2) * scaleFactor
    drawY = drawY - (frameHeight / 2) * scaleFactor

    love.graphics.draw(self.spriteSheet, self.quads[row][self.currentFrame], drawX, drawY, 0, scaleFactor)

    if hitbox == true then
        love.graphics.setColor(1, 0, 0)
        love.graphics.polygon("line", self.body:getWorldPoints(self.shape:getPoints()))
    end
    
end

function player:check_state()
    if self.action == "attack" then
        self.spriteSheet = love.graphics.newImage("sprites/images/Characters/Knight1_Attack.png")
    elseif self.action == "idle" then
        self.spriteSheet = love.graphics.newImage("sprites/images/Characters/Knight1_Move.png")
    elseif self.action == "move" then
        self.spriteSheet = love.graphics.newImage("sprites/images/Characters/Knight1_Move.png")
    end

    if self.direction == "up" then
        row = 5
    elseif self.direction == "down" then
        row = 1
    elseif self.direction == "left" then
        row = 7
    elseif self.direction == "right" then
        row = 3
    elseif self.direction == "up_right" then
        row = 4
    elseif self.direction == "up_left" then
        row = 6
    elseif self.direction == "down_right" then
        row = 2
    elseif self.direction == "down_left" then
        row = 8
    end
end

function love.keypressed(key)
    if key == "space" then
        player.currentFrame = 1
        player.action = "attack"
    end
    
end