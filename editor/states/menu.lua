menu = {}

menuBackgroundSource = love.audio.newSource("sounds/MenuTheme.wav", "stream")
menuBackgroundSource:setVolume(0.7)

function menu:enter()
	menuBackgroundSource:setLooping(true)
	--love.audio.play(menuBackgroundSource)
end

function menu:draw()
    local text = "> ENTER <"
    local x = love.window.getWidth()/2 - fontBold[48]:getWidth(text)/2
    local y = love.window.getHeight()/2
    love.graphics.setFont(fontBold[48])
    love.graphics.print(text, x, y)
end

function menu:keyreleased(key, code)
    if key == 'return' then
        state.switch(game)
    end
end