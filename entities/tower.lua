Tower = class('Tower')

function Tower:initialize(x, y, range, fireRate, damage)
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
	
	self.baseRange = range
	self.baseFireRate = fireRate
	self.baseDamage = damage
	
	self:setStats()
	
	self.upgradeCost = 5
	
	self.timer = 0
	
	self.lastHitX = nil
	self.lastHitY = nil
	self.lastHitTimer = 0
	
	self.kills = 0
	
	self.level = 1
	
	self.centerX = self.screenX + self.tileWidth/2
	self.centerY = self.screenY + 135
end

function Tower:update(dt)
	self.timer = self.timer + dt
	if self.timer >= self.fireRate then
		local success = self:hitEnemy()
		
		if success then -- towers won't have to cooldown again if they can't hit a target
			self.timer = 0
		end
	end
	
	self.lastHitTimer = self.lastHitTimer - dt
	if self.lastHitTimer <= 0 then
		self.lastHitX = nil
		self.lastHitY = nil
	end
end

function Tower:hitEnemy()
	local closestIndex = 0
	local furthestNode = 0
	local closestDist = 10000
	for i, enemy in ipairs(game.enemyController.enemies) do
		local dist = math.dist(enemy.screenX, enemy.screenY, self.screenX, self.screenY)
		if dist <= self.range then
			if enemy.targetNode > furthestNode then
				furthestNode = enemy.targetNode
				closestIndex = i
			elseif enemy.targetNode == furthestNode then
				local distToNode = math.dist(enemy.screenX, enemy.screenY, enemy.targetScreenX-self.tileWidth/2, enemy.targetScreenY-135)
				if distToNode < closestDist then
					closestDist = distToNode
					closestIndex = i
				end
			end
		end
	end
	
	if closestIndex > 0 then
		local enemy = game.enemyController.enemies[closestIndex]
		enemy.health = enemy.health - self.damage
		
		self.lastHitX = enemy.centerX
		self.lastHitY = enemy.centerY
		self.lastHitTimer = .2
		
		if enemy.health <= 0 then
			enemy.delete = true
			game.money = game.money + 2
			self.kills = self.kills + 1
		end
		
		return true
	else
		return false
	end
end

function Tower:hover(state)
	self.hovered = state
	if state == true then
		game.activeTower = self
	end
end

function Tower:draw()
	love.graphics.setColor(247, 40, 40)
	if self.lastHitX and self.lastHitY then
		love.graphics.line(self.centerX, self.centerY, self.lastHitX, self.lastHitY)
	end
	
	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(self.img, self.screenX, self.screenY)
	
	if self.hovered then
		love.graphics.setColor(0, 255, 0)
		love.graphics.circle('line', self.centerX, self.centerY, self.range)
	end
	
	love.graphics.setColor(255, 255, 255)
end

function Tower:upgrade()
	local stat = math.random(1, 3)
	if stat == 1 then
		self.baseRange = self.baseRange + 1
	elseif stat == 2 then
		self.baseFireRate = self.baseFireRate + 1
	else
		self.baseDamage = self.baseDamage + 1
	end
	
	game.money = game.money - self.upgradeCost
	self.upgradeCost = self.upgradeCost + 2
	self:setStats()
	
	local total = self.baseRange+self.baseFireRate+self.baseDamage
	if self.level == 1 then
		if total >= 10 then
			self.level = 2
			self.img = love.graphics.newImage('img/Character Cat Girl.png')
		end
	elseif self.level == 2 then
		if total >= 13 then
			self.level = 3
			self.img = love.graphics.newImage('img/Character Horn Girl.png')
		end
	elseif self.level == 3 then
		if total >= 16 then
			self.level = 4
			self.img = love.graphics.newImage('img/Character Princess Girl.png')
		end
	end
end

function Tower:setStats()
	self.range = self.baseRange*80 + 120
	self.fireRate =  math.ceil(2/(self.baseFireRate+1) * 100)/100
	self.damage = self.baseDamage + 2
end