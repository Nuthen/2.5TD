Map = class('Map')

function Map:initialize(width, height)
	self.width = width
	self.height = height
	
	self.tileWidth = 101
	self.tileHeight = 171
	
	self.tileTypes = require 'data/tileData'
	
	self.screenWidth = self.width*self.tileWidth
	self.screenHeight = self.height*self.tileHeight
	
	self.tiles = {}
	
	for iy = 1, self.height do
		self.tiles[iy] = {}
		for ix = 1, self.width do
			self.tiles[iy][ix] = Tile:new(ix, iy)
		end
	end
	
	self.nodes = {}
	
	self.tiles[2][2].node = 1
	table.insert(self.nodes, {2, 2})
	self.tiles[2][9].node = 2
	table.insert(self.nodes, {9, 2})
	self.tiles[5][9].node = 3
	table.insert(self.nodes, {9, 5})
	self.tiles[5][3].node = 4
	table.insert(self.nodes, {3, 5})
	self.tiles[9][3].node = 5
	table.insert(self.nodes, {3, 9})
	self.tiles[9][8].node = 6
	table.insert(self.nodes, {8, 9})
	
	
	
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
	if elevation < 1 then
		return 0
	end
	if x < 1 or x > self.width or y < 1 or y > self.height then
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
	--error(screenY..' '..y)
	
	return x, y
end