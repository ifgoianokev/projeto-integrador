love.graphics.setDefaultFilter('nearest', "nearest")
Class = require 'lib.class'
Gamestate = require 'lib.gamestate'
windfield = require 'lib.windfield'
sti = require 'lib.sti'

cam = require 'lib.camera'
anim8 = require 'lib.anim8'
Timer = require 'lib.timer'
bitser = require 'lib.bitser'

SCREEN_WIDTH, SCREEN_HEIGHT = love.window.getMode()


require 'src.game'
require 'src.game.pause'
require 'src.game.dead'
require 'src.game.youwin'

require 'src.entities.player'
require 'src.entities.box'
require 'src.entities.lever'
require 'src.entities.acido'
require 'src.entities.chave'
require 'src.entities.porta'
require 'src.entities.palet'
require 'src.entities.plataforma'

require 'saving'

local FONT_PATH = "src/static/fonts/radiospacebitmap.ttf"
local OLD_FONT_PATH = 'src/static/fonts/TiltNeon-Regular.ttf'


fonts = {
    small = love.graphics.newFont(FONT_PATH, SCREEN_WIDTH*0.01),
    medium = love.graphics.newFont(FONT_PATH, SCREEN_WIDTH*0.03),
    big = love.graphics.newFont(FONT_PATH, SCREEN_WIDTH*0.045),
}

fonts_google = {
    small = love.graphics.newFont(OLD_FONT_PATH, SCREEN_WIDTH*0.01),
    medium = love.graphics.newFont(OLD_FONT_PATH, SCREEN_WIDTH*0.03),
    big = love.graphics.newFont(OLD_FONT_PATH, SCREEN_WIDTH*0.045),
}

require 'src.menu.menu'
require 'src.menu.controles'
require 'src.menu.scores'
require 'src.menu.insert_name'

function love.load()
    scores = saving.getScores()

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
    -- print(button)
end



function lookAt(player, map_width, map_height)
    local x, y
    local halfHeight = (SCREEN_HEIGHT/2)/camera.scale
    local halfWidth = (SCREEN_WIDTH/2)/camera.scale
    x = player.x
    y = player.y
    if x - halfWidth < 0 then
        x = halfWidth
    end
    if x + halfWidth > map_width then
        x = map_width - halfWidth
    end
    if y - halfHeight < 0 then
        y =  halfHeight
    end
    if y + halfHeight > map_height then
        y = map_height -  halfHeight
    end
    return x, y
end
