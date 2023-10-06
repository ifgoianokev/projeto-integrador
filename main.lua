Class = require 'lib.class'
windfield = require 'lib.windfield'

cam = require 'lib.camera'
anim8 = require 'lib.anim8'
Timer = require 'lib.timer'

require 'Player'
require "map.Map"



buttons = {
    A = 1,
    B = 2,
    X = 3,
    Y = 4,
    LB = 5,
    RB = 6
}



function love.load()
    love.graphics.setDefaultFilter('nearest', "nearest")
    timer = Timer()
    setupAnimations()
    setupMundo()
    camera = cam()
    camera:zoom(1.2)
    mapa = Map(mundo)
    player = Player(mundo)
end

function love.update(dt)
    timer:update(dt)
    mundo:update(dt)
    player:update(dt)
    camera:lookAt(player.collider:getX(), player.collider:getY())
end

function love.draw()
    love.graphics.print(string.format("%f\n%f", player.collider:getX(), player.collider:getY()))
    camera:attach()
    mapa:draw()
    mundo:draw()
    player:draw()
    camera:detach()
end


function love.joystickpressed(joystick, button)
    if button == buttons.A and player.grounded then
        player.canAddJump = true
        player.impulso = 300
        timer:tween(1, player, {impulso=0}, 'out-quart')
        player.collider:applyLinearImpulse(0, -1200)
        
    end
end


function love.joystickadded(joystick)
    controle = joystick
end

function love.joystickremoved(joystick)
    controle = nil
end


function setupAnimations()
    spritesheet = love.graphics.newImage("spritesheet/sheetmaior.png")
    sheet_width, sheet_height = spritesheet:getDimensions()
    frame_width, frame_height = sheet_width/8, sheet_height/2
    grid = anim8.newGrid(frame_width, frame_height, sheet_width, sheet_height)
    animations = {
        idle = anim8.newAnimation(grid('1-8', 2), 0.1),
        running = anim8.newAnimation(grid('1-8', 1), 0.1)
    }
end

function setupMundo()
    mundo = windfield.newWorld(0, 800, false)
    mundo:addCollisionClass("player")
    mundo:addCollisionClass("box")
    mundo:addCollisionClass("ground")
    mundo:setQueryDebugDrawing(true)
end