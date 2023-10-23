Chave = Class()


local spritesheet = love.graphics.newImage("src/entities/chave/chave.png")
local sheet_width, sheet_height = spritesheet:getDimensions()
local frame_width, frame_height = sheet_width/12, sheet_height
local grid = anim8.newGrid(frame_width, frame_height, sheet_width, sheet_height)
local animacao = anim8.newAnimation(grid('1-12', 1), 0.2)
local scale = 0.5




function Chave:init(mundo, x, y)
    self.x = x
    self.y = y


    self.collider = mundo:newRectangleCollider(
        x,
        y,
        frame_width * scale,
        frame_height * scale,
        {collision_class='key'}
    )
    self.collider:setType('static')
    self.collider:setFixedRotation(true)
end



function Chave:update(dt)
    animacao:update(dt)
end

function Chave:draw()
    animacao:draw(
        spritesheet,
        self.x,
        self.y,
        0,
        scale
    )
end