Player = Class{}



function Player:init(mundo)
    self.speed = 4
    self.x = 50
    self.y = 1350
    self.w = 69
    self.h = 102
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
    self.animation = animations.idle
end


function Player:update(dt)
    self:move()
    self.animation:update(dt)
    local colliders = mundo:queryRectangleArea(self.collider:getX()-self.w/2 + 10, self.collider:getY()+self.h/2, self.w - 20, 1, {'ground', 'box'})
    self.grounded = #colliders > 0
    if (not self.grounded) and controle:isGamepadDown('a') then
        self.collider:applyLinearImpulse(0, -self.impulso)
    end
end



function Player:draw()
    self.animation:draw(
        spritesheet,
        self.collider:getX(),
        self.collider:getY(),
        0,
        self.dir,
        1,
        frame_width/2,
        frame_height/2
    )
end








function Player:move()
    local moveX = 0
    local controleConectado = controle ~= nil
    if controleConectado then
        moveX = controle:getGamepadAxis('leftx')
    else
        if love.keyboard.isDown('left') then
            moveX = moveX - 1
        end
        if love.keyboard.isDown('right') then
            moveX = moveX + 1
        end
    end
    if math.abs(moveX) > 0.3 then
        if moveX < 0 then self.dir = -1 else self.dir = 1 end
        if self.animation ~= animations.running then
            self.animation = animations.running
        end
        -- self.x = self.x + moveX * self.speed
        local x = self.collider:getX()
        self.collider:setX(x + moveX * self.speed)
    else
        if self.animation ~= animations.idle then
            self.animation = animations.idle
        end
    end
end