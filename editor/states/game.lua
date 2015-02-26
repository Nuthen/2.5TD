game = {}

camera = {x = 0, y = 0, speed = 10}

backgroundImage = love.graphics.newImage("img/other/BackgroundImage1.png")

backgroundSource = love.audio.newSource("sounds/Opening_Theme.wav", "stream")
backgroundSource:setVolume(0.7)

local editMode = true
elevationMode = true

function game:enter(lastState)
	love.graphics.setBackgroundColor(17, 240, 225)
	
	if lastState == menu then
		map:create(10, 10, 0)
		
		menuBackgroundSource:stop()
		--backgroundSource:setLooping(true)
		--love.audio.play(backgroundSource)
	end
end

function game:update(dt)
	tween.update(dt)

	if editMode then
		local dx, dy = 0, 0
		if love.keyboard.isDown("up") then--or love.keyboard.isDown("w") then
			dy = camera.speed
		elseif love.keyboard.isDown("down") then--or love.keyboard.isDown("s") then
			dy = -camera.speed
		end
		if love.keyboard.isDown("left") then--or love.keyboard.isDown("a") then
			dx = camera.speed
		elseif love.keyboard.isDown("right") then--or love.keyboard.isDown("d") then
			dx = -camera.speed
		end
		if dx ~= 0 or dy ~= 0 then
			if dx ~= 0 and dy ~= 0 then
				-- This is to make diagonal camera movement the same speed as vertical and horizontal
				camera.x = camera.x + dx * 1/math.sqrt(2)
				camera.y = camera.y + dy * 1/math.sqrt(2)
			else
				camera.x = camera.x + dx
				camera.y = camera.y + dy
			end
		end
	end
	
	character:update(dt)
end

function game:keypressed(key)
	if key == "f3" then
		editMode = toggle(editMode)
	end
	if key == "f2" then
		elevationMode = toggle(elevationMode)
	end
	--if editMode then
		map:keypressed(key)
	--else
		--character:keypressed(key)
	--end
	
	if key == "q" then
		state.switch(achievements)
	end
	
	if key == "f5" then
		map:save()
	end
end

function game:mousepressed(mouseX, mouseY, button)
	if editMode then
		map:mousepressed(mouseX, mouseY, button)
	else
		character:mousepressed(mouseX, mouseY, button)
	end
end

function game:draw()
	love.graphics.draw(backgroundImage, 0, 0)

    --local x = love.window.getWidth()/2 - fontBold[48]:getWidth(text)/2
    --local y = love.window.getHeight()/2
    love.graphics.setFont(fontBold[48])
	
	love.graphics.push()
	love.graphics.translate(camera.x, camera.y)
	map:draw()
	character:draw()
	love.graphics.pop()
	
	local selectorWidth = 60
	for i = 1, #tileTypes do
		love.graphics.draw(tileTypes[i].image, 5+i*selectorWidth-tileSelector.value*selectorWidth+200, 50, 0, .5, .5)
	end
	love.graphics.rectangle("line", 5+tileSelector.value*selectorWidth-tileSelector.value*selectorWidth+200, 45, 50, 85)
	
	local fps = love.timer.getFPS()
	love.graphics.print(fps, 5, 5)
end