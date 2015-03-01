Map = class('Map')

function Map:initialize(file)
	self.tiles = {}
	self:load(file)

	--self.width = width
	--self.height = height
	
	self.tileWidth = 101
	self.tileHeight = 171
	
	self.tileTypes = require 'data/tileData'
	
	self.screenWidth = self.width*self.tileWidth
	self.screenHeight = self.height*self.tileHeight
	
	
	--[[
	for iy = 1, self.height do
		self.tiles[iy] = {}
		for ix = 1, self.width do
			self.tiles[iy][ix] = Tile:new(ix, iy)
		end
	end
	]]
	
	self.nodes = {}
	
	self.tiles[1][3].node = 1
	table.insert(self.nodes, {3, 1})
	self.tiles[5][3].node = 2
	table.insert(self.nodes, {3, 5})
	self.tiles[5][6].node = 3
	table.insert(self.nodes, {6, 5})
	self.tiles[2][6].node = 4
	table.insert(self.nodes, {6, 2})
	self.tiles[2][9].node = 5
	table.insert(self.nodes, {9, 2})
	self.tiles[9][9].node = 6
	table.insert(self.nodes, {9, 9})
	self.tiles[9][6].node = 7
	table.insert(self.nodes, {6, 9})
	self.tiles[7][6].node = 8
	table.insert(self.nodes, {6, 7})
	self.tiles[7][7].node = 9
	table.insert(self.nodes, {7, 7})
	
	
	
	-- shadows
	self.shadowImages = {}
	shadowEastImage = love.graphics.newImage("img/Shadow East.png")
	table.insert(self.shadowImages, shadowEastImage)
	shadowNorthEastImage = love.graphics.newImage("img/Shadow North East.png")
	table.insert(self.shadowImages, shadowNorthEastImage)
	shadowNorthImage = love.graphics.newImage("img/Shadow North.png")
	table.insert(self.shadowImages, shadowNorthImage)
	shadowNorthWestImage = love.graphics.newImage("img/Shadow North West.png")
	table.insert(self.shadowImages, shadowNorthWestImage)
	shadowWestImage = love.graphics.newImage("img/Shadow West.png")
	table.insert(self.shadowImages, shadowWestImage)
	shadowSouthWestImage = love.graphics.newImage("img/Shadow South West.png")
	table.insert(self.shadowImages, shadowSouthWestImage)
	shadowSouthImage = love.graphics.newImage("img/Shadow South.png")
	table.insert(self.shadowImages, shadowSouthImage)
	shadowSouthEastImage = love.graphics.newImage("img/Shadow South East.png")
	table.insert(self.shadowImages, shadowSouthEastImage)
	shadowSideWestImage = love.graphics.newImage("img/Shadow Side West.png")
	table.insert(self.shadowImages, shadowSideWestImage)
	
	
	
	self.canvas = love.graphics.newCanvas(self.screenWidth, self.screenHeight)
	self:drawCanvas()
end

function Map:drawCanvas()
	self.canvas:clear()
	
	self.canvas:renderTo(function()
		for iy = 1, self.height do
			for ix = 1, self.width do
				local tile = self.tiles[iy][ix]
				tile:draw(self.tileTypes)
				
				self:drawShadows(tile)
			end
		end
	end)
end

function Map:drawShadows(tile)
	local x, y = tile.x, tile.y
	local tileStack = tile.tiles
	local height = #tileStack
	local screenHeight = (height-1)*tile.heightDif
	local screenX, screenY = tile.screenX, tile.screenY
	screenY = screenY - screenHeight
	
	if #tileStack > 0 then
		if self:getTile(x+1, y, height+1) ~= 0 then
			love.graphics.draw(self.shadowImages[1], screenX, screenY)
		end
		if self:getTile(x, y-1, height+1) == 0 and self:getTile(x+1, y-1, height+1) ~= 0 then
			love.graphics.draw(self.shadowImages[2], screenX, screenY)
		end
		if self:getTile(x, y-1, height+1) ~= 0 then
			love.graphics.draw(self.shadowImages[3], screenX, screenY)
		end
		if self:getTile(x, y-1, height+1) == 0 and self:getTile(x-1, y-1, height+1) ~= 0 and self:getTile(x-1, y, height+1) == 0 then
			love.graphics.draw(self.shadowImages[4], screenX, screenY)
		end
		if self:getTile(x-1, y, height+1) ~= 0 then
			love.graphics.draw(self.shadowImages[5], screenX, screenY)
		end
		if self:getTile(x-1, y, height+1) == 0 and self:getTile(x-1, y+1, height+1) ~= 0 then
			love.graphics.draw(self.shadowImages[6], screenX, screenY)
		end
		if self:getTile(x, y+1, height+1) ~= 0 then
			love.graphics.draw(self.shadowImages[7], screenX, screenY)
		end
		if self:getTile(x+1, y, height+1) == 0 and self:getTile(x+1, y+1, height+1) ~= 0 then
			love.graphics.draw(self.shadowImages[8], screenX, screenY)
		end
	end
	
	for i = 1, #tileStack do
		local height = i
		local screenHeight = (height-1)*tile.heightDif
		local screenX, screenY = tile.screenX, tile.screenY
		screenY = screenY - screenHeight
		
		if self:getTile(x, y+1, height) == 0 and self:getTile(x-1, y+1, height) ~= 0 then
			love.graphics.draw(self.shadowImages[9], screenX, screenY)
		end
	end
end

function Map:draw()
	love.graphics.draw(self.canvas)
end


function Map:getTile(x, y, elevation)
	if x < 1 or x > self.width or y < 1 or y > self.height then
		--error(x..' '..y)
		return 0
	end
	
	if elevation == nil then elevation = #self.tiles[y][x].tiles end

	if elevation < 1 then
		return 0
	end
	
	
	local tile = self.tiles[y][x]
	
	if elevation > #tile.tiles then
		return 0
	else
		local tileType = tile.tiles[elevation]
		return tileType
	end
end

function Map:pixelToTile(screenX, screenY)
	local x = math.floor(screenX / self.tileWidth)+1
	local y = math.floor((screenY) / 80)+1
	
	return x, y
end


function Map:load(file)
	local ok, data = pcall(love.filesystem.read, file)
	
	if not ok then
		error(data)
	elseif ok and data then
		local mapTable = stringToTable(data)
		
		local widthMax = tonumber(mapTable[1])
		local heightMax = tonumber(mapTable[2])
		local elevationMax = tonumber(mapTable[3])
		
		self.tiles = {}
		local x, y, elevation = 1, 1, 1
		
		for i = 4, #mapTable do
			if not self.tiles[y] then
				self.tiles[y] = {}
			end
			if not self.tiles[y][x] then
				self.tiles[y][x] = Tile:new(x, y)
			end
			
			self.tiles[y][x].tiles[elevation] = tonumber(mapTable[i])
			
			elevation = elevation + 1
			if elevation > elevationMax then
				elevation = 1
				y = y + 1
			end
			if y > heightMax then
				y = 1
				x = x + 1
			end
			
			--[[y = y + 1
			if y > heightMax then
				y = 1
				x = x + 1
			end
			if x > widthMax then
				break
			end]]
			
		end
		
		self.width = widthMax
		self.height = heightMax
	end
	
	for ix = 1, #self.tiles do
		for iy = 1, #self.tiles[ix] do
			for iz = #self.tiles[ix][iy].tiles, 1, -1 do
				if self.tiles[ix][iy].tiles[iz] == 0 then
					table.remove(self.tiles[ix][iy].tiles, iz)
				end
			end
		end
	end
end