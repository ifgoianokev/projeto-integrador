opening = {}

local look = {}

function opening:enter(level, animacao, lookX, lookY)
    walk_sound:stop()
    local x, y = camera:position()
    look = {
        x = x,
        y = y
    }
    self.level = level
    self.animacao = animacao
    self.canUpdate = false
    timer:tween(2, look, {x = lookX, y=lookY}, 'out-quad', function ()
        self.canUpdate = true
        animacao:resume()
        timer:after(1.7, function ()
            animacao:pauseAtEnd()
            timer:tween(1, look, {x = x, y = y}, 'out-quad', function ()
                Gamestate.pop()
            end)
        end)
    end)
end

function opening:draw()
    self.level:draw()
end



function opening:update(dt)
    camera:lookAt(look.x, look.y)
    if not self.canUpdate then return end
    self.animacao:update(dt)
end