Tower = class('Tower')

function Tower:initialize(x, y)
	self.x = x
	self.y = y
	
	
	self.tileWidth = 101
	self.tileHeight = 80
	self.heightDif = 120 - self.tileHeight
	self.height = #game.map.tiles[self.y][self.x].tiles
	self.screenX = (self.x-1) * self.tileWidth
	self.screenY = (self.y-1) * self.tileHeight
	local pixelHeight = (self.height)*self.heightDif
	self.screenY = self.screenY - pixelHeight -- move higher tiles up
	
	self.img = love.graphics.newImage('img/Character Boy.png')
	
	self.hovered = false
	
	self.range = 150
	self.fireRate = 1
	self.damage = 2
	
	self.timer = 0
	
	self.lastHitX = nil
	self.lastHitY = nil
	self.lastHitTimer = 0
	
	self.centerX = self.screenX + self.tileWidth/2
	self.centerY = self.screenY + 135
end

function Tower:update(dt)
	self.timer = self.timer + dt
	if self.timer >= self.fireRate then
		self.timer = 0
		self:hitEnemy()
	end
	
	self.lastHitTimer = self.lastHitTimer - dt
	if self.lastHitTimer <= 0 then
		self.lastHitX = nil
		self.lastHitY = nil
	end
end

function Tower:hitEnemy()
	local closestIndex = 0
	local closestDist = 10000
	for i, enemy in ipairs(game.enemyController.enemies) do
		local dist = math.dist(enemy.screenX, enemy.screenY, self.screenX, self.screenY)
		if dist <= self.range and dist < closestDist then
			closestIndex = i
		end
	end
	
	if closestIndex > 0 then
		local enemy = game.enemyController.enemies[closestIndex]
		enemy.health = enemy.health - self.damage
		
		self.lastHitX = enemy.centerX
		self.lastHitY = enemy.centerY
		self.lastHitTimer = .5
		
		if enemy.health <= 0 then
			enemy.delete = true
			game.money = game.money + 1
		end
	end
end

function Tower:hover(state)
	self.hovered = state
end

function Tower:draw()
	if self.lastHitX and self.lastHitY then
		love.graphics.line(self.centerX, self.centerY, self.lastHitX, self.lastHitY)
	end

	love.graphics.draw(self.img, self.screenX, self.screenY)
	
	if self.hovered then
		love.graphics.setColor(0, 255, 0)
		love.graphics.circle('line', self.centerX, self.centerY, self.range)
	end
	
	love.graphics.setColor(255, 255, 255)
end