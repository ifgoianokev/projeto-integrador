gameOver = {}

local gameOverImage = love.graphics.newImage('src/static/img/Game_Over_2.png')
local imgW, imgH = gameOverImage:getDimensions()
local scaleX = SCREEN_WIDTH / imgW
local scaleY = SCREEN_HEIGHT / imgH


local screen = {
    opacity = 0
}

function gameOver:enter()
    playSong(songs.gameOver)
    screen = {
        opacity = 0
    }
    timer:tween(3, screen, {opacity = 1}, 'out-cubic')
end

function gameOver:draw()
    love.graphics.setColor(screen.opacity,screen.opacity,screen.opacity, screen.opacity)
    love.graphics.draw(
        gameOverImage,
        0,
        0,
        0,
        scaleX,
        scaleY
    )
end


local function goToMenu()
    Gamestate.pop()
    Gamestate.pop()
    Gamestate.switch(menu)
end

function gameOver:keypressed(key)
    if
        key == 'space'
        or
        key == 'return'
    then
        goToMenu()
    end
end

function gameOver:gamepadpressed()
    goToMenu()
end