Map = Class()
sti = require 'lib.sti'


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
        if class == 'box' then
            collider:setMass(7)
            collider:setRestitution(0.1)
        end
        table.insert(colliders, collider)
    end
    return colliders
end

boxImage = love.graphics.newImage('box.png')
box_width, box_height = boxImage:getDimensions()

function Map:init(mundo)
    self.layout = sti('map/design.lua')
    createColliders(self.layout.layers['ground_colliders'], mundo, 'static', 'ground')
    self.boxes = createColliders(self.layout.layers['box'], mundo, 'dynamic', 'box')
end

function Map:draw()
    self.layout:drawLayer(self.layout.layers['ground'])
    for index, box in ipairs(self.boxes) do
        love.graphics.draw(
            boxImage,
            box:getX(),
            box:getY(),
            0,
            1,
            1,
            box_width/2,
            box_height/2
        )
    end
end

