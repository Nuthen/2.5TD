local textInputBox = {}

local textInputBoxes = {}

local activeTextInputBox = 0

function textInputBox:add(name, x, y, width, height, inputType, charLimit)
	local inputString = ""
	local active = false
	local textInputBox = {name, x, y, width, height, inputType, charLimit, inputString, active}
	
	table.insert(textInputBoxes, textInputBox)
	return textInputBoxes
end

function textInputBox:textinput(text)
	if activeTextInputBox ~= 0 then
		local inputType   = textInputBoxes[activeTextInputBox][6]
		local charLimit   = textInputBoxes[activeTextInputBox][7]
		local inputString = textInputBoxes[activeTextInputBox][8]
		
		if inputType == "num" then
			if tonumber(text) ~= nil and #inputString < charLimit then
				textInputBoxes[activeTextInputBox][8] = inputString .. text
			end
		elseif inputType == "text" then
			textInputBoxes[activeTextInputBox][8] = inputString .. text
		end
	end
	
	return textInputBoxes
end

function textInputBox:keypressed(key, isrepeat)
	local textBoxActive = false
	if activeTextInputBox ~= 0 then
		textBoxActive = true
		local inputType   = textInputBoxes[activeTextInputBox][6]
		local charLimit   = textInputBoxes[activeTextInputBox][7]
		local inputString = textInputBoxes[activeTextInputBox][8]
		
		if key == "backspace" then
			local stringLength = string.len(inputString)
			textInputBoxes[activeTextInputBox][8] = string.sub(inputString, 1, stringLength - 1)
		end
	end
	
	return textInputBoxes, textBoxActive
end

function textInputBox:mousepressed(xMouse, yMouse, button)
	if button == "l" then
		local activated = false
		
		for i = 1, #textInputBoxes do
			local x = textInputBoxes[i][2]
			local y = textInputBoxes[i][3]
			local width = textInputBoxes[i][4]
			local height = textInputBoxes[i][5]
			
			if xMouse >= x and xMouse <= x + width and yMouse >= y and yMouse <= y + height then
				if activeTextInputBox ~= i then
					if activeTextInputBox ~= 0 then
						textInputBoxes[activeTextInputBox][9] = false
					end
					activeTextInputBox = i
					activated = true
					textInputBoxes[i][9] = true
					break
				end
			end
		end
		if activated == false and activeTextInputBox ~= 0 then
			textInputBoxes[activeTextInputBox][9] = false
			activeTextInputBox = 0
		end
	end
end

function textInputBox:clear()
	textInputBoxes = {}
	activeTextInputBox = 0
end

return textInputBox