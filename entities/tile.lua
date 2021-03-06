Tile = class('Tile')


function Tile:initialize(x, y)
	self.x = x
	self.y = y
	self.tiles = {} -- list of stacked tiles
	
	local height = 1
	
	for i = 1, height do
		table.insert(self.tiles, 3)
	end
	
	self.tileImageWidth = 101
	self.tileImageHeight = 171

	self.tileWidth = 101
	self.tileHeight = 80
	
	self.heightDif = 120 - self.tileHeight
	
	self.screenX = (self.x-1) * self.tileWidth
	self.screenY = (self.y-1) * self.tileHeight
	
	self.node = 0
	self.color = false
end

function Tile:draw(tileList)
	love.graphics.setColor(255, 255, 255)
	
	if self.node > 0 then
		--love.graphics.setColor(125, 125, 255)
	end
	
	--if self.color then
	if self.x == game.hoverX and self.y == game.hoverY then
		love.graphics.setColor(57, 89, 230)
	end
	
	for i = 1, #self.tiles do
		local x, y = self.screenX, self.screenY
		local height = (i-1)*self.heightDif
		y = y - height -- move higher tiles up
		
		local tileType = self.tiles[i]
		if tileType > 0 then
			love.graphics.draw(tileList[tileType].image, x, y)
		end
	end
	
	--[[
	if self.node > 0 then
		local x, y = self.screenX, self.screenY
		local height = (#self.tiles-1)*self.heightDif
		y = y - height -- move higher tiles up
		
		x = x + self.tileWidth/2
		y = y + self.tileHeight/2
		
		love.graphics.print(self.node, x, y)
	end]]
	
	--[[
	if self.tiles[#self.tiles] == 9 then
		love.graphics.setColor(255, 0, 255)
		local tileScreenY = (self.y) * self.tileHeight - (#self.tiles*self.heightDif) + 50
		love.graphics.circle('fill', self.screenX, tileScreenY, 20)
	end]]
	
	love.graphics.setColor(255, 255, 255)
end