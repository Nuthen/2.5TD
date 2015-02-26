map = {}

local windowWidth, windowHeight = love.graphics.getDimensions()

tileTypes = require 'data/tileData'


local shadowImages = {}
shadowEastImage = love.graphics.newImage("img/Shadow East.png")
table.insert(shadowImages, shadowEastImage)
shadowNorthEastImage = love.graphics.newImage("img/Shadow North East.png")
table.insert(shadowImages, shadowNorthEastImage)
shadowNorthWestImage = love.graphics.newImage("img/Shadow North West.png")
table.insert(shadowImages, shadowNorthWestImage)
shadowNorthImage = love.graphics.newImage("img/Shadow North.png")
table.insert(shadowImages, shadowNorthImage)
shadowSideWestImage = love.graphics.newImage("img/Shadow Side West.png")
table.insert(shadowImages, shadowSideWestImage)
shadowSouthEastImage = love.graphics.newImage("img/Shadow South East.png")
table.insert(shadowImages, shadowSouthEastImage)
shadowSouthWestImage = love.graphics.newImage("img/Shadow South West.png")
table.insert(shadowImages, shadowSouthWestImage)
shadowSouthImage = love.graphics.newImage("img/Shadow South.png")
table.insert(shadowImages, shadowSouthImage)
shadowWestImage = love.graphics.newImage("img/Shadow West.png")
table.insert(shadowImages, shadowWestImage)

local tileImageWidth = 101
local tileImageHeight = 171

tileWidth = 101
tileHeight = 80

mapTable = {}
local drawTiles = {}

local heightDif = 120 - tileHeight
mapElevation = 5

mapOriginX = 0
mapOriginY = 0

local mapTileSize = {width = 0, height = 0}
mapSize = {width = 0, height = 0}

tileSelector = {value = 1, goal = 1}

function map:create(width, height, buildRadius)
	mapTileSize.width, mapTileSize.height = width, height
	mapSize.width, mapSize.height = width * tileWidth, height * tileHeight
	
	mapOriginX = windowWidth/2 - mapSize.width/2
	mapOriginY = windowHeight/2 - mapSize.height/2
	
	mapTable = {}
	for ix = 1, width do
		mapTable[ix] = {}
		for iy = 1, height do
			if ix >= width/2-buildRadius and ix <= width/2+buildRadius and iy >= height/2-buildRadius and iy <= height/2+buildRadius then
				mapTable[ix][iy] = {2, 3, 0, 0, 0, 2}
			else
				mapTable[ix][iy] = {0, 0, 0, 0, 0, 0}
			end
		end
	end
	
	local selectorX, selectorY, selectorElevation = selectorData.x, selectorData.y, selectorData.elevation
	--map:setTile(selectorX, selectorY, selectorElevation, 32)
	map:setDrawTiles()
end

function map:setTile(x, y, elevation, tileType)
	mapTable[x][y][elevation] = tileType
	map:setDrawTiles()
end

function map:getTileCoords(tileX, tileY, elevation)
	local heightChange = elevation * heightDif - heightDif
	local x = mapOriginX + tileX * tileWidth - tileWidth
	local y = mapOriginY + tileY * tileHeight - tileHeight - (heightChange)
	
	return x, y
end

function map:getTile(x, y, elevation)
	if mapTable[x] then
		if mapTable[x][y] then
			local tileType = mapTable[x][y][elevation]
			if tileType == nil then
				tileType = -1
			end
			return tileType
		else
			return -1
		end
	else
		return -1
	end
end

function map:getMaxElevation(tileX, tileY)
	for i = 1, #mapTable[tileX][tileY] do
		if mapTable[tileX][tileY][i] == 0 then
			return i-1
		end
	end
end

function map:getNodes(startX, startY)
	local startIndex = 0
	local nodes = {}
	for ix = 1, #mapTable do
		for iy = 1, #mapTable[ix] do
			local locationTypes = mapTable[ix][iy]
			for i = 1, #locationTypes do
				if i == #locationTypes or locationTypes[i]+1 == 0 then
					local tileType = locationTypes[i]
					local value = 1000
					if tileType ~= 0 then --and i == 2 then
						if ix == startX and iy == startY then
							value = 0
							startIndex = #nodes+1
						end
						table.insert(nodes, {x = ix, y = iy, tileType = tileType, elevation = i, value = value, visited = false, neighbors = {}, parent = 0, status = "none"})
					end
				end
			end
		end
	end
	
	for i = 1, #nodes do
		local x1, y1 = nodes[i].x, nodes[i].y
		local neighbors = {}
		for j = 1, #nodes do
			if j ~= i then
				local x2, y2 = nodes[j].x, nodes[j].y
				if x1 == x2 and y1 == y2+1 then
					if map:getTile(x2, y2+1, 2) ~= 0 then
						table.insert(neighbors, j)
					end
				elseif x1 == x2 and y1 == y2-1 then
					if map:getTile(x2, y2-1, 2) ~= 0 then
						table.insert(neighbors, j)
					end
				elseif x1 == x2+1 and y1 == y2 then
					if map:getTile(x2+1, y2, 2) ~= 0 then
						table.insert(neighbors, j)
					end
				elseif x1 == x2-1 and y1 == y2 then
					if map:getTile(x2-1, y2, 2) ~= 0 then
						table.insert(neighbors, j)
					end
				end
			end
		end
		nodes[i].neighbors = neighbors
	end
	
	return nodes, startIndex
end

function map:keypressed(key)
	local mouseX, mouseY = love.mouse.getPosition()
	mouseX, mouseY = mouseX-camera.x, mouseY-camera.y
	if mouseX >= mapOriginX and mouseX <= mapOriginX + mapSize.width and mouseY >= mapOriginY and mouseY <= mapOriginY + mapSize.height then
		local originDistX, originDistY = mouseX - mapOriginX, mouseY - mapOriginY
		local tileX, tileY = math.floor(originDistX/tileWidth)+1, math.floor(originDistY/tileHeight)+1
		
		local elevation = mapTable[tileX][tileY][mapElevation+1]
		
		---
		if tonumber(key) then
			if tonumber(key) == 0 then
				map:setTile(tileX, tileY, elevation, 10)
			else
				map:setTile(tileX, tileY, elevation, tonumber(key))
			end
		elseif key == "-" then
			if elevation > 1 then
				map:setTile(tileX, tileY, elevation, 0)
				mapTable[tileX][tileY][mapElevation+1] = elevation - 1
			end
		elseif key == "=" then
			if elevation < mapElevation then
				map:setTile(tileX, tileY, elevation+1, 2)
				mapTable[tileX][tileY][mapElevation+1] = elevation + 1
			end
		end
		---
	end
end

function map:mousepressed(mouseX, mouseY, button)
	if button == "l" or button == "r" then
		mouseX, mouseY = mouseX-camera.x, mouseY-camera.y
		if mouseX >= mapOriginX and mouseX <= mapOriginX + mapSize.width and mouseY >= mapOriginY and mouseY <= mapOriginY + mapSize.height then
			local originDistX, originDistY = mouseX - mapOriginX, mouseY - mapOriginY
			local tileX, tileY = math.floor(originDistX/tileWidth)+1, math.floor(originDistY/tileHeight)+1
				
			local elevation = mapTable[tileX][tileY][mapElevation+1]
				
			if elevationMode then
				
				--if tonumber(key) then
				--	map:setTile(tileX, tileY, elevation, tonumber(key))
				if button == "r" then
					if elevation >= 1 then
						map:setTile(tileX, tileY, elevation, 0)
						mapTable[tileX][tileY][mapElevation+1] = elevation - 1
					end
				elseif button == "l" then
					if elevation < mapElevation then
						local tileType = map:getTile(tileX, tileY, elevation)
						if tileType == 0 then
							tileType = 1
						end
						map:setTile(tileX, tileY, elevation+1, math.floor(tileSelector.value))
						mapTable[tileX][tileY][mapElevation+1] = elevation + 1
					end
				end
			else
				map:setTile(tileX, tileY, elevation, math.floor(tileSelector.value))
			end
		end
			
	elseif button == "wu" then
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

function map:setDrawTiles()
	drawTiles = {}
	for ix = 1, #mapTable do
		for iy = 1, #mapTable[ix] do
			local locationTypes = mapTable[ix][iy]
			for i = 1, #locationTypes-1 do
				if locationTypes[i] > 0 then
					local heightChange = i * heightDif - heightDif
					--local x = mapOriginX + ix * tileWidth - tileWidth
					--local y = mapOriginY + iy * tileHeight - tileHeight - (heightChange)
					local x, y = map:getTileCoords(ix, iy, i)
					
					local tileType = map:getTile(ix, iy, i)
					
					local translucent = false
					
					if ix == selectorData.x and iy == selectorData.y+1 and i >= selectorData.elevation then
						--translucent = true
					end
					
					--if x + tileImageWidth >= 0 and x <= windowWidth and y + tileImageHeight >= 0 and y <= windowHeight then
						local elevation = i
						local shadows = {}
						if tileType < 5 or tileType > 8 then
							if tileType ~= 13 then
								if tileType < 16 or tileType > 33 then
									if tileType < 35 or tileType > 37 then
									
										if elevation < mapElevation then
											if map:getTile(ix+1, iy, elevation+1) == 0 and map:getTile(ix+1, iy+1, elevation+1) ~= 0 then
												table.insert(shadows, 6)
											end
											if map:getTile(ix, iy+1, elevation+1) ~= 0 then
												table.insert(shadows, 8)
											end
											if map:getTile(ix-1, iy, elevation+1) == 0 and map:getTile(ix-1, iy+1, elevation+1) ~= 0 then
												table.insert(shadows, 7)
											end
											if map:getTile(ix+1, iy, elevation+1) ~= 0 then
												table.insert(shadows, 1)
											end
											if map:getTile(ix-1, iy, elevation+1) ~= 0 then
												table.insert(shadows, 9)
											end
											if map:getTile(ix, iy-1, elevation+1) == 0 and map:getTile(ix+1, iy-1, elevation+1) ~= 0 then
												table.insert(shadows, 2)
											end
											if map:getTile(ix, iy-1, elevation+1) ~= 0 then
												table.insert(shadows, 4)
											end
											if map:getTile(ix, iy-1, elevation+1) == 0 and map:getTile(ix-1, iy-1, elevation+1) ~= 0 and map:getTile(ix-1, iy, elevation+1) == 0 then
												table.insert(shadows, 3)
											end
											
											if map:getTile(ix, iy, elevation+1) ~= 0 and map:getTile(ix, iy, elevation+2) == 0 and map:getTile(ix, iy-1, elevation+1) == 0 then
												--table.insert(shadows, 10)
											end
										else
											if map:getTile(ix, iy-1, elevation) == 0 then
												--table.insert(shadows, 8)
											end
										end
										if map:getTile(ix-1, iy+1, elevation) ~= 0 then
											table.insert(shadows, 5)
										end
									end
								end
							end
						end
						
						table.insert(drawTiles, {x = x, y = y, tileType = locationTypes[i], shadows = shadows, translucent = translucent})
					--end
				end
			end
		end
	end
end

function map:draw()
	for i = 1, #drawTiles do
		local x, y, tileType = drawTiles[i].x, drawTiles[i].y, drawTiles[i].tileType
		local shadows = drawTiles[i].shadows
		local translucent = drawTiles[i].translucent
		
		if translucent then
			love.graphics.setColor(255, 255, 255, 150)
		end
		
		love.graphics.draw(tileTypes[tileType].image, x, y)
		--love.graphics.draw(characterImages[1], x, y)
		
		love.graphics.setColor(255, 255, 255, 255)
		
		for j = 1, #shadows do
			if shadows[j] == 10 then
				love.graphics.draw(shadowImages[8], x, y)
			else
				love.graphics.draw(shadowImages[shadows[j]], x, y)
			end
		end
	end
end

function map:save()
	local data = tostring(mapTileSize.width)..' '..tostring(mapTileSize.height)..' '..tostring(mapElevation) -- map dimensions
	for x = 1, mapTileSize.width do
		for y = 1, mapTileSize.height do
			for elevation = 1, mapElevation do
				local tile = mapTable[x][y][elevation]
				data = data .. " " .. tostring(tile)
			end
		end
	end
	
	local name = 'savelevel'
	local ok, message = pcall(love.filesystem.write, name..".txt", data)

    if not ok then
        error("could not save storage from disk: " .. message)
    end
end

return map