Player = Class()

local scale = 5

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



function Player:init(mundo,x, y)
    self.touchingLadder = false
    self.grabbingLadder = false
    self.walk_sound = walk_sound
    self.mundo = mundo
    self.speedx = 600
    self.speedy = 200
    self.x = x
    self.y = y
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

function Player:isInAcid()
    local colliders = self.mundo:queryRectangleArea(
        self.collider:getX()-self.w/2,
        self.collider:getY()+self.h/2 - 70,
        self.w,
        15,
        {'acid'}
    )
    return #colliders > 0
end

function Player:update(dt)
    if self.grabbingLadder then
        self.speedx = 200
    else
        self.speedx = 600
    end
    self:move()
    self.animation:update(dt)
    self:updateGrounded()
    if self:isJumping() then
        self.collider:applyLinearImpulse(0, -self.impulso)
    end
    if self.collider:enter('ladder') then
        self.touchingLadder = true
    end
    if self.collider:exit('ladder') then
        self.touchingLadder = false
        self.grabbingLadder = false
        animations.idle:resume()
        animations.running:resume()
    end
end

function Player:updateGrounded()
    local colliders = self.mundo:queryRectangleArea(
        self.collider:getX()-self.w/2,
        self.collider:getY()+self.h/2,
        self.w,
        1,
        {'ground', 'box', 'platform', 'palet'}
    )
    self.grounded = #colliders > 0 or self.grabbingLadder
end

function Player:isJumping()
    return
        not
        self.grounded
        and
        (
            (
                controle
                and
                controle:isGamepadDown('x')
            )
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




local function getMovementDirectionX(input)
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

local function getMovementInputX()
    local moveControle = getMovementDirectionX('controle')
    local moveTeclado = getMovementDirectionX('teclado')
    if math.abs(moveControle) > math.abs(moveTeclado) then
        return moveControle
    end
    return moveTeclado
end



local function getMovementDirectionY(input)
    if input == 'controle' then
        if not controle then return 0 end
        if controle:isGamepadDown('dpup') then
            return -1
        elseif controle:isGamepadDown('dpdown') then
            return 1
        end
        return controle:getGamepadAxis('lefty')
    end

    if input == 'teclado' then
        if love.keyboard.isDown('up') then
            return -1
        end
        if love.keyboard.isDown("down") then
            return 1
        end
        return 0
    end


    return 0
end

local function getMovementInputY()
    local moveControle = getMovementDirectionY('controle')
    local moveTeclado = getMovementDirectionY('teclado')
    if math.abs(moveControle) > math.abs(moveTeclado) then
        return moveControle
    end
    return moveTeclado
end


function Player:move()
    self.x, self.y = self.collider:getPosition()
    local moveX = getMovementInputX()
    local moveY = getMovementInputY()
    local vx, vy = self.collider:getLinearVelocity()
    if self.grabbingLadder then
        vy = -34
    end
    vx = 0
    if math.abs(moveX) > 0.3 or math.abs(moveY) > 0.3 then
        if math.abs(moveX) > 0.3 then
            if self.grounded and not walk_sound:isPlaying() then
                walk_sound:play()
            elseif not self.grounded then
                walk_sound:pause()
            end
            if moveX < 0 then self.dir = -1 else self.dir = 1 end
            vx = moveX * self.speedx
            if self.animation ~= animations.running then
                self.animation = animations.running
            end
        end
        if math.abs(moveY) > 0.3 then
            if self.touchingLadder then
                self.grabbingLadder = true
                vy = moveY * self.speedy
                self.animation = animations.running
                self.animation:pause()
                self.animation:gotoFrame(2)
            end
        end

        self.collider:setLinearVelocity(vx, vy)
    else
        walk_sound:pause()
        self.collider:setLinearVelocity(0, vy)
        if self.animation ~= animations.idle then
            self.animation = animations.idle
        end
    end
end