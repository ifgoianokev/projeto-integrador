pauseMenu = {}

local canChange
local selectedOption = 1
local options = {
    "CONTINUAR",
    "MENU PRINCIPAL"
}

function pauseMenu:enter(level)
    canChange = true
    selectedOption = 1
    self.level = level
end

local menuWidth = SCREEN_WIDTH/3
local menuHeight = SCREEN_HEIGHT/3
local xstart = SCREEN_WIDTH/2 - menuWidth/2
local ystart = SCREEN_HEIGHT/2 - menuHeight/2

function pauseMenu:draw()
    self.level:draw()
    love.graphics.setFont(fonts.medium)
    love.graphics.setColor(0,0,0, .7)
    love.graphics.rectangle(
        "fill",
        xstart,
        ystart,
        menuWidth,
        menuHeight
    )
    love.graphics.setColor(1,1,1)
    local bl = ""
    for idx, option in ipairs(options) do
        if idx == selectedOption then
            love.graphics.setColor(1,0,0)
        else
            love.graphics.setColor(1,1,1)
        end
        love.graphics.printf(
            bl .. option,
            xstart,
            SCREEN_HEIGHT/2 - fonts.medium:getHeight()* #options/2,
            menuWidth,
            "center"
        )
        bl = bl .. '\n'
    end
end


local function keepSelectedOptionIntoBounds()
    if selectedOption > #options then selectedOption = 1 end
    if selectedOption < 1 then selectedOption = #options end
end



function pauseMenu:update()
    if not canChange then return end
    if not controle then return end
    local leftAxisY = controle:getGamepadAxis("lefty")
    if math.abs(leftAxisY) > 0.3 then
        if leftAxisY < 0 then
            selectedOption = selectedOption - 1
        else
            selectedOption = selectedOption + 1
        end
        canChange = false
        timer:after(.2, function ()
            canChange = true
        end)
        keepSelectedOptionIntoBounds()
    end
end

local function voltar()
    Gamestate.pop()
end


local function selectOption()
    if selectedOption == 1 then
        voltar()
    elseif selectedOption == 2 then
        Gamestate.pop()
        Gamestate.pop()
        Gamestate.switch(menu)
    end
end

local function changeOption(button)
    if string.find(button, 'up') then
        selectedOption = selectedOption - 1
    elseif string.find(button, 'down') then
        selectedOption = selectedOption + 1
    end
    keepSelectedOptionIntoBounds()
end




function pauseMenu:keypressed(tecla)
    if tecla == 'escape' then
        voltar()
    elseif tecla == 'space' or tecla == 'return' then
        selectOption()
    elseif tecla == 'down' or tecla == 'up' then
        changeOption(tecla)
    end
end


function pauseMenu:gamepadpressed(joystick, button)
    if button == 'b' then
        voltar()
    elseif button == 'start' or button == 'x' or button == 'a' then
        selectOption()
    elseif button == 'dpup' or button == 'dpdown' then
        changeOption(button)
    end
end