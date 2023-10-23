local paletImage = love.graphics.newImage('src/entities/palet/palet.png')

Palet = Class()

local scale = 1


function Palet:init(mundo, x, y, type)
    type = type or 'dynamic'
    self.w, self.h = paletImage:getDimensions()

    self.collider = mundo:newRectangleCollider(
        x,
        y,
        self.w*scale,
        self.h*scale,
        {collision_class='palet'}
    )
    self.collider:setType(type)
    self.collider:setFixedRotation(true)
    self.collider:setMass(15)
    self.collider:setRestitution(0.1)
    self.collider:setFriction(.6)
end

function Palet:draw()
    love.graphics.draw(
        paletImage,
        self.collider:getX(),
        self.collider:getY(),
        0,
        scale,
        scale,
        self.w/2,
        self.h/2
    )
end