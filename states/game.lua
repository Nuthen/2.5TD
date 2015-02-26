game = {}

function game:enter()
	love.graphics.setBackgroundColor(99, 191, 212)

    self.camera = {x = 0, y = 0, speed = 10}
	self.map = Map:new('data/levels/savelevel.txt')
	
	self.towers = {}
	self.enemyController = EnemyController:new()
	
	self.wave = 1
	
	self.timer = 0
	self.timeStep = 4
	
	self.hoverTileX = 1
	self.hoverTileY = 1
	
	self.money = 8
	
	self.lives = 5
end

function game:newWave()
	self.wave = self.wave + 1
	--self.money = self.money + 5
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
		--error(self.map:getTile(tileX, tileY))
	if self.map:getTile(tileX, tileY) > 0 then
		if tileX ~= self.hoverX or tileY ~= self.hoverY then
			self.hoverX = tileX
			self.hoverY = tileY
			self.map:drawCanvas()
		end
		
		for k, tower in pairs(self.towers) do
			if tower.x == tileX and tower.y == tileY then
				tower:hover(true)
			else
				tower:hover(false)
			end
		end
	end
	
	self.enemyController:update(dt)
	
	for k, tower in pairs(self.towers) do
		tower:update(dt)
	end
	
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
	
	if mbutton == 'l' then
		local tileX, tileY = game.map:pixelToTile(x-self.camera.x, y-50-self.camera.y)
		local tileType = self.map:getTile(tileX, tileY)
		if tileType > 0 and tileType ~= 4 and tileType <= 6 then
			local clear = true
			for k, tower in pairs(self.towers) do
				if tower.x == tileX and tower.y == tileY then
					clear = false
				end
			end
			
			if clear then
				if self.money >= 2 then
					table.insert(self.towers, Tower:new(tileX, tileY))
					self.money = self.money - 4
				end
			end
		end
	end
end

function game:draw()
	love.graphics.push()
	love.graphics.translate(self.camera.x, self.camera.y)

	self.map:draw()
	
	for k, tower in pairs(self.towers) do
		tower:draw()
	end
	
	self.enemyController:draw()
	
	love.graphics.pop()
   
    love.graphics.setFont(font[48])
    love.graphics.print(love.timer.getFPS(), 5, 5)
	love.graphics.print('Money: '..self.money, 5, 55)
	love.graphics.print('Lives: '..self.lives, 5, 105)
	love.graphics.print('Wave: '..self.wave, 5, 155)
end

function game:loseLife()
	self.lives = self.lives - 1
	if self.lives <= 0 then
		state.switch(game)
	end
end