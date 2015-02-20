game = {}

function game:enter()
	love.graphics.setBackgroundColor(99, 191, 212)

    self.camera = {x = 0, y = 0, speed = 10}
	self.map = Map:new(10, 10)
	
	self.enemies = {}
	
	self.timer = 0
	self.timeStep = 4
end

function game:update(dt)
	self.timer = self.timer + dt
	if self.timer > self.timeStep then
		self.timer = 0
		table.insert(self.enemies, Enemy:new())
	end

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
	
	
	for k, enemy in pairs(self.enemies) do
		enemy:update(dt)
	end
	
	for i = #self.enemies, 1, -1 do
		local enemy = self.enemies[i]
		if enemy.delete then
			table.remove(self.enemies, i)
		end
	end
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
end

function game:draw()
	love.graphics.push()
	love.graphics.translate(self.camera.x, self.camera.y)

	self.map:draw()
	
	for k, enemy in pairs(self.enemies) do
		enemy:draw()
	end
	
	love.graphics.pop()
   
    love.graphics.setFont(font[48])
    love.graphics.print(love.timer.getFPS(), x, y)
end