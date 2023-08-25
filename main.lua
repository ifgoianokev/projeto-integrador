Class = require 'lib/class'

require 'Player'



function love.load()
    player = Player()
end

function love.update()
    player:update()
end

function love.draw()
    player:draw()
end





function love.joystickadded(joystick)
    controle = joystick
end

function love.joystickremoved(joystick)
    controle = nil
end