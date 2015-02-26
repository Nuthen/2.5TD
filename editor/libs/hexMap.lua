local hexMap = {}

local tile1Color = {21, 164, 114}
local tile2Color = {251, 185, 32}
local tile3Color = {201, 26, 125}

local bridgeColor = {128, 0, 0}

local wall1Color = {90, 90, 90}
local wall2Color = {125, 125, 125}
local wall3Color = {200, 200, 200}

local mouseTileColor = {74, 96, 215}
local playerTileColor = {0, 0, 102}

--[[ Tile types:
	-1: Tile outside of the map (not really a tile)
	0: Invisible tile
	1: Tile at an elevation of 1
	2: Tile at an elevation of 2
	3: Tile at an elevation of 3
]]

local hexGrid = {}

--[[ These values will default if the variable is not defined 
     when buildMap() is called or if the variable is set to "default"
	 
  Variables-
   hexSize: Pixel length between a hexagon's center and its vertices
   hexMapRadius: Total radius of the hex grid
   hexMapBuildRadius: Radius of hex tiles filled in when the map is generated
   hexMapCenter: Where the center of the hexMap is on the screen (defaults to center of the screen)
   hexMapHeightDif: Height difference in pixels between different tile elevations
]]

local hexDefaults = {hexSize = 30, hexMapRadius = 10, hexMapBuildRadius = 5, hexMapCenter = {love.window.getWidth()/2, love.window.getHeight()/2}, hexMapHeightDif = 30, bordersEnabled = false}
hexVariables = hexDefaults

-- Width/heigh of a single hexagon
local hexWidth     = hexVariables.hexSize * 2
local hexHeight    = math.sqrt(3)/2 * hexWidth

-- Horizontal/Vertical differences between the centers of hexagons on the grid
local hexHorizDist = .75 * hexWidth
local hexVertDist  = hexHeight

-- Drawn tiles / borders / walls stored in here
local hexDrawTable = {tiles = {}, borders = {}, walls = {}}
local hexDrawTableExcess = {walls = {}}

function hexMap:buildMap(hexMapRadius, hexMapBuildRadius, hexSize, hexMapCenter, hexMapHeightDif)
	-- Variables will default if not set or set as "default"
	if hexMapRadius ~= nil and hexMapRadius ~= "default" then
		hexVariables.hexMapRadius = hexMapRadius
	end
	
	if hexMapBuildRadius ~= nil and hexMapBuildRadius ~= "default" then
		hexVariables.hexMapBuildRadius = hexMapBuildRadius
	end
	
	if hexSize ~= nil and hexSize ~= "default" then
		hexVariables.hexSize = hexSize
	end
	
	if hexMapCenter ~= nil and hexMapCenter ~= "default" then
		hexVariables.hexMapCenter = hexMapCenter
	end
	
	if hexMapHeightDif ~= nil and hexMapHeightDif ~= "default" then
		hexVariables.hexMapHeightDif = hexMapHeightDif
	end
	
	local hexMapRadius      = hexVariables.hexMapRadius
	local hexMapBuildRadius = hexVariables.hexMapBuildRadius
	local hexSize           = hexVariables.hexSize
	local hexMapCenter      = hexVariables.hexMapCenter
	local hexMapHeightDif   = hexVariables.hexMapHeightDif
	
	
	local hexHeight = gameGlobals.hexHeight

	
	for ix = 1, hexMapRadius * 2 + 1 do
		hexGrid[ix] = {}
		for iy = 1, hexMapRadius * 2 + 1 do
			-- Converts array x/y values into their tile values
			local xTile = ix - hexMapRadius - 1
			local yTile = iy - hexMapRadius - 1
			local hexType = -1
			
			--Tiles outside the build radius set as 0; tiles inside the build radius set as 1
			if xTile + yTile < -hexMapBuildRadius or xTile + yTile > hexMapBuildRadius then
				hexType = 0
			elseif xTile < -hexMapBuildRadius or xTile > hexMapBuildRadius or yTile < -hexMapBuildRadius or yTile > hexMapBuildRadius then
				hexType = 0
			else
				--hexType = 1
				hexType = math.floor(math.random(1, 3))
			end
			
			-- On-screen position of the hex
			local x = hexMapCenter[1] + hexSize * 3/2 * yTile
			local y = hexMapCenter[2] + hexSize * math.sqrt(3) * (xTile + yTile/2)
			
			if hexType > 1 then
				y = y - hexHeight * hexType + hexHeight
			end
			
			local hexVertices = {}
			
			-- On-screen position of each hex vertex
			for i = 1, 6 do
				local angle = 2 * math.pi / 6 * i
				local xPoint = x + hexSize * math.cos(angle)
				local yPoint = y + hexSize * math.sin(angle)
				
				table.insert(hexVertices, xPoint)
				table.insert(hexVertices, yPoint)
			end
			
			-- Stores position of each of the hex's neighbors
			local hexNeighbors = {{xTile+1, yTile}, {xTile+1, yTile-1}, {xTile, yTile-1}, {xTile-1, yTile}, {xTile-1, yTile+1}, {xTile, yTile+1}}
			
			-- Table for more hex data
			local hexData = {xTrue = x, yTrue = y, hexVerticesTrue = hexVertices, walls = {}, dataType = 0}
			
			-- Stores which sides of the hex need a border
			local hexBorders = {0, 0, 0, 0, 0, 0}
			
			-- Stores the hex in the hex grid
			hexGrid[ix][iy] = {hexType, xTile, yTile, x, y, hexVertices, hexNeighbors, hexBorders, hexData}
		end
	end
	
	hexMap:setDrawTiles()
end

function hexMap:setGrid(hexGridReplace)
	hexGrid = hexGridReplace
	hexMap:setDrawTiles()
end

function hexMap:getMap()
	return hexGrid
end

function hexMap:getTileType(x, y)
	local hexMapRadius = hexVariables.hexMapRadius
	
	-- Returns -1 for a tile outside of the map
	if x < -hexMapRadius or x > hexMapRadius or y < -hexMapRadius or y > hexMapRadius then
		return -1
	else
		local hexArray = hexGrid[x+hexMapRadius+1][y+hexMapRadius+1]
		local hexType  = hexArray[1]
		return hexType
	end
end

function hexMap:setTileType(x, y, tileType)
	local hexMapRadius = hexVariables.hexMapRadius
	
	-- Returns false if attempting to change a tile outside of the map
	-- Returns true if successful
	if x < -hexMapRadius or x > hexMapRadius or y < -hexMapRadius or y > hexMapRadius then
		return false
	else
		hexGrid[x+hexMapRadius+1][y+hexMapRadius+1][1] = tileType
		
		hexMap:setDrawTiles()
		return true
	end
end

function hexMap:getTileDataType(x, y)
	local hexMapRadius = hexVariables.hexMapRadius
	
	-- Returns -1 for a tile outside of the map
	if x < -hexMapRadius or x > hexMapRadius or y < -hexMapRadius or y > hexMapRadius then
		return -1
	else
		local hexArray = hexGrid[x+hexMapRadius+1][y+hexMapRadius+1]
		local hexData  = hexArray[9]
		local dataType = hexData.dataType
		return dataType
	end
end

function hexMap:setTileDataType(x, y, dataType)
	local hexMapRadius = hexVariables.hexMapRadius
	
	-- Returns false if attempting to change a tile outside of the map
	-- Returns true if successful
	if x < -hexMapRadius or x > hexMapRadius or y < -hexMapRadius or y > hexMapRadius then
		return false
	else
		hexGrid[x+hexMapRadius+1][y+hexMapRadius+1][9].dataType = dataType
		
		hexMap:setDrawTiles()
		return true
	end
end

function hexMap:setDrawTiles()
	-- Iterates through the grid, saves the array locations of hex's and borders to draw
	local tilesLocTable = {{},{},{}}
	
	local bordersLocTable = {{}, {}, {}}
	
	for ix = 1, #hexGrid do
		for iy = 1, #hexGrid[ix] do
			local hexArray     = hexGrid[ix][iy]
			local hexType      = hexArray[1]
			local xTile        = hexArray[2]
			local yTile        = hexArray[3]
			local x            = hexArray[4]
			local y            = hexArray[5]
			local hexVertices  = hexArray[6]
			local hexNeighbors = hexArray[7]
			local hexBorders   = hexArray[8]
			local hexData      = hexArray[9]
			
			local border = false
			
			if hexType > 0 then
		-- Sets hexes to draw
				table.insert(tilesLocTable[hexType], ix)
				table.insert(tilesLocTable[hexType], iy)
				
		-- Sets borders to draw (if the tile next to it is of a different type)
				for i = 1, #hexNeighbors do
					local xTile2 = hexNeighbors[i][1]
					local yTile2 = hexNeighbors[i][2]
				
					if hexMap:getTileType(xTile2, yTile2) ~= hexType then
						hexBorders[i] = 1
						border = true
					else
						hexBorders[i] = 0
					end
				end
			end
			
			if border == true then
				table.insert(bordersLocTable[hexType], ix)
				table.insert(bordersLocTable[hexType], iy)
			end
			
			-- Sets the borders in the hex's data
			hexGrid[ix][iy][8] = hexBorders
		end
	end
	
	hexDrawTable.tiles = tilesLocTable
	hexDrawTable.borders = bordersLocTable
	
	--hexMap:setBorders()
	hexMap:setWalls()
end

function hexMap:setBorders()
	
	local hexMapRadius = hexVariables.hexMapRadius

	local bordersLocTable = {{}, {}, {}}
	
	for ix = 1, #hexGrid do
		for iy = 1, #hexGrid[ix] do
			local hexArray     = hexGrid[ix][iy]
			local hexType      = hexArray[1]
			local xTile        = hexArray[2]
			local yTile        = hexArray[3]
			local x            = hexArray[4]
			local y            = hexArray[5]
			local hexVertices  = hexArray[6]
			local hexNeighbors = hexArray[7]
			local hexBorders   = hexArray[8]
			local hexData      = hexArray[9]
			
			local border = false
			
			if hexType > 0 then
				for i = 1, #hexNeighbors do
					local xTile2 = hexNeighbors[i][1]
					local yTile2 = hexNeighbors[i][2]
				
					if hexMap:getTileType(xTile2, yTile2) ~= hexType then
						hexBorders[i] = 1
						border = true
					else
						hexBorders[i] = 0
					end
				end
			end
			
			if border == true then
				table.insert(bordersLocTable[hexType], ix)
				table.insert(bordersLocTable[hexType], iy)
			end
			
			hexGrid[ix][iy][8] = hexBorders
		end
	end
	
	hexDrawTable.borders = bordersLocTable
end

function hexMap:setWalls()
	local hexMapRadius = hexVariables.hexMapRadius
	local hexHeight = gameGlobals.hexHeight

	local wallsLocTable = {{}, {}, {}}
	local wallsExcessTable = {{}, {}, {}}
	
	for ix = 1, #hexGrid do
		for iy = 1, #hexGrid[ix] do
			local hexArray     = hexGrid[ix][iy]
			local hexType      = hexArray[1]
			local xTile        = hexArray[2]
			local yTile        = hexArray[3]
			local x            = hexArray[4]
			local y            = hexArray[5]
			local hexVertices  = hexArray[6]
			local hexNeighbors = hexArray[7]
			local hexBorders   = hexArray[8]
			local hexData      = hexArray[9]
			
			local dataType = hexData.dataType
			
			if dataType == 0 then
			
				local walls = {{}, {}, {}}
				
				local wall = false
				
				if hexType > 0 then
					if hexType > hexMap:getTileType(xTile, yTile+1) then
						local otherType = hexMap:getTileType(xTile, yTile+1)
						if otherType == -1 then
							otherType = 0
						end
						local otherDataType = hexMap:getTileDataType(xTile, yTile+1)
						
						local heightLevelDif = hexType - otherType
						if otherDataType == 1 then
							heightLevelDif = hexType - 1
						end
						
						--local wallHeight = heightLevelDif * 10
						local wallHeight = hexHeight
						local wallPoints = {hexVertices[11], hexVertices[12], hexVertices[11], hexVertices[12] + wallHeight, hexVertices[1], hexVertices[2] + wallHeight, hexVertices[1], hexVertices[2]}
						--table.insert(walls[hexType][1], wallPoints)
						--table.insert(wallsLocTable[hexType][1], wallPoints)
						walls[1] = wallPoints
						wall = true
						
						if heightLevelDif > 1 then
							table.insert(wallsLocTable[hexType-1], ix)
							table.insert(wallsLocTable[hexType-1], iy)
							if heightLevelDif == 3 then
								table.insert(wallsLocTable[hexType-2], ix)
								table.insert(wallsLocTable[hexType-2], iy)
							end
						end
					end
					if hexType > hexMap:getTileType(xTile+1, yTile) then
						local otherType = hexMap:getTileType(xTile+1, yTile)
						if otherType == -1 then
							otherType = 0
						end
						local otherDataType = hexMap:getTileDataType(xTile+1, yTile)
						
						local heightLevelDif = hexType - otherType
						if otherDataType == 1 then
							heightLevelDif = hexType
						end
						
						local heightLevelDif = hexType - otherType
						local wallHeight = heightLevelDif * hexHeight
						local wallPoints = {hexVertices[1], hexVertices[2], hexVertices[1], hexVertices[2] + wallHeight, hexVertices[3], hexVertices[4] + wallHeight, hexVertices[3], hexVertices[4]}
						walls[2] = wallPoints
						wall = true
						
						if heightLevelDif > 1 then
							table.insert(wallsLocTable[hexType-1], ix)
							table.insert(wallsLocTable[hexType-1], iy)
							if heightLevelDif == 3 then
								table.insert(wallsLocTable[hexType-2], ix)
								table.insert(wallsLocTable[hexType-2], iy)
							end
						end
					end
					if hexType > hexMap:getTileType(xTile+1, yTile-1) then
						local otherType = hexMap:getTileType(xTile+1, yTile-1)
						if otherType == -1 then
							otherType = 0
						end
						local otherDataType = hexMap:getTileDataType(xTile+1, yTile-1)
						
						local heightLevelDif = hexType - otherType
						if otherDataType == 1 then
							heightLevelDif = hexType
						end
						
						local heightLevelDif = hexType - otherType
						local wallHeight = hexHeight
						local wallPoints = {hexVertices[3], hexVertices[4], hexVertices[3], hexVertices[4] + wallHeight, hexVertices[5], hexVertices[6] + wallHeight, hexVertices[5], hexVertices[6]}
						walls[3] = wallPoints
						wall = true
						
						if heightLevelDif > 1 then
							table.insert(wallsLocTable[hexType-1], ix)
							table.insert(wallsLocTable[hexType-1], iy)
							if heightLevelDif == 3 then
								table.insert(wallsLocTable[hexType-2], ix)
								table.insert(wallsLocTable[hexType-2], iy)
							end
						end
					end
				end
				
				if wall == true then
					table.insert(wallsLocTable[hexType], ix)
					table.insert(wallsLocTable[hexType], iy)
				end
				
				hexData.walls = walls
			end
		end
	end
	
	hexDrawTable.walls = wallsLocTable
end

function hexMap:pixelToTile(xPoint, yPoint)
	local hexMapRadius = hexVariables.hexMapRadius

	local closestHexTile = {0, 0}
	local closestHexDist = nil
	
	for ix = 1, #hexGrid do
		for iy = 1, #hexGrid[ix] do
			local hexArray     = hexGrid[ix][iy]
			local hexType      = hexArray[1]
			local xTile        = hexArray[2]
			local yTile        = hexArray[3]
			local x            = hexArray[4]
			local y            = hexArray[5]
			local hexVertices  = hexArray[6]
			local hexNeighbors = hexArray[7]
			local hexBorders   = hexArray[8]
			local hexData      = hexArray[9]
			
			local dist = math.sqrt((x-xPoint)^2+(y-yPoint)^2)
			if closestHexDist == nil or dist < closestHexDist then
				closestHexTile = {xTile, yTile}
				closestHexDist = dist
			end
		end
	end
	
	local xTile = closestHexTile[1]
	local yTile = closestHexTile[2]
	
	if xTile < -hexMapRadius or xTile > hexMapRadius or yTile < -hexMapRadius or yTile > hexMapRadius then
		return nil, nil
	else
		return xTile, yTile
	end
end

function hexMap:moveVertices(xTile, yTile, xD, yD)
	local hexMapRadius      = hexVariables.hexMapRadius
	
	local xIndex = xTile+hexMapRadius+1
	local yIndex = yTile+hexMapRadius+1
	
	local hexArray     = hexGrid[xIndex][yIndex]
	local hexType      = hexArray[1]
	local xTile        = hexArray[2]
	local yTile        = hexArray[3]
	local x            = hexArray[4]
	local y            = hexArray[5]
	local hexVertices  = hexArray[6]
	local hexNeighbors = hexArray[7]
	local hexBorders   = hexArray[8]
	local hexData      = hexArray[9]
	
	local hexTileElevationDifBase = 5
	
	x = x + xD
	y = y + yD
	
	for i = 1, #hexVertices, 2 do
		hexVertices[i] = hexVertices[i] + xD
		hexVertices[i+1] = hexVertices[i+1] + yD
	end
	
	hexGrid[xIndex][yIndex][4] = x
	hexGrid[xIndex][yIndex][5] = y
	hexGrid[xIndex][yIndex][6] = hexVertices
	
	hexMap:setDrawTiles()
end

function hexMap:draw(xMouseTile, yMouseTile, mouseTileType)
	local hexMapRadius = hexVariables.hexMapRadius
	
	local g = gameGlobals
	local editMode = g.editMode
	local playerTile = g.playerTile
	local xPlayerTile    = playerTile[1]
	local yPlayerTile    = playerTile[2]
	local playerTileType = playerTile[3]
	local mouseTile = g.mouseTile
	local xMouseTile = mouseTile[1]
	local yMouseTile = mouseTile[2]
	local mouseTileType = mouseTile[3]
	local hexHeight = g.hexHeight
	
	if editMode and mouseTileType == 0 then
		local xIndex = xMouseTile + hexMapRadius + 1
		local yIndex = yMouseTile + hexMapRadius + 1
		
		local hexArray    = hexGrid[xIndex][yIndex]			
		local hexVertices = hexArray[6]
		
		love.graphics.setColor(mouseTileColor)
		
		local heightDif = hexHeight
		
		love.graphics.polygon("fill", hexVertices[1], hexVertices[2]+heightDif, hexVertices[3], hexVertices[4]+heightDif, hexVertices[5], hexVertices[6]+heightDif, hexVertices[7], hexVertices[8]+heightDif, hexVertices[9], hexVertices[10]+heightDif, hexVertices[11], hexVertices[12]+heightDif)
	end
	
	for i = 1, #hexDrawTable.tiles do
		
		love.graphics.setColor(255, 0, 0)
		
		for j = 1, #hexDrawTable.walls[i], 2 do
			local xIndex = hexDrawTable.walls[i][j]
			local yIndex = hexDrawTable.walls[i][j+1]
			
			hexMap:drawWalls(xIndex, yIndex, i)
		end
		
		
		if i == 1 then
			love.graphics.setColor(tile1Color)
		elseif i == 2 then
			love.graphics.setColor(tile2Color)
		elseif i == 3 then
			love.graphics.setColor(tile3Color)
		end
		for j = 1, #hexDrawTable.tiles[i], 2 do
			local xIndex = hexDrawTable.tiles[i][j]
			local yIndex = hexDrawTable.tiles[i][j+1]
			
			hexMap:drawTile(xIndex, yIndex, xPlayerTile, yPlayerTile, yMouseTile, xMouseTile)
		end
		
		if editMode then
			if i == mouseTileType then
				local xIndex = xMouseTile + hexMapRadius + 1
				local yIndex = yMouseTile + hexMapRadius + 1
				
				local hexArray    = hexGrid[xIndex][yIndex]			
				local hexVertices = hexArray[6]
				
				love.graphics.setColor(mouseTileColor)
				
				love.graphics.polygon("fill", hexVertices)
			end
		else
			if i == playerTileType then
				local xIndex = xPlayerTile + hexMapRadius + 1
				local yIndex = yPlayerTile + hexMapRadius + 1
				
				local hexArray    = hexGrid[xIndex][yIndex]			
				local hexVertices = hexArray[6]
				
				love.graphics.setColor(playerTileColor)
				
				love.graphics.polygon("fill", hexVertices)
			end
		end
		
		
		-- Code for drawing borders
		if bordersEnabled then
			love.graphics.setColor(255, 0, 0)
			for j = 1, #hexDrawTable.borders[i], 2 do
				local xIndex = hexDrawTable.borders[i][j]
				local yIndex = hexDrawTable.borders[i][j+1]
				local hexArray     = hexGrid[xIndex][yIndex]
				local hexType      = hexArray[1]
				local xTile        = hexArray[2]
				local yTile        = hexArray[3]
				local x            = hexArray[4]
				local y            = hexArray[5]
				local hexVertices  = hexArray[6]
				local hexNeighbors = hexArray[7]
				local hexBorders   = hexArray[8]
				local hexData      = hexArray[9]
				
				for i = 1, #hexBorders do
					if hexBorders[i] == 1 then
						local point1 = {hexVertices[i*2-1], hexVertices[i*2]}
						local point2 = {}
						if i == 6 then
							point2 = {hexVertices[1], hexVertices[2]}
						else
							point2 = {hexVertices[i*2+1], hexVertices[i*2+2]}
						end
						
						love.graphics.line(point1[1], point1[2], point2[1], point2[2])
					end
				end
			end
		end
	end
end

function hexMap:drawTile(xIndex, yIndex, xPlayerTile, yPlayerTile, yMouseTile, xMouseTile)
	local hexArray    = hexGrid[xIndex][yIndex]
	local xTile       = hexArray[2]
	local yTile       = hexArray[3]   
	local hexVertices = hexArray[6]
	local hexData     = hexArray[9]
	
	local dataType = hexData.dataType
	local r, g, b = love.graphics.getColor()
	
	if dataType == 1 then
		love.graphics.setColor(bridgeColor)
	end
	
	local hexHeight = gameGlobals.hexHeight

	love.graphics.polygon("fill", hexVertices)
	
	love.graphics.setColor(r, g, b)
end

function hexMap:drawWalls(xIndex, yIndex, tileHeight)
	local hexArray     = hexGrid[xIndex][yIndex]
	local hexType      = hexArray[1]
	local hexData      = hexArray[9]
			
	local walls = hexData.walls
	
	local heightDif = 0
	
	local hexHeight = gameGlobals.hexHeight
	
	if hexType ~= tileHeight then
		heightDif = (hexType - tileHeight) * hexHeight
	end
	
	for i = 1, #walls do
		if #walls[i] > 0 then
			if i == 1 then
				love.graphics.setColor(wall1Color)
			elseif i == 2 then
				love.graphics.setColor(wall2Color)
			elseif i == 3 then
				love.graphics.setColor(wall3Color)
			end
			
			if i == 2 then
				love.graphics.polygon("fill", walls[i])
			else
				love.graphics.polygon("fill", walls[i][1], walls[i][2]+heightDif, walls[i][3], walls[i][4]+heightDif, walls[i][5], walls[i][6]+heightDif, walls[i][7], walls[i][8]+heightDif)
			end
		end
	end
end

function hexMap:saveMap()
	local mapRadius = hexVariables.hexMapRadius
	for ix = 1, #hexGrid do
		for iy = 1, #hexGrid[ix] do
			local hexArray     = hexGrid[ix][iy]
			local hexType      = hexArray[1]
		end
	end
end

return hexMap