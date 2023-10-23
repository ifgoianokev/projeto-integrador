local spritesheet = love.graphics.newImage("src/entities/acido/acido.png")
local sheet_width, sheet_height = spritesheet:getDimensions()
local frame_width, frame_height = sheet_width/2, sheet_height
local grid = anim8.newGrid(frame_width, frame_height, sheet_width, sheet_height)
local animacao = anim8.newAnimation(grid('1-2', 1), 1.4)


Acido = Class()


function Acido:init(mundo, x, y, w, h)
    self.scale = {}
    self.scale.x =  w / frame_width
    self.scale.y = h / frame_height
    self.w = w
    self.h = h
    self.x = x
    self.y = y


    self.collider = mundo:newRectangleCollider(
        x,
        y,
        w,
        h,
        {collision_class='acid'}
    )
    self.collider:setType('static')
    self.collider:setFixedRotation(true)
end



function Acido:update(dt)
    animacao:update(dt)
end

function Acido:draw()
    animacao:draw(
        spritesheet,
        self.x,
        self.y,
        0,
        self.scale.x,
        self.scale.y
    )
end