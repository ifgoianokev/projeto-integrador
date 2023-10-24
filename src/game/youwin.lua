youWin = {}

local youWinImage = love.graphics.newImage('src/static/img/youWin.png')
local imgW, imgH = youWinImage:getDimensions()
local scaleX = SCREEN_WIDTH / imgW
local scaleY = SCREEN_HEIGHT / imgH

function youWin:enter(level)
    playSong(songs.youWin)
    table.insert(scores, {jogador = nomeDoJogador, score = level.game.tempo})
    saving.setScores(scores)
    screen = {
        opacity = 0
    }
    self.level = level
    level.game.player.walk_sound:stop()
    timer:tween(3, screen, {opacity = 1}, 'out-cubic')
end


function youWin:draw()
    love.graphics.setColor(screen.opacity,screen.opacity,screen.opacity, screen.opacity)
    love.graphics.draw(
        youWinImage,
        0,
        0,
        0,
        scaleX,
        scaleY
    )  
    -- self.level:draw()
    -- love.graphics.setFont(fonts.big)
    -- love.graphics.setColor(0,0,0, screen.opacity)
    -- love.graphics.rectangle(
    --     "fill",
    --     0,
    --     0,
    --     SCREEN_WIDTH,
    --     SCREEN_HEIGHT
    -- )
    -- love.graphics.setColor(0,1,0, screen.opacity)


    -- love.graphics.printf(
    --     "Parabens",
    --     0,
    --     SCREEN_HEIGHT/2,
    --     SCREEN_WIDTH,
    --     "center"
    -- )

    -- love.graphics.printf(
    --     "\nVoce venceu",
    --     0,
    --     SCREEN_HEIGHT/2,
    --     SCREEN_WIDTH,
    --     "center"
    -- )

end




function youWin:backToMenu()
    Gamestate.pop()
    Gamestate.pop()
    Gamestate.switch(menu)
end

function youWin:keypressed(tecla)
    if tecla == 'space' or tecla == 'return' then
        self:backToMenu()
    end
end


function youWin:gamepadpressed(joystick, button)
    if button == 'start' or button == 'x' or button == 'a' then
        self:backToMenu()
    end
end