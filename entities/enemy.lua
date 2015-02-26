Enemy = class('Enemy')

function Enemy:initialize(health, speed)
	self.tileWidth = 101
	self.tileHeight = 80
	self.heightDif = 120 - self.tileHeight
	
	self.node = 1
	self.targetNode = 2
	
	self.nodeList = game.map.nodes
	
	self.x = self.nodeList[self.node][1]
	self.y = self.nodeList[self.node][2]
	self.height = #game.map.tiles[self.y][self.x].tiles
	
	self.node = 0
	self.targetNode = 1
	self:setNode()
	self.node = 1
	self.targetNode = 2
	
	self.screenX = (self.x-1) * self.tileWidth
	self.screenY = (self.y-1) * self.tileHeight
	
	
	local pixelHeight = (self.height)*self.heightDif
	self.screenY = self.screenY - pixelHeight -- move higher tiles up
	
	self.maxHealth = health or 20
	self.health = self.maxHealth
	self.maxSpeed = speed or 100
	self.speed = self.maxSpeed
	
	self.dir = nil
	
	self.img = love.graphics.newImage('img/Enemy Bug.png')
	
	self.delete = false
	
	self.centerX = self.screenX + self.tileWidth/2
	self.centerY = self.screenY + 135
end

function Enemy:setNode()
	self.node = self.node+1
	self.targetNode = self.targetNode+1
	
	if self.targetNode > #self.nodeList then -- end reached, hit base
		self.delete = true
		game:loseLife()
	else
		
		self.targetX = self.nodeList[self.targetNode][1]
		self.targetY = self.nodeList[self.targetNode][2]
		self.targetScreenX = (self.targetX-1) * self.tileWidth + self.tileWidth/2
		self.targetScreenY = (self.targetY-1) * self.tileHeight + 135
		local pixelHeight = (#game.map.tiles[self.targetY][self.targetX].tiles)*self.heightDif
		
		self.targetScreenY = self.targetScreenY - pixelHeight
		
		self.screenX = (self.x-1) * self.tileWidth
		self.screenY = (self.y-1) * self.tileHeight
		local pixelHeight = (self.height)*self.heightDif
		self.screenY = self.screenY - pixelHeight -- move higher tiles up
		
		self.centerX = self.screenX + self.tileWidth/2
		self.centerY = self.screenY + 135
	end
end

function Enemy:update(dt)
	
	if self.dir == 'left' or self.dir == 'up' then 
		--x = math.ceil(self.screenX / self.tileWidth)+1
		--y = math.ceil(self.screenY / 80)+1
	end
	
	if not self.dir then
		if self.centerX < self.targetScreenX then self.dir = 'right'
		elseif self.centerX > self.targetScreenX then self.dir = 'left'
		elseif self.centerY < self.targetScreenY then self.dir = 'down'
		elseif self.centerY > self.targetScreenY then self.dir = 'up' end
	end
	
	
	if self.dir == 'right' and self.targetScreenX > self.centerX then
		self.screenX = self.screenX + self.speed*dt
	elseif self.dir == 'left' and self.targetScreenX < self.centerX then
		self.screenX = self.screenX - self.speed*dt
	elseif self.dir == 'down' and self.targetScreenY > self.centerY then
		self.screenY = self.screenY + self.speed*dt
	elseif self.dir == 'up' and self.targetScreenY < self.centerY then
		self.screenY = self.screenY - self.speed*dt
	end
	
	self.centerX = self.screenX + self.tileWidth/2
	self.centerY = self.screenY + 135
	
	local pixelHeight = (self.height)*self.heightDif
	local x, y = game.map:pixelToTile(self.centerX, self.centerY+pixelHeight-100)
	
	if x ~= self.x or y ~= self.y then
		--game.map.tiles[y][x].tiles[#game.map.tiles[y][x].tiles] = 4
		--game.map:drawCanvas()
		
		--[[
		if #game.map.tiles[y][x].tiles ~= self.height then
			self.height = #game.map.tiles[y][x].tiles
			self.screenY = (self.y-1) * self.tileHeight
			
			local pixelHeight = (self.height)*self.heightDif
			self.screenY = self.screenY - pixelHeight -- move higher tiles up
			
			self.centerX = self.screenX + self.tileWidth/2
			self.centerY = self.screenY + 135
		end
		]]
	end
	
	self.x = x
	self.y = y
	
	local tileType = game.map:getTile(x, y)
	if tileType >= 8 and tileType <= 11 then
		if tileType == 8 then
			local tileScreenX = (x) * self.tileWidth
			self.height = #game.map.tiles[y][x].tiles - 1 + math.abs(self.centerX-tileScreenX)/self.tileWidth
			self.screenY = (self.y-1) * self.tileHeight
	
			local pixelHeight = (self.height)*self.heightDif
			self.screenY = self.screenY - pixelHeight -- move higher tiles up
			
		elseif tileType == 11 then
			local tileScreenX = (x-1) * self.tileWidth
			self.height = #game.map.tiles[y][x].tiles - 1 + (self.centerX-tileScreenX)/self.tileWidth
			
			self.screenY = (self.y-1) * self.tileHeight
	
			local pixelHeight = (self.height)*self.heightDif
			self.screenY = self.screenY - pixelHeight -- move higher tiles up
		end
		
		self.speed = self.maxSpeed/2
	else
		self.height = #game.map.tiles[y][x].tiles
		self.speed = self.maxSpeed
	end
	
	if self.dir == 'right' then
		if self.centerX >= self.targetScreenX then
			self:setNode()
			self.dir = nil
		end
	elseif self.dir == 'left' then
		if self.centerX <= self.targetScreenX then
			self:setNode()
			self.dir = nil
		end
	elseif self.dir == 'down' then
		if self.centerY >= self.targetScreenY then
			self:setNode()
			self.dir = nil
		end
	elseif self.dir == 'up' then
		if self.centerY <= self.targetScreenY then
			self:setNode()
			self.dir = nil
		end
	end
end

function Enemy:draw()
	love.graphics.draw(self.img, self.screenX, self.screenY)
	
	local x, y = self.screenX + self.tileWidth/2 - self.maxHealth/2, self.screenY + 135 - 75
	love.graphics.setColor(255, 0, 0)
	love.graphics.line(x, y, x+self.maxHealth, y)
	love.graphics.setColor(0, 255, 0)
	love.graphics.line(x, y, x+self.health, y)
	
	--love.graphics.setColor(255, 0, 0)
	--love.graphics.circle('fill', self.centerX, self.centerY, 20)

	love.graphics.setColor(255, 255, 255)
end