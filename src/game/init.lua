game = {}

require 'src.game.2'
require 'src.game.1'

local jump_sound = love.audio.newSource("src/static/audio/jump.mp3", 'static')
jump_sound:setVolume(.8)
local heart_img = love.graphics.newImage("src/static/img/coracao.png")
local heart_w, heart_h = heart_img:getDimensions()
local heart_scale = .3

game_timer = Timer()

local timer_total = 300


function game:setPlayer(player)
    self.player = player
    self.tempo = timer_total
end

local tempo

local function tick()
    tempo = tempo - 1
end


function game:enter()
    playSong(songs.inGame)


    Gamestate.push(fase1)
    self.vidas = 3
    tempo = timer_total
    self.handle = game_timer:every(1, tick)
end

function game:leave()
    game_timer:cancel(self.handle)
end


function game:update(dt)
    game_timer:update(dt)
    self.tempo = tempo
    if self.tempo <= 0 then
        Gamestate.push(deadScreen)
    end
end


function game:draw()
    --desenhar o hud
    love.graphics.setFont(fonts.big)
    love.graphics.printf(
        string.format("%d", tempo),
        0,
        30,
        SCREEN_WIDTH-30,
        'right'
    )
    for i = 0, self.vidas -1, 1 do
        love.graphics.draw(
            heart_img,
            30+ i* (heart_w*heart_scale + 5),
            30,
            0,
            heart_scale
        )
    end
end


local function jumpPressed(player)
    if not player.grounded then return end
    player.grabbingLadder = false
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



