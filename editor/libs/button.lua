local buttonDo = {}

local buttons = {}

function buttonDo:add(name, x, y, width, height)
	local button = {name, x, y, width, height}
	
	table.insert(buttons, button)
	return buttons
end

function buttonDo:mousereleased(xMouse, yMouse, button)
	local clicked = false
	local index = 0
	
	if button == "l" then
		for i = 1, #buttons do
			local x = buttons[i][2]
			local y = buttons[i][3]
			local width = buttons[i][4]
			local height = buttons[i][5]
			
			if xMouse >= x and xMouse <= x + width and yMouse >= y and yMouse <= y + height then
				clicked = true
				index = i
				break
			end
		end
	end
	if clicked then
		return clicked, index
	else
		return nil, nil
	end
end

function buttonDo:clear()
	buttons = {}
end

return buttonDo