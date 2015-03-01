TowerController = class('TowerController')

function TowerController:initialize()
	self.towers = {}
	
	self.cost = 3
	
	self.statMin = 1
	self.statMax = 3
end

function TowerController:update(dt)
	for k, tower in pairs(self.towers) do
		tower:update(dt)
	end
end

function TowerController:checkHover(tileX, tileY)
	local found = false
	for k, tower in pairs(self.towers) do
		if tower.x == tileX and tower.y == tileY then
			tower:hover(true)
			found = true
		else
			tower:hover(false)
		end
	end
	
	if not found then
		game.activeTower = false
	end
end

function TowerController:draw()
	for k, tower in pairs(self.towers) do
		tower:draw()
	end
end

function TowerController:mousepressed(x, y, mbutton)
	if mbutton == 'l' then
		local tileX, tileY = game.map:pixelToTile(x-game.camera.x, y-50-game.camera.y)
		local tileType = game.map:getTile(tileX, tileY)
		if tileType > 0 and tileType ~= 4 and tileType <= 6 then
			local clear = true
			for k, tower in pairs(self.towers) do
				if tower.x == tileX and tower.y == tileY then
					clear = false
					
					-- upgrade tower
					if game.money >= tower.upgradeCost then
						tower:upgrade()
					end
				end
			end
			
			if clear then
				if game.money >= self.cost then
					self:addTower(tileX, tileY)
				end
			end
		end
	end
end

function TowerController:addTower(tileX, tileY)
	--local total = math.random(self.statMin, self.statMax)
	local range = .5
	local fireRate = .5
	local damage = 0
	
	table.insert(self.towers, Tower:new(tileX, tileY, range, fireRate, damage))
	game.money = game.money - self.cost
	--self.cost = self.cost + 1
end