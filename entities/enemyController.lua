EnemyController = class('EnemyController')

function EnemyController:initialize()
	self.enemies = {}
	
	self.spawnCount = 3
	
	self.timer = 0
	self.spawnSep = 2
	
	self.statsMin = 3
	self.statsMax = 5
end

function EnemyController:update(dt)
	if self.spawnCount > 0 then
		self.timer = self.timer + dt
		if self.timer >= self.spawnSep then
			self.spawnCount = self.spawnCount - 1
			self.timer = 0
			self:spawn()
		end
	end

	for k, enemy in pairs(self.enemies) do
		enemy:update(dt)
	end
end

function EnemyController:spawn()
	local total = game.wave*math.random(self.statsMin, self.statsMax)
	local hp = math.random(1, total)
	local speed = total - hp
	table.insert(self.enemies, Enemy:new((hp+game.wave/2)*2, (speed+game.wave/2)*30))
end

function EnemyController:checkDelete()
	for i = #self.enemies, 1, -1 do
		local enemy = self.enemies[i]
		if enemy.delete then
			table.remove(self.enemies, i)
		end
	end
	
	if #self.enemies == 0 and self.spawnCount == 0 then
		self:newWave()
	end
end

function EnemyController:draw()
	for k, enemy in pairs(self.enemies) do
		enemy:draw()
	end
end

function EnemyController:newWave()
	game:newWave()
	self.spawnCount = game.wave*3
	--self.spawnSep = 2 / (game.wave/5)
end