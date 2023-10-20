game = {}

require 'src.game.1'
require 'src.game.2'

local jump_sound = love.audio.newSource("src/static/audio/jump.mp3", 'static')
jump_sound:setVolume(.3)



function game:setPlayer(player)
    self.player = player
end

function game:enter()
    Gamestate.push(fase1)
end





function game:draw()
    --desenhar o hud
    local x,y = self.player.collider:getPosition()
    love.graphics.setFont(fonts.small)
    love.graphics.print(string.format("%f\n%f\n%f", x, y, 1/dt_atual))
end


local function jumpPressed(player)
    if not player.grounded then return end
    jump_sound:seek(.08, 'seconds')
    jump_sound:play()
    player.impulso = 200
    timer:after(0.2, function ()
        timer:tween(0.8, player, {impulso=0}, 'out-quart')
    end)
    player.collider:applyLinearImpulse(0, -3700)--1700
end


local function pausePressed()
    Gamestate.push(pauseMenu)
end


function game:gamepadpressed(joystick, button)
    if button == 'x' then jumpPressed(self.player) end
    if button == 'start' then pausePressed() end
end

function game:keypressed(tecla)
    if tecla == 'space' then jumpPressed(self.player) end
    if tecla == 'escape' then pausePressed() end
end



