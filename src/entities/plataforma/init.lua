Platform = Class()

require 'src.entities.plataforma.opening'


local spritesheet = love.graphics.newImage("src/entities/plataforma/Sprite_Cave_Trapdoor_Complete.png")
local sheet_width, sheet_height = spritesheet:getDimensions()
local frame_width, frame_height = sheet_width/6, sheet_height
local grid = anim8.newGrid(frame_width, frame_height, sheet_width, sheet_height)
local animacao = anim8.newAnimation(grid('1-6', 1), 0.3)



function Platform:init(mundo, x, y, w, h)
    self.x = x
    self.y = y
    self.w = w
    self.h = h
    animacao:gotoFrame(1)
    self.collider = mundo:newRectangleCollider(
        x,
        y,
        w,
        h,
        {collision_class='platform'}
    )
    self.collider:setType('static')
end



function Platform:open()
    Gamestate.push(opening, animacao, self.x, self.y)
    self.collider:destroy()
end


function Platform:draw()
    animacao:draw(
        spritesheet,
        self.x,
        self.y,
        0,
        2,
        2
    )
    animacao:draw(
        spritesheet,
        self.x + frame_width*4,
        self.y,
        0,
        -2,
        2
    )
end