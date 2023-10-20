Player = Class()

local scale = 3

local spritesheet = love.graphics.newImage("src/entities/player/spritesheet/sheet.png")
local sheet_width, sheet_height = spritesheet:getDimensions()
local frame_width, frame_height = sheet_width/8, sheet_height/2
local grid = anim8.newGrid(frame_width, frame_height, sheet_width, sheet_height)
local animations = {
    idle = anim8.newAnimation(grid('1-8', 2), 0.1),
    running = anim8.newAnimation(grid('1-8', 1), 0.08)
}

local walk_sound = love.audio.newSource("src/static/audio/running.mp3", "static")
walk_sound:setLooping(true)



function Player:init(mundo)
    self.mundo = mundo
    self.speed = 300
    self.x = 50
    self.y = 1350
    self.w = frame_width * scale
    self.h = frame_height * scale
    self.dir = 1
    self.impulso = 0
    self.grounded = false
    self.collider = mundo:newRectangleCollider(
        self.x,
        self.y,
        self.w,
        self.h,
        {collision_class='player'}
    )
    self.collider:setFixedRotation(true)
    self.collider:setRestitution(0)
    self.collider:setMass(6)
    self.collider:setFriction(0)
    self.animation = animations.idle
end


function Player:update(dt)
    self:move()
    self.animation:update(dt)
    self:updateGrounded()
    if self:isJumping() then
        self.collider:applyLinearImpulse(0, -self.impulso)
    end
end

function Player:updateGrounded()
    local colliders = self.mundo:queryRectangleArea(
        self.collider:getX()-self.w/2,
        self.collider:getY()+self.h/2,
        self.w,
        1,
        {'ground', 'box'}
    )
    self.grounded = #colliders > 0
end

function Player:isJumping()
    return
        not
        self.grounded
        and
        (
            controle:isGamepadDown('x')
            or
            love.keyboard.isDown('space')
        )
end


function Player:draw()
    self.animation:draw(
        spritesheet,
        self.x,
        self.y,
        0,
        scale * self.dir,
        scale,
        frame_width/2,
        frame_height/2
    )
end




local function getMovementDirection(input)
    if input == 'controle' then
        if not controle then return 0 end
        if controle:isGamepadDown('dpleft') then
            return -1
        elseif controle:isGamepadDown('dpright') then
            return 1
        end
        return controle:getGamepadAxis('leftx')
    end

    if input == 'teclado' then
        if love.keyboard.isDown('left') then
            return -1
        end
        if love.keyboard.isDown("right") then
            return 1
        end
        return 0
    end


    return 0
end

local function getMovementInput()
    local moveControle = getMovementDirection('controle')
    local moveTeclado = getMovementDirection('teclado')
    if math.abs(moveControle) > math.abs(moveTeclado) then
        return moveControle
    end
    return moveTeclado
end

function Player:move()
    self.x, self.y = self.collider:getPosition()
    local moveX = getMovementInput()
    local vx, vy = self.collider:getLinearVelocity()
    if math.abs(moveX) > 0.3 then
        if self.grounded and not walk_sound:isPlaying() then
            walk_sound:play()
        elseif not self.grounded then
            walk_sound:pause()
        end
        if moveX < 0 then self.dir = -1 else self.dir = 1 end
        if self.animation ~= animations.running then
            self.animation = animations.running
        end
        vx = moveX * self.speed
        self.collider:setLinearVelocity(vx, vy)
    else
        walk_sound:pause()
        self.collider:setLinearVelocity(0, vy)
        if self.animation ~= animations.idle then
            self.animation = animations.idle
        end
    end
end