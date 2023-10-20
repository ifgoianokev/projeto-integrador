menu = {}



local canChange
local selectedOption = 1
local options = {
    "PLAY",
    "CONTROLES",
    "SCORES"
}


function menu:enter()
    canChange = true
    selectedOption = 1
    love.graphics.setFont(fonts.big)
end


function menu:leave()
    love.graphics.setColor(1,1,1)
end

function menu:draw()
    local bl = ""
    for idx, option in ipairs(options) do
        if idx == selectedOption then
            love.graphics.setColor(1,0,0)
        else
            love.graphics.setColor(1,1,1)
        end
        love.graphics.printf(
            bl .. option,
            0,
            SCREEN_HEIGHT/2 - fonts.big:getHeight()* #options/2,
            SCREEN_WIDTH,
            "center"
        )
        bl = bl .. '\n'
    end
end

local function keepSelectedOptionIntoBounds()
    if selectedOption > #options then selectedOption = 1 end
    if selectedOption < 1 then selectedOption = #options end
end



function menu:update()
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

local function selectOption()
    if selectedOption == 1 then
        Gamestate.switch(game)
    elseif selectedOption == 2 then
        Gamestate.push(controlesMenu)
    elseif selectedOption == 3 then
        Gamestate.push(scoresMenu)
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

function menu:keypressed(tecla)
    if tecla == 'space' or tecla == 'return' then
        selectOption()
    elseif tecla == 'down' or tecla == 'up' then
        changeOption(tecla)
    end
end


function menu:gamepadpressed(joystick, botao)
    if botao == 'start' or botao == 'x' or botao == 'a' then
        selectOption()
    elseif botao == 'dpup' or botao == 'dpdown' then
        changeOption(botao)
    end
end