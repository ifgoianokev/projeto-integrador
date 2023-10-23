fase2 = {}

local Map = require 'src.game.2.map'


local timerPorta


local function setupMundo()
    local mundo = windfield.newWorld(0, 2000, false)
    mundo:addCollisionClass("player")
    mundo:addCollisionClass("box")
    mundo:addCollisionClass("palet")
    mundo:addCollisionClass("ground")
    mundo:addCollisionClass("lever", {ignores={'All'}})
    mundo:addCollisionClass("platform")
    mundo:addCollisionClass("acid", {ignores={'player', 'box', 'palet'}})
    mundo:addCollisionClass("ladder", {ignores={'player'}})
    mundo:addCollisionClass("key", {ignores={'player'}})
    mundo:addCollisionClass("door", {ignores={'ground'}})
    mundo:setQueryDebugDrawing(true)
    return mundo
end


function fase2:enter(game)
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


function fase2:draw()
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
function fase2:update(dt)
    self.game:update(dt)
    dt_atual = dt
    self.mundo:update(dt)
    self.player:update(dt)
    self.mapa:update(dt)
    if self.player:isInAcid() then
        Gamestate.push(deadScreen)
    end
    if self.player.collider:enter('key') then
        self.mapa.chaves[1].collider:destroy()
        self.mapa.chaves[1] = nil
    end
    local cx, cy = lookAt(self.player, self.mapa.width, self.mapa.height)
    camera:lookAt(cx, cy)
    if self.player.x > self.mapa.width - self.player.w/3 then
        Gamestate.push(youWin)
    end
end

function fase2:leave()
    self.mundo:destroy()
    self.player = nil
    self.mapa = nil
    love.graphics.setBackgroundColor(0,0,0)

    if timerPorta then
        timer:cancel(timerPorta)
    end

end


function fase2:interact()
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
        timerPorta = self.mapa.portas[1]:open()
    end
end


function fase2:keypressed(tecla)
    self.game:keypressed(tecla)
    if tecla == 'e' then
        self:interact()
    end
end

function fase2:gamepadpressed(joystick, button)
    self.game:gamepadpressed(joystick, button)
    if button == 'b' then
        self:interact()
    end
end