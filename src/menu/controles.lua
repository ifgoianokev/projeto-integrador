controlesMenu = {}



function controlesMenu:enter()
    love.graphics.setFont(fonts.medium)
    love.graphics.setColor(1,1,1)
end

function controlesMenu:leave()
    love.graphics.setFont(fonts.big)
end

function controlesMenu:draw()
    love.graphics.print("Aqui vao os controles")
    love.graphics.print("\npressione b ou esc para voltar")
end


local function voltar()
    Gamestate.pop()
end

function controlesMenu:keypressed(tecla)
    if tecla == 'escape' then
        voltar()
    end
end


function controlesMenu:gamepadpressed(joystick, button)
    if button == 'b' then
        voltar()
    end
end