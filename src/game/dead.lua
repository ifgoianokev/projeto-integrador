deadScreen = {}



function deadScreen:enter(level)
    screen = {
        opacity = 0
    }
    self.level = level
    level.game.vidas = level.game.vidas - 1
    if level.game.tempo <= 0 then
        level.game.vidas = 0
    end
    timer:tween(1, screen, {opacity = 1}, 'out-quart')
end


function deadScreen:draw()
    self.level:draw()
    love.graphics.setFont(fonts.big)
    love.graphics.setColor(0,0,0, screen.opacity)
    love.graphics.rectangle(
        "fill",
        0,
        0,
        SCREEN_WIDTH,
        SCREEN_HEIGHT
    )
    love.graphics.setColor(1,0,0, screen.opacity)


    if self.level.game.tempo > 0 then        
        love.graphics.printf(
            "Voce morreu",
            0,
            SCREEN_HEIGHT/2,
            SCREEN_WIDTH,
            "center"
        )
    else
        love.graphics.printf(
            "O tempo acabou",
            0,
            SCREEN_HEIGHT/2,
            SCREEN_WIDTH,
            "center"
        )
    end
    if self.level.game.vidas > 0 then
        love.graphics.printf(
            "\nJogue novamente",
            0,
            SCREEN_HEIGHT/2,
            SCREEN_WIDTH,
            "center"
        )
    else
        love.graphics.printf(
            "\nVolte ao menu",
            0,
            SCREEN_HEIGHT/2,
            SCREEN_WIDTH,
            "center"
        )
    end
end




function deadScreen:tryAgain()
    if self.level.game.vidas > 0 then
        Gamestate.pop()
        Gamestate.pop()
        Gamestate.push(self.level)
    else
        Gamestate.pop()
        Gamestate.pop()
        Gamestate.switch(menu)
    end
end

function deadScreen:keypressed(tecla)
    if tecla == 'space' or tecla == 'return' then
        self:tryAgain()
    end
end


function deadScreen:gamepadpressed(joystick, button)
    if button == 'start' or button == 'x' or button == 'a' then
        self:tryAgain()
    end
end