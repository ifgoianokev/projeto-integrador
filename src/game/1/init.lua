fase1 = {}

Map = require 'src.game.1.map'

local function setupMundo()
    local mundo = windfield.newWorld(0, 2000, false)
    mundo:addCollisionClass("player")
    mundo:addCollisionClass("box")
    mundo:addCollisionClass("ground")
    mundo:setQueryDebugDrawing(true)
    return mundo
end


function fase1:enter(game)
    love.graphics.setBackgroundColor(.2, .2, .2)
    self.game = game
    self.mundo = setupMundo()
    camera:zoomTo(1 + (SCREEN_WIDTH - 800)*0.0005)
    self.mapa = Map(self.mundo)
    self.player = Player(self.mundo)
    game:setPlayer(self.player)
end


function fase1:draw()
    love.graphics.setColor(1,1,1)
    camera:attach()
    self.mapa:draw()
    -- self.mundo:draw()
    self.player:draw()
    camera:detach()

    --desenha a hud do game
    self.game:draw()
end

dt_atual = 1
function fase1:update(dt)
    dt_atual = dt
    self.mundo:update(dt)
    self.player:update(dt)
    local px, py = self.player.collider:getPosition()
    camera:lookAt(px, py)
end

function fase1:leave()
    self.mundo:destroy()
    self.player = nil
    self.mapa = nil
    love.graphics.setBackgroundColor(0,0,0)
end


function fase1:keypressed(tecla)
    self.game:keypressed(tecla)
end

function fase1:gamepadpressed(joystick, button)
    self.game:gamepadpressed(joystick, button)
end