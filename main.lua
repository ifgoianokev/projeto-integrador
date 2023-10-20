love.graphics.setDefaultFilter('nearest', "nearest")
Class = require 'lib.class'
Gamestate = require 'lib.gamestate'
windfield = require 'lib.windfield'
sti = require 'lib.sti'

cam = require 'lib.camera'
anim8 = require 'lib.anim8'
Timer = require 'lib.timer'

SCREEN_WIDTH, SCREEN_HEIGHT = love.window.getMode()


require 'src.game'
require 'src.game.pause'
require 'src.entities.player'
require 'src.entities.box'
require 'src.menu.menu'
require 'src.menu.controles'
require 'src.menu.scores'

fonts = {
    small = love.graphics.newFont('src/static/fonts/TiltNeon-Regular.ttf', SCREEN_WIDTH*0.01),
    medium = love.graphics.newFont('src/static/fonts/TiltNeon-Regular.ttf', SCREEN_WIDTH*0.03),
    big = love.graphics.newFont('src/static/fonts/TiltNeon-Regular.ttf', SCREEN_WIDTH*0.045),
}

function love.load()
    timer = Timer()
    camera = cam()
    Gamestate.registerEvents()
    Gamestate.switch(menu)
end


function love.update(dt)
    timer:update(dt)
end


function love.joystickadded(joystick)
    if joystick:isGamepad() then
        controle = joystick
    end
end

function love.joystickremoved(joystick)
    controle = nil
end

function love.gamepadpressed(joystick, button)
    print(button)
end


