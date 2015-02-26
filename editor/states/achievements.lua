achievements = {}

local activeAchievement = 1

local achievementsList = {}
table.insert(achievementsList, {name = "test1", description = "basic achievement", criteria = {}})
table.insert(achievementsList, {name = "test2", description = "do something awesome", criteria = {}})
table.insert(achievementsList, {name = "loser", description = "win the game!", criteria = {}})
table.insert(achievementsList, {name = "test1", description = "basic achievement", criteria = {}})
table.insert(achievementsList, {name = "test1", description = "basic achievement", criteria = {}})
table.insert(achievementsList, {name = "achievement master", description = "create better achievements", criteria = {}})
table.insert(achievementsList, {name = "hi", description = "start the game", criteria = {}})

function achievements:enter()
	
end

function achievements:draw()
	local yAdd = 0
    for i = 1, #achievementsList do
		love.graphics.setColor(255, 255, 255)
		if i == 3 or i == 5 then
			love.graphics.setColor(100, 100, 100)
		end
		local name = achievementsList[i].name
		local description = achievementsList[i].description
		love.graphics.print(name, 0, i*70-70+yAdd)
		if i == activeAchievement then
			love.graphics.print(description, 30, i*70-20+yAdd)
			yAdd = 50
		end
	end
end

function achievements:keypressed(key, isrepeat)
    if key == "q" then
		state.switch(game)
	end
	
	if key == "w" then
		if activeAchievement > 1 then
			activeAchievement = activeAchievement - 1
		end
	elseif key == "s" then
		if activeAchievement < #achievementsList then
			activeAchievement = activeAchievement + 1
		end
	end
end

return achievements