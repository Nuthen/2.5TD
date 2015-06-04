game = {}

function game:enter()
	love.graphics.setBackgroundColor(99, 191, 212)

    self.camera = {x = 0, y = 0, speed = 10}
	self.map = Map:new('data/levels/savelevel.txt')
	
	self.enemyController = EnemyController:new()
	
	self.towerController = TowerController:new()
	
	self.wave = 1
	
	self.timer = 0
	self.timeStep = 4
	
	self.hoverTileX = 1
	self.hoverTileY = 1
	
	self.money = 8
	self.waveMoneyGain = 4
	
	self.lives = 5
	
	self.activeTower = nil
end

function game:newWave()
	self.wave = self.wave + 1
	self.money = self.money + self.waveMoneyGain
end

function game:update(dt)
	local dx, dy = 0, 0
	if love.keyboard.isDown('w', 'up') then--or love.keyboard.isDown("w") then
		dy = self.camera.speed
	elseif love.keyboard.isDown('s', 'down') then--or love.keyboard.isDown("s") then
		dy = -self.camera.speed
	end
	if love.keyboard.isDown('a', 'left') then--or love.keyboard.isDown("a") then
		dx = self.camera.speed
	elseif love.keyboard.isDown('d', 'right') then--or love.keyboard.isDown("d") then
		dx = -self.camera.speed
	end
	if dx ~= 0 or dy ~= 0 then
		if dx ~= 0 and dy ~= 0 then
			-- This is to make diagonal camera movement the same speed as vertical and horizontal
			self.camera.x = self.camera.x + dx * 1/math.sqrt(2)
			self.camera.y = self.camera.y + dy * 1/math.sqrt(2)
		else
			self.camera.x = self.camera.x + dx
			self.camera.y = self.camera.y + dy
		end
	end
	
	
	local x, y = love.mouse.getPosition()
	local tileX, tileY = game.map:pixelToTile(x-self.camera.x, y-50-self.camera.y)
	
	
	if self.map:getTile(tileX, tileY) > 0 then
		if tileX ~= self.hoverX or tileY ~= self.hoverY then
			self.hoverX = tileX
			self.hoverY = tileY
			self.map:drawCanvas()
		end
		
		self.towerController:checkHover(tileX, tileY)
	end
	
	self.enemyController:update(dt)
	
	self.towerController:update(dt)
	
	self.enemyController:checkDelete()
	
end

function game:keypressed(key, isrepeat)
    if console.keypressed(key) then
        return
    end
end

function game:mousepressed(x, y, mbutton)
    if console.mousepressed(x, y, mbutton) then
        return
    end
	
	self.towerController:mousepressed(x, y, mbutton)
end

function game:draw()
	love.graphics.setColor(255, 255, 255)

	love.graphics.push()
	love.graphics.translate(self.camera.x, self.camera.y)

	self.map:draw()
	
	self.towerController:draw()
	
	self.enemyController:draw()
	
	love.graphics.pop()
   
	love.graphics.setColor(0, 0, 0)
    love.graphics.setFont(font[24])
    love.graphics.print('FPS: '..love.timer.getFPS(), 5, 5)
	love.graphics.print('Money: '..self.money, 5, 35)
	love.graphics.print('Lives: '..self.lives, 5, 65)
	love.graphics.print('Wave: '..self.wave..' ('..self.enemyController.spawnCount+#self.enemyController.enemies..' left)', 5, 95)
	love.graphics.print('Cost: '..self.towerController.cost, 5, 125)
	
	if self.activeTower then
		love.graphics.setFont(font[22])
		love.graphics.print('Tower Stats\nRange: '..self.activeTower.range..'\nFire Rate: '..self.activeTower.fireRate..'\nDamage: '..self.activeTower.damage..'\nLevel: '..self.activeTower.level..'\nUpgrade Cost: '..self.activeTower.upgradeCost..'\nKills: '..self.activeTower.kills, 5, 250)
	end
	love.graphics.setColor(255, 255, 255)
end

function game:loseLife()
	self.lives = self.lives - 1
	if self.lives <= 0 then
		state.switch(game)
	end
end