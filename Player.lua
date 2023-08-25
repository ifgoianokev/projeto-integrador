Player = Class{}



function Player:init()
    self.speed = 10
    self.x = 10
    self.y = 50
    self.w = 60
    self.h = 60
end


function Player:update()
    self:move()
end





function Player:draw()
    love.graphics.rectangle(
        'fill',
        self.x,
        self.y,
        self.w,
        self.h
    )
end








function Player:move()
    local moveX = 0
    local controleConectado = controle ~= nil
    if controleConectado then
        moveX = controle:getGamepadAxis('leftx')
    else
        if love.keyboard.isDown('left') then
            moveX = moveX - 1
        end
        if love.keyboard.isDown('right') then
            moveX = moveX + 1
        end
    end
    if math.abs(moveX) > 0.3 then
        self.x = self.x + moveX * self.speed
    end
end