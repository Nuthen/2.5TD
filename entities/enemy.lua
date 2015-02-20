Enemy = class('Enemy')

function Enemy:initialize()
	self.tileWidth = 101
	self.tileHeight = 80
	self.heightDif = 120 - self.tileHeight
	
	self.node = 1
	self.targetNode = 2
	
	self.nodeList = game.map.nodes
	
	self.x = self.nodeList[self.node][1]
	self.y = self.nodeList[self.node][2]
	self.height = #game.map.tiles[self.y][self.x].tiles
	
	self:setNode()
	self.node = 1
	self.targetNode = 2
	
	self.screenX = (self.x-1) * self.tileWidth
	self.screenY = (self.y-1) * self.tileHeight
	
	
	local pixelHeight = (self.height)*self.heightDif
	self.screenY = self.screenY - pixelHeight -- move higher tiles up
	
	
	
	self.speed = 50
	
	self.dir = nil
	
	self.img = love.graphics.newImage('img/Enemy Bug.png')
	
	self.delete = false
end

function Enemy:setNode()
	self.node = self.node+1
	self.targetNode = self.targetNode+1
	
	if self.targetNode > #self.nodeList then -- end reached, hit base
		self.delete = true
	else
		local pixelHeight = (self.height)*self.heightDif
		
		self.targetX = self.nodeList[self.targetNode][1]
		self.targetY = self.nodeList[self.targetNode][2]
		self.targetScreenX = (self.targetX-1) * self.tileWidth
		self.targetScreenY = (self.targetY-1) * self.tileHeight
		self.targetScreenY = self.targetScreenY - pixelHeight
		
		self.screenX = (self.x-1) * self.tileWidth
		self.screenY = (self.y-1) * self.tileHeight
		local pixelHeight = (self.height)*self.heightDif
		self.screenY = self.screenY - pixelHeight -- move higher tiles up
	end
end

function Enemy:update(dt)
	if self.targetX > self.x then
		self.screenX = self.screenX + self.speed*dt
		self.dir = 'right'
	elseif self.targetX < self.x then
		self.screenX = self.screenX - self.speed*dt
		self.dir = 'left'
	elseif self.targetY > self.y then
		self.screenY = self.screenY + self.speed*dt
		self.dir = 'down'
	elseif self.targetY < self.y then
		self.screenY = self.screenY - self.speed*dt
		self.dir = 'up'
	end
	
	local x, y = game.map:pixelToTile(self.screenX, self.screenY+(self.height*self.heightDif))
	--if y > 2 then error(x..' '..y) end
	
	if self.dir == 'left' or self.dir == 'up' then
		x = math.ceil(self.screenX / self.tileWidth)+1
		y = math.ceil(self.screenY / 80)+1
	end
	
	game.map.tiles[y][x].tiles[#game.map.tiles[y][x].tiles] = 4
	game.map:drawCanvas()
	if x ~= self.x or y ~= self.y then
		self.x = x
		self.y = y
		
		if self.dir == 'right' then
			if self.x == self.targetX then
				self:setNode()
			end
		elseif self.dir == 'left' then
			if self.x == self.targetX then
				self:setNode()
			end
		elseif self.dir == 'down' then
			if self.y == self.targetY then
				self:setNode()
			end
		elseif self.dir == 'up' then
			if self.y == self.targetY then
				self:setNode()
			end
		end
	end
end

function Enemy:draw()
	love.graphics.draw(self.img, self.screenX, self.screenY)
end