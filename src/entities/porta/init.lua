Porta = Class()

local baseImg = love.graphics.newImage('src/entities/porta/porta1.png')
local doorImg = love.graphics.newImage('src/entities/porta/porta2.png')



function Porta:open()
    if self.openPressed then return end
    self.openPressed = true
    self.yspeed = -300
    self.collider:setType('dynamic')
    return timer:after(2, function ()
        self.collider:destroy()
        self.isOpen = true
    end)
end


function Porta:init(mundo, x, y, w, h)
    self.openPressed = false
    self.x = x
    self.y = y
    self.initialY = y
    self.w = w
    self.h = h
    self.yspeed = 0

    local baseW, baseH = baseImg:getDimensions()
    self.baseScale =  w / baseW

    local doorW, doorH = doorImg:getDimensions()
    self.doorScale = {}
    self.doorScale.x =  w / doorW
    self.doorScale.y = h / doorH


    self.collider = mundo:newRectangleCollider(
        x,
        y,
        w,
        h,
        {collision_class='door'}
    )
    self.collider:setType('static')
    self.collider:setFixedRotation(true)
end

function Porta:update(dt)
    if self.isOpen then
        return
    end
    self.y = self.collider:getY()
    -- self.collider:setY(self.y + self.yspeed)
    self.collider:setLinearVelocity(0, self.yspeed)
end


function Porta:draw()
    if not self.isOpen then
        local resizeDoor = .7
        
        love.graphics.draw(
            doorImg,
            self.x + self.w * ((1-resizeDoor)/2),
            self.y - self.h/2,
            0,
            self.doorScale.x * resizeDoor,
            self.doorScale.y
        )
    end

    love.graphics.draw(
        baseImg,
        self.x,
        self.initialY + self.h,
        0,
        self.baseScale,
        -self.baseScale
    )
    love.graphics.draw(
        baseImg,
        self.x,
        self.initialY,
        0,
        self.baseScale
    )
end