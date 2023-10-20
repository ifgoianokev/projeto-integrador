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
    self.layout = sti('src/game/1/map/design.lua')
    createColliders(self.layout.layers['ground_colliders'], mundo, 'static', 'ground')
    self.boxes = {}
    for _, obj in ipairs(self.layout.layers['box'].objects) do
        table.insert(self.boxes, Box(mundo, obj.x, obj.y))
    end
end

function Map:draw()
    self.layout:drawLayer(self.layout.layers['ground'])
    for index, box in ipairs(self.boxes) do
        box:draw()
    end
end


return Map