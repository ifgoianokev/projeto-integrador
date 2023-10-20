scoresMenu = {}



function scoresMenu:enter()
    love.graphics.setFont(fonts.medium)
    love.graphics.setColor(1,1,1)
end

function scoresMenu:leave()
    love.graphics.setFont(fonts.big)
end

function scoresMenu:draw()
    love.graphics.print("Aqui vao os scores")
    love.graphics.print("\npressione b ou esc para voltar")
end


local function voltar()
    Gamestate.pop()
end

function scoresMenu:keypressed(tecla)
    if tecla == 'escape' then
        voltar()
    end
end


function scoresMenu:gamepadpressed(joystick, button)
    if button == 'b' then
        voltar()
    end
end