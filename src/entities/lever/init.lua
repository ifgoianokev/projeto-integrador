Lever = Class()

local leverImage = love.graphics.newImage('src/entities/lever/Lever.png')




function Lever:setActivate(funcao)
    self.quandoAtivar = funcao
end

function Lever:activate()
    if self.isActive then return end
    self.isActive = true
    self.quandoAtivar()
end

function Lever:init(mundo, x, y, w, h, dir)
    self.scale = {}
    local img_w, img_h = leverImage:getDimensions()
    self.scale.x =  w / img_w
    self.scale.y = h / img_h
    self.w = w
    self.h = h
    self.x = x
    self.y = y
    self.dir = dir
    self.isActive = false


    self.collider = mundo:newRectangleCollider(
        x,
        y,
        w,
        h,
        {collision_class='lever'}
    )
    self.collider:setObject(self)
    self.collider:setType('static')
    self.collider:setFixedRotation(true)
end

function Lever:draw()
    local x = self.x
    if self.dir == -1 then
        x = x + self.w
    end
    love.graphics.draw(
        leverImage,
        x,
        self.y,
        0,
        self.scale.x * self.dir,
        self.scale.y
        -- self.w/2,
        -- self.h/2
    )
end