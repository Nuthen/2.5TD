-- libraries
class = require 'libs.middleclass'
vector = require 'libs.vector'
state = require 'libs.state'
tween = require 'libs.tween'

-- global libraries (the names within shouldn't change)
require 'libs.util'
require 'libs.tablestring'

-- gamestates
require 'states.menu'
require 'states.game'
require 'states.achievements'

--entities
map = require 'entities.map'
character = require 'entities.characters'
selector = require 'entities.selector'

function love.load()
	love.window.setTitle(config.windowTitle)
    love.window.setIcon(love.image.newImageData(config.windowIcon))
	love.graphics.setDefaultFilter(config.filterModeMin, config.filterModeMax, config.anisotropy)
    love.graphics.setFont(font[14])

    math.randomseed(os.time()/10)

    state.registerEvents()
    state.switch(menu)
end