insertName = {}


local function isNumber(c)
    return (
        c == '1' or
        c == '2' or
        c == '3' or
        c == '4' or
        c == '5' or
        c == '6' or
        c == '7' or
        c == '8' or
        c == '9'
    )
end

local function isLetter(c)
    return (
        c == 'a' or
        c == 'b' or
        c == 'c' or
        c == 'd' or
        c == 'e' or
        c == 'f' or
        c == 'g' or
        c == 'h' or
        c == 'i' or
        c == 'j' or
        c == 'k' or
        c == 'l' or
        c == 'm' or
        c == 'n' or
        c == 'o' or
        c == 'p' or
        c == 'q' or
        c == 'r' or
        c == 's' or
        c == 't' or
        c == 'u' or
        c == 'v' or
        c == 'w' or
        c == 'x' or
        c == 'y' or
        c == 'z'
    )
    
end


function insertName:enter()
    nomeDoJogador = ""
end

local function isLetterOrNumber(c)
    return isLetter(c) or isNumber(c)
end
local font = fonts_google.big

-- function insertName:draw()
--     love.graphics.setFont(font)
--     love.graphics.printf("Insira seu nome", 0,0,SCREEN_WIDTH)
--     love.graphics.printf("\n\n" .. nomeDoJogador, 0,0,SCREEN_WIDTH)
    
--     local nomeWidth = font:getWidth(nomeDoJogador)
--     local nomeHeight = font:getHeight() * math.ceil(nomeWidth / SCREEN_WIDTH)
--     if nomeHeight == 0 then
--         nomeHeight = font:getHeight()
--     end
--     love.graphics.rectangle(
--         "fill",
--         nomeWidth % SCREEN_WIDTH,
--         font:getHeight() + nomeHeight,
--         font:getWidth(' ')/2,
--         font:getHeight()
--     )
-- end





--
-- InputField example program: Simple
--
-- require"setup"

local InputField = require "lib.input"
local LG         = love.graphics



local FONT_LINE_HEIGHT = 1.3

local FIELD_TYPE = "multiwrap" -- Possible values: normal, password, multiwrap, multinowrap

local FIELD_OUTER_X      = 50
local FIELD_OUTER_Y      = 150
local FIELD_OUTER_WIDTH  = SCREEN_WIDTH * .8
local FIELD_OUTER_HEIGHT = SCREEN_HEIGHT * .2
local FIELD_PADDING      = 6

local FIELD_INNER_X      = FIELD_OUTER_X + FIELD_PADDING
local FIELD_INNER_Y      = FIELD_OUTER_Y + FIELD_PADDING
local FIELD_INNER_WIDTH  = FIELD_OUTER_WIDTH  - 2*FIELD_PADDING
local FIELD_INNER_HEIGHT = FIELD_OUTER_HEIGHT - 2*FIELD_PADDING

local SCROLLBAR_WIDTH = 1
local BLINK_INTERVAL  = 0.90



love.keyboard.setKeyRepeat(true)

local theFont = font
theFont:setLineHeight(FONT_LINE_HEIGHT)

local field = InputField("", FIELD_TYPE)
field:setFont(theFont)
field:setDimensions(FIELD_INNER_WIDTH, FIELD_INNER_HEIGHT)








function insertName:keypressed(key, scancode, isRepeat)
    if key == 'return' then
		local texto = field:getText()
        if texto ~= "" then
			nomeDoJogador = texto
            Gamestate.switch(game)
        end
        return
    end
	if key == "escape" then
		Gamestate.switch(menu)
		return
	end
	field:keypressed(key, isRepeat)
end

function insertName:textinput(text)
	field:textinput(text)
end



function insertName:mousepressed(mx, my, mbutton, pressCount)
	field:mousepressed(mx-FIELD_INNER_X, my-FIELD_INNER_Y, mbutton, pressCount)
end

function insertName:mousemoved(mx, my, dx, dy)
	field:mousemoved(mx-FIELD_INNER_X, my-FIELD_INNER_Y)
end

function insertName:mousereleased(mx, my, mbutton, pressCount)
	field:mousereleased(mx-FIELD_INNER_X, my-FIELD_INNER_Y, mbutton)
end

function insertName:wheelmoved(dx, dy)
	field:wheelmoved(dx, dy)
end



function insertName:update(dt)
	field:update(dt)
end




function insertName:draw()

	LG.printf(
		'Insira seu nome',
		0,
		40,
		SCREEN_WIDTH,
		'center'
	)
	LG.setScissor(FIELD_OUTER_X, FIELD_OUTER_Y, FIELD_OUTER_WIDTH, FIELD_OUTER_HEIGHT)

	-- Background.
	LG.setColor(.2, .2, .2)
	LG.rectangle("fill", FIELD_OUTER_X, FIELD_OUTER_Y, FIELD_OUTER_WIDTH, FIELD_OUTER_HEIGHT)

	-- Selection.
	LG.setColor(.2, .2, 1)
	for _, selectionX, selectionY, selectionWidth, selectionHeight in field:eachSelection() do
		LG.rectangle("fill", FIELD_INNER_X+selectionX, FIELD_INNER_Y+selectionY, selectionWidth, selectionHeight)
	end

	-- Text.
	LG.setFont(theFont)
	LG.setColor(1, 1, 1)
	for _, lineText, lineX, lineY in field:eachVisibleLine() do
		LG.print(lineText, FIELD_INNER_X+lineX, FIELD_INNER_Y+lineY)
	end

	-- Cursor.
	local cursorWidth = 2
	local cursorX, cursorY, cursorHeight = field:getCursorLayout()
	local alpha = ((field:getBlinkPhase() / BLINK_INTERVAL) % 1 < .5) and 1 or 0
	LG.setColor(1, 1, 1, alpha)
	LG.rectangle("fill", FIELD_INNER_X+cursorX-cursorWidth/2, FIELD_INNER_Y+cursorY, cursorWidth, cursorHeight)

	LG.setScissor()

	--
	-- Scrollbars.
	--
	local horiOffset, horiCoverage, vertOffset, vertCoverage = field:getScrollHandles()

	local horiHandleLength = horiCoverage * FIELD_OUTER_WIDTH
	local vertHandleLength = vertCoverage * FIELD_OUTER_HEIGHT
	local horiHandlePos    = horiOffset   * FIELD_OUTER_WIDTH
	local vertHandlePos    = vertOffset   * FIELD_OUTER_HEIGHT

	-- Backgrounds.
	LG.setColor(0, 0, 0, .3)
	LG.rectangle("fill", FIELD_OUTER_X+FIELD_OUTER_WIDTH, FIELD_OUTER_Y,  SCROLLBAR_WIDTH, FIELD_OUTER_HEIGHT) -- Vertical scrollbar.
	LG.rectangle("fill", FIELD_OUTER_X, FIELD_OUTER_Y+FIELD_OUTER_HEIGHT, FIELD_OUTER_WIDTH, SCROLLBAR_WIDTH ) -- Horizontal scrollbar.

	-- Handles.
	LG.setColor(.7, .7, .7)
	LG.rectangle("fill", FIELD_OUTER_X+FIELD_OUTER_WIDTH, FIELD_OUTER_Y+vertHandlePos,  SCROLLBAR_WIDTH, vertHandleLength) -- Vertical scrollbar.
	LG.rectangle("fill", FIELD_OUTER_X+horiHandlePos, FIELD_OUTER_Y+FIELD_OUTER_HEIGHT, horiHandleLength, SCROLLBAR_WIDTH) -- Horizontal scrollbar.


end