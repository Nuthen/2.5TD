selector = {}

selectorData = {x = 25, y = 25, elevation = 3}

function selector:keypressed(key, isrepeat)
	local x, y, elevation = selectorData.x, selectorData.y, selectorData.elevation
	if key == "w" then
		selector:move(x, y-1)
	elseif key == "s" then
		selector:move(x, y+1)
	elseif key == "d" then
		selector:move(x+1, y)
	elseif key == "a" then
		selector:move(x-1, y)
	end
	
	
	local tileX, tileY, elevation = selectorData.x, selectorData.y, selectorData.elevation
	if key == " " then
			
		if map:getMaxElevation(tileX, tileY) < mapElevation - 1 then
			selectorData = {x = tileX, y = tileY, elevation = elevation+1}
			map:setTile(tileX, tileY, elevation, tileSelector.goal)
			mapTable[tileX][tileY][mapElevation+1] = elevation + 1
			map:setTile(tileX, tileY, elevation+1, 32)
		end
		
		--else
			--map:setTile(tileX, tileY, elevation, math.floor(tileSelector.value))
		--end
	elseif key == "rctrl" then
		local elevation = map:getMaxElevation(tileX, tileY)
		if elevation >= 2 then
			selectorData = {x = tileX, y = tileY, elevation = elevation-1}
			map:setTile(tileX, tileY, elevation, 0)
			map:setTile(tileX, tileY, elevation-1, 32)
			mapTable[tileX][tileY][mapElevation+1] = mapTable[tileX][tileY][mapElevation+1] - 1
		end
	end
	
	if key == "-" then
		if tileSelector.value >= 2 then
			tileSelector.goal = tileSelector.goal - 1
			tween.start(0.2, tileSelector, {value = tileSelector.goal}, 'inOutCirc')
		end
	elseif key == "=" then
		if tileSelector.value <= #tileTypes-1 then
			tileSelector.goal = tileSelector.goal + 1
			tween.start(0.2, tileSelector, {value = tileSelector.goal}, 'inOutCirc')
		end
	end
end

function selector:move(newX, newY, elevationChange)
	if elevationChange == nil then elevationChange = 0 end
	
	local newElevation = 1 + map:getMaxElevation(newX, newY) + elevationChange
	
	local x, y, elevation = selectorData.x, selectorData.y, selectorData.elevation
	
	selectorData = {x = newX, y = newY, elevation = newElevation}
	
	map:setTile(x, y, elevation, 0)
	
	map:setTile(newX, newY, newElevation, 32)
	
end

function selector:mousepressed(mouseX, mouseY, button)
	if button == "wu" then
		if tileSelector.value >= 2 then
			tileSelector.goal = tileSelector.goal - 1
			tween.start(0.2, tileSelector, {value = tileSelector.goal}, 'inOutCirc')
		end
	elseif button == "wd" then
		if tileSelector.value <= #tileTypes-1 then
			tileSelector.goal = tileSelector.goal + 1
			tween.start(0.2, tileSelector, {value = tileSelector.goal}, 'inOutCirc')
		end
	end
end

return selector