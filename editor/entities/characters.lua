character = {}

local windowWidth, windowHeight = love.graphics.getDimensions()

local characterImages = {}


local characterList = {}

function character:add(tileX, tileY)
	local elevation = 1 + map:getMaxElevation(tileX, tileY)
	
	local x, y = map:getTileCoords(tileX, tileY, elevation)
	table.insert(characterList, {tileX = tileX, tileY = tileY, elevation = elevation, x = x, y = y, characterType = 1, tweening = false})
	map:setTile(tileX, tileY, elevation, 41)
end


function character:update(dt)
	for i = 1, #characterList do
		--if math.random() > 0.75 then
			local dir = math.floor(math.random(1, 4))
			if dir == 1 then
				character:move(i, 1, 0)
			elseif dir == 2 then
				character:move(i, -1, 0)
			elseif dir == 3 then
				character:move(i, 0, 1)
			elseif dir == 4 then
				character:move(i, 0, -1)
			end
		--end
	end
	
	--[[
	local activeCharacter = 1
	local tileX, tileY = characterList[activeCharacter].tileX, characterList[activeCharacter].tileY
	local elevation = characterList[activeCharacter].elevation
	local x, y = characterList[activeCharacter].x, characterList[activeCharacter].y
	local characterType = characterList[activeCharacter].characterType
	local tweening = characterList[activeCharacter].tweening
	]]
	
	--camera.x, camera.y = windowWidth/2-x-50, windowHeight/2-y-200
end

function character:move(i, dx, dy)
	local activeCharacter = i
	local tileX, tileY = characterList[activeCharacter].tileX, characterList[activeCharacter].tileY
	local elevation = characterList[activeCharacter].elevation
	local x, y = characterList[activeCharacter].x, characterList[activeCharacter].y
	local characterType = characterList[activeCharacter].characterType
	local tweening = characterList[activeCharacter].tweening
	
	local clear, elevationModifier, elevationChange = character:moveTileCheck(tileX, tileY, dx, dy, elevation)
	if clear then
		local newX, newY = map:getTileCoords(tileX+dx, tileY+dy, elevation+elevationModifier)
		
		elevation = elevation + elevationChange
		--newX, newY = newX-43, newY-175
		--newY = newY - 50
		characterList[activeCharacter] = {tileX = tileX + dx, tileY = tileY + dy, elevation = elevation, x = newX, y = newY, characterType = 1, tweening = true}
		--tween.start(0.4, characterList[activeCharacter], {x = newX, y = newY}, 'inOutBack', character:tweenDone(activeCharacter))
		map:setTile(tileX, tileY, elevation, 22)
		map:setTile(tileX+dx, tileY+dy, elevation, 41)
	end
end

function character:keypressed(key)
	--[[
	local activeCharacter = 1
	local tileX, tileY = characterList[activeCharacter].tileX, characterList[activeCharacter].tileY
	local elevation = characterList[activeCharacter].elevation
	local x, y = characterList[activeCharacter].x, characterList[activeCharacter].y
	local characterType = characterList[activeCharacter].characterType
	local tweening = characterList[activeCharacter].tweening
	
	if not tweening then
		local dx, dy = 0, 0
		if key == "w" then
			dy = -1
		elseif key == "s" then
			dy = 1
		elseif key == "a" then
			dx = -1
		elseif key == "d" then
			dx = 1
		end
		
		if dx ~= 0 or dy ~= 0 then
			local clear, elevationModifier, elevationChange = character:moveTileCheck(tileX, tileY, dx, dy, elevation)
			if clear then
				local newX, newY = map:getTileCoords(tileX+dx, tileY+dy, elevation+elevationModifier)
				
				elevation = elevation + elevationChange
				--newX, newY = newX-43, newY-175
				newY = newY - 50
				characterList[activeCharacter] = {tileX = tileX + dx, tileY = tileY + dy, elevation = elevation, x = x, y = y, characterType = 1, tweening = true}
				tween.start(0.4, characterList[activeCharacter], {x = newX, y = newY}, 'inOutBack', character:tweenDone(activeCharacter))
			end
		end
	end
	]]
end

function character:mousepressed(mouseX, mouseY, button)
	mouseX, mouseY = mouseX-camera.x, mouseY-camera.y
	if mouseX >= mapOriginX and mouseX <= mapOriginX + mapSize.width and mouseY >= mapOriginY and mouseY <= mapOriginY + mapSize.height then
		local originDistX, originDistY = mouseX - mapOriginX, mouseY - mapOriginY
		local tileX, tileY = math.floor(originDistX/tileWidth)+1, math.floor(originDistY/tileHeight)+1
		
		local elevation = mapTable[tileX][tileY][mapElevation+1]
		character:findPath(characterList[1].tileX, characterList[1].tileY, tileX, tileY)
	end
end

function character:moveTileCheck(tileX, tileY, dx, dy, elevation)
	local tileType = map:getTile(tileX, tileY, elevation)
	local newTile = map:getTile(tileX+dx, tileY+dy, elevation)
	local newTileDown = map:getTile(tileX+dx, tileY+dy, elevation-1)
	local newTileUp = map:getTile(tileX+dx, tileY+dy, elevation+1)
	local newTileUp2 = map:getTile(tileX+dx, tileY+dy, elevation+2)
	
	local clear = true
	local elevationModifier = 0
	local elevationChange = 0
	
	if tileType >= 5 and tileType <= 8 then
		if newTile == 0 then
			if tileType == 5 then
				if dx ~= 1 or newTileDown == 0 or newTileDown == 9 then
					clear = false
				else
					elevationChange = -1
					elevationModifier = -1
				end
			elseif tileType == 6 then
				if dy ~= -1 or newTileDown == 0 or newTileDown == 9 then
					clear = false
				else
					elevationChange = -1
					elevationModifier = -1
				end
			elseif tileType == 7 then
				if dy ~= 1 or newTileDown == 0 or newTileDown == 9 then
					clear = false
				else
					elevationChange = -1
					elevationModifier = -1
				end
			elseif tileType == 8 then
				if dx ~= -1 or newTileDown == 0 or newTileDown == 9 then
					clear = false
				else
					elevationChange = -1
					elevationModifier = -1
				end
			end
		end
	elseif newTileUp >= 5 and newTileUp <= 8 then
		if newTileUp2 == 0 then
			if newTileUp == 5 then
				if dx ~= -1 then
					clear = false
				end
			elseif newTileUp == 6 then
				if dy ~= 1 then
					clear = false
				end
			elseif newTileUp == 7 then
				if dy ~= -1 then
					clear = false
				end
			elseif newTileUp == 8 then
				if dx ~= 1 then
					clear = false
				end
			end
		else
			clear = false
		end
	elseif newTile == 0 or newTileUp ~= 0 then
		clear = false
	elseif newTile == 9 then
		clear = false
	elseif newTile >= 5 and newTile <= 8 then
		if dx == 1 and newTile ~= 5 then
			clear = false
		elseif dx == -1 and newTile ~= 8 then
			clear = false
		elseif dy == -1 and newTile ~= 6 then
			clear = false
		elseif dy == 1 and newTile ~= 7 then
			clear = false
		end
	end
	
	if clear and newTile >= 5 and newTile <= 8 then
		elevationModifier = -0.5
	elseif clear and newTileUp >= 5 and newTileUp <= 8 then
		elevationModifier = 0.5
		elevationChange = 1
	end
	
	return clear, elevationModifier, elevationChange
end

function character:findPath(startX, startY, targetX, targetY)
	local nodes, startIndex = map:getNodes(startX, startY)
	
	local goalIndex = 0
	
	local openNodes = {}
	local closedNodes = {}
	
	table.insert(openNodes, startIndex)
	local distance = 0
	local pathNotFound = true
	local i = 0
	
	while pathNotFound and i < 1000 do
		
		local lowestValueIndex = 0
		local lowestValue = 1000
		
		for i = 1, #openNodes do
			local index = openNodes[i]
			local value = nodes[index].value
			if value < lowestValue then
				lowestValueIndex = index
				lowestValue = value
			end
		end
		
		local x, y = nodes[lowestValueIndex].x, nodes[lowestValueIndex].y
		if x == targetX and y == targetY then
			pathNotFound = false
			goalIndex = lowestValueIndex
		else
			table.remove(openNodes, lowestValueIndex)
			table.insert(closedNodes, lowestValueIndex)
			nodes[lowestValueIndex].status = "closed"
			
			for i = 1, #nodes[lowestValueIndex].neighbors do
				local neighborIndex = nodes[lowestValueIndex].neighbors[i]
				if nodes[neighborIndex].status == "closed" then
					if nodes[neighborIndex].value > nodes[lowestValueIndex].value + 1 then
						--table.insert(closedNodes, neighborIndex) --this needs to remove the node from closedNodes
						--nodes[neighborIndex].value = nodes[lowestValueIndex].value + 1
						--nodes[neighborIndex].parent = lowestValueIndex
					end
				elseif nodes[neighborIndex].status == "open" then
					if nodes[neighborIndex].value > nodes[lowestValueIndex].value + 1 then
						--nodes[neighborIndex].value = nodes[lowestValueIndex].value + 1
						--nodes[neighborIndex].parent = lowestValueIndex
					end
				else
					--table.insert(openNodes, neighborIndex)
					nodes[neighborIndex].parent = lowestValueIndex
					nodes[neighborIndex].value = nodes[lowestValueIndex].value + 1
					nodes[neighborIndex].status = "open"
				end
			end
		end
		if #openNodes == 0 then
			pathNotFound = false
			goalIndex = lowestValueIndex
		end
		--i = i + 1
	end
	if i < 1000 then
		local path = {}
		local goalNotReached = true
		local index = goalIndex
		while goalNotReached do
			local x, y = nodes[index].x, nodes[index].y
			local parent = nodes[index].parent
			
			table.insert(path, {x, y})
			if x == startX and y == startY then
				goalNotReached = false
			else
				index = parent
			end
		end
	end
end

function character:pathVisit(nodes, index, targetX, targetY, distance)
	
end

function character:heuristic(nodes, index, goalX, goalY)
	local x = nodes[index].x
	local y = nodes[index].y
	local dx = math.abs(x - goalX)
	local dy = math.abs(y - goalY)
	local D = 1
	return D * (dx + dy)
end

function character:tweenDone(characterIndex)
	characterList[characterIndex].tweening = false
end

function character:draw()
	
end

return character