local Map = Class()


local function createColliders(layer, mundo, type, class)
    local collider
    local colliders = {}
    for index, collider_info in ipairs(layer.objects) do
        collider = mundo:newRectangleCollider(
            collider_info.x,
            collider_info.y,
            collider_info.width,
            collider_info.height,
            {collision_class=class}
        )
        collider:setType(type)
        collider:setFixedRotation(true)
        table.insert(colliders, collider)
    end
    return colliders
end



function Map:init(mundo)
    self.layout = sti('src/game/2/map/Mapa_2.lua')
    self.width = self.layout.width * self.layout.tilewidth
    self.height = self.layout.height * self.layout.tileheight
    createColliders(self.layout.layers['Obj Chão'], mundo, 'static', 'ground')
    createColliders(self.layout.layers['Obj Escadas'], mundo, 'static', 'ladder')


    self.platforms = {}
    for _, obj in ipairs(self.layout.layers['Plataformas'].objects) do
        local platform = Platform(mundo, obj.x, obj.y, obj.width, obj.height)
        table.insert(self.platforms, platform)
    end
    

    self.portas = {}
    for _, obj in ipairs(self.layout.layers['Portas'].objects) do
        local porta = Porta(mundo, obj.x, obj.y, obj.width, obj.height)
        table.insert(self.portas, porta)
    end

    self.acidos = {}
    for _, obj in ipairs(self.layout.layers['Ácidos'].objects) do
        local acido = Acido(mundo, obj.x, obj.y, obj.width, obj.height)
        table.insert(self.acidos, acido)
    end

    self.levers = {}
    for _, obj in ipairs(self.layout.layers['Alavancas'].objects) do
        local lever = Lever(mundo, obj.x, obj.y, obj.width, obj.height, obj.properties['dir'])
        lever:setActivate(function ()
            lever.scale.y = -lever.scale.y
            lever.y = lever.y + lever.h
            local ativa = obj.properties['ativa']
            if ativa == 'plataforma' then
                self.platforms[1]:open()
            elseif ativa == 'ventilador' then
            end
        end)
        table.insert(self.levers, lever)
    end
    self.boxes = {}
    for _, obj in ipairs(self.layout.layers['Caixas'].objects) do
        table.insert(self.boxes, Box(mundo, obj.x, obj.y))
    end
end

function Map:draw()
    self.layout:drawLayer(self.layout.layers['Background'])
    for index, porta in ipairs(self.portas) do
        porta:draw()
    end
    self.layout:drawLayer(self.layout.layers['Chão'])
    self.layout:drawLayer(self.layout.layers['Escadas'])
    for index, box in ipairs(self.boxes) do
        box:draw()
    end
    for index, lever in ipairs(self.levers) do
        lever:draw()
    end
    for index, acido in ipairs(self.acidos) do
        acido:draw()
    end

    for index, platform in ipairs(self.platforms) do
        platform:draw()
    end

end

function Map:update(dt)
    for index, acido in ipairs(self.acidos) do
        acido:update(dt)
    end
    for index, porta in ipairs(self.portas) do
        porta:update(dt)
    end
end

function Map:getPlayerCoords()
    local player = self.layout.layers['Jogador'].objects[1]
    return player.x, player.y
end


return Map