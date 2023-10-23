fase1 = {}

local Map = require 'src.game.1.map'


local collected_key = false

local timerPorta

local function setupMundo()
    local mundo = windfield.newWorld(0, 2000, false)
    mundo:addCollisionClass("player")
    mundo:addCollisionClass("box")
    mundo:addCollisionClass("palet")
    mundo:addCollisionClass("ground")
    mundo:addCollisionClass("lever", {ignores={'player'}})
    mundo:addCollisionClass("platform")
    mundo:addCollisionClass("acid", {ignores={'player', 'box', 'palet'}})
    mundo:addCollisionClass("ladder", {ignores={'player'}})
    mundo:addCollisionClass("key", {ignores={'player'}})
    mundo:addCollisionClass("door", {ignores={'ground'}})
    mundo:setQueryDebugDrawing(true)
    return mundo
end


function fase1:enter(game)
    collected_key = false
    timerPorta = nil
    love.graphics.setBackgroundColor(.2, .2, .2)
    self.game = game
    self.mundo = setupMundo()
    camera:zoomTo(1)
    self.mapa = Map(self.mundo)
    local x, y = self.mapa:getPlayerCoords()
    self.player = Player(self.mundo, x, y)
    game:setPlayer(self.player)
end


function fase1:draw()
    love.graphics.setColor(1,1,1)
    camera:attach()
    self.mapa:draw()
    self.player:draw()
    -- self.mundo:draw()
    camera:detach()

    --desenha a hud do game
    self.game:draw()
end

dt_atual = 1
function fase1:update(dt)
    self.game:update(dt)
    dt_atual = dt
    self.mundo:update(dt)
    self.player:update(dt)
    self.mapa:update(dt)
    if self.player:isInAcid() then
        Gamestate.push(deadScreen)
    end
    if self.player.collider:enter('key') then
        collected_key = true
        self.mapa.chaves[1].collider:destroy()
        self.mapa.chaves[1] = nil
    end
    local cx, cy = lookAt(self.player, self.mapa.width, self.mapa.height)
    camera:lookAt(cx, cy)
    if self.player.x > self.mapa.width - self.player.w/3 then
        Gamestate.pop()
        Gamestate.push(fase2)
    end
end

function fase1:leave()
    self.mundo:destroy()
    self.player = nil
    self.mapa = nil
    if timerPorta then
        timer:cancel(timerPorta)
    end
    love.graphics.setBackgroundColor(0,0,0)
end


function fase1:interact()
    local player = self.player
    local levers = self.mundo:queryRectangleArea(
        player.x - player.w/2,
        player.y - player.h/2,
        player.w,
        player.h,
        {'lever'}
    )
    if #levers > 0 then
        local lever = levers[1]:getObject()
        lever:activate()
    end
    if #self.mundo:queryRectangleArea(
        player.x + player.w/2,
        player.y - player.h/2,
        50,
        player.h,
        {'door'}
    ) > 0 then
        if collected_key then
            timerPorta = self.mapa.portas[1]:open()
        end
    end
end


function fase1:keypressed(tecla)
    self.game:keypressed(tecla)
    if tecla == 'e' then
        self:interact()
    end
end

function fase1:gamepadpressed(joystick, button)
    self.game:gamepadpressed(joystick, button)
    if button == 'b' then
        self:interact()
    end
end