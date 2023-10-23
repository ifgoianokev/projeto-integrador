scoresMenu = {}


function scoresMenu:enter()
    table.sort(scores, function (a, b)
        return a.score > b.score
    end)
    love.graphics.setFont(fonts.medium)
    love.graphics.setColor(1,1,1)
end

function scoresMenu:leave()
    love.graphics.setFont(fonts.big)
end

function scoresMenu:draw()
    love.graphics.printf("NOME", 50, 50, SCREEN_WIDTH, 'left')
    love.graphics.printf("SCORE", 0, 50, SCREEN_WIDTH-50, 'right')
    for index, save in ipairs(scores) do
        love.graphics.printf(save.jogador, 50, 70 + fonts.big:getHeight()*index, SCREEN_WIDTH, 'left')
        love.graphics.printf(tostring(save.score), 0, 70 + fonts.big:getHeight()*index, SCREEN_WIDTH-50, 'right')
    end
    love.graphics.setColor(0,0,0)
    love.graphics.rectangle(
        "fill",
        0,
        SCREEN_HEIGHT - fonts.big:getHeight()*2,
        SCREEN_WIDTH,
        fonts.big:getHeight()*2
    )
    love.graphics.setColor(1,1,1)
    love.graphics.printf("Pressione b ou esc para voltar", 0, SCREEN_HEIGHT - fonts.big:getHeight(), SCREEN_WIDTH, 'left')
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