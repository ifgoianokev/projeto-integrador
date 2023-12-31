local boxImage = love.graphics.newImage('src/entities/box/box.png')

Box = Class()

local scale = 3


function Box:init(mundo, x, y, type)
    type = type or 'dynamic'
    self.w, self.h = boxImage:getDimensions()

    self.collider = mundo:newRectangleCollider(
        x,
        y,
        self.w*scale,
        self.h*scale,
        {collision_class='box'}
    )
    self.collider:setType(type)
    self.collider:setFixedRotation(true)
    self.collider:setMass(50)
    self.collider:setRestitution(0.1)
    self.collider:setFriction(.6)
end

function Box:draw()
    love.graphics.draw(
        boxImage,
        self.collider:getX(),
        self.collider:getY(),
        0,
        scale,
        scale,
        self.w/2,
        self.h/2
    )
end