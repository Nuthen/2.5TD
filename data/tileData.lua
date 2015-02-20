tileTypes = {}

-- tag: character, stair, roof, item, enemy, roof, wall, nowalk, nobuild, selector


-- Regular Tiles --

plainTile = {image = love.graphics.newImage("img/Plain Block.png"), tag = "tile"}
table.insert(tileTypes, plainTile)

dirtTile = {image = love.graphics.newImage("img/Dirt Block.png"), tag = "tile"}
table.insert(tileTypes, dirtTile)

grassTile = {image = love.graphics.newImage("img/Grass Block.png"), tag = "tile"}
table.insert(tileTypes, grassTile)

stoneTile = {image = love.graphics.newImage("img/Stone Block.png"), tag = "tile"}
table.insert(tileTypes, stoneTile)

woodTile = {image = love.graphics.newImage("img/Wood Block.png"), tag = "tile"}
table.insert(tileTypes, woodTile)

brownTile = {image = love.graphics.newImage("img/Brown Block.png"), tag = "tile"}
table.insert(tileTypes, brownTile)

waterTile = {image = love.graphics.newImage("img/Water Block.png"), tag = "tile"}
table.insert(tileTypes, waterTile)


-- Stairs --

rampEastTile = {image = love.graphics.newImage("img/Ramp East.png"), tag = "stair"}
table.insert(tileTypes, rampEastTile)

rampNorthTile = {image = love.graphics.newImage("img/Ramp North.png"), tag = "stair"}
table.insert(tileTypes, rampNorthTile)

rampSouthTile = {image = love.graphics.newImage("img/Ramp South.png"), tag = "stair"}
table.insert(tileTypes, rampSouthTile)

rampWestTile = {image = love.graphics.newImage("img/Ramp West.png"), tag = "stair"}
table.insert(tileTypes, rampWestTile)



-- Enemies --

enemyBug = {image = love.graphics.newImage("img/Enemy Bug.png"), tag = "enemy"}
table.insert(tileTypes, enemyBug)


-- Misc --

chestClosed = {image = love.graphics.newImage("img/Chest Closed.png"), tag = "misc"}
table.insert(tileTypes, chestClosed)

chestLid = {image = love.graphics.newImage("img/Chest Lid.png"), tag = "misc"}
table.insert(tileTypes, chestLid)

chestOpen = {image = love.graphics.newImage("img/Chest Open.png"), tag = "misc"}
table.insert(tileTypes, chestOpen)

doorTallClosed = {image = love.graphics.newImage("img/Door Tall Closed.png"), tag = "misc"}
table.insert(tileTypes, doorTallClosed)

doorTallOpen = {image = love.graphics.newImage("img/Door Tall Open.png"), tag = "misc"}
table.insert(tileTypes, doorTallOpen)


-- Items --

gemBlue = {image = love.graphics.newImage("img/Gem Blue.png"), tag = {"item", "nobuild"}}
table.insert(tileTypes, gemBlue)

gemGreen = {image = love.graphics.newImage("img/Gem Green.png"), tag = {"item", "nobuild"}}
table.insert(tileTypes, gemGreen)

gemOrange = {image = love.graphics.newImage("img/Gem Orange.png"), tag = {"item", "nobuild"}}
table.insert(tileTypes, gemOrange)

heart = {image = love.graphics.newImage("img/Heart.png"), tag = {"item", "nobuild"}}
table.insert(tileTypes, heart)

key = {image = love.graphics.newImage("img/Key.png"), tag = {"item", "nobuild"}}
table.insert(tileTypes, key)

rock = {image = love.graphics.newImage("img/Rock.png"), tag = {"item", "nobuild"}}
table.insert(tileTypes, rock)


-- Roof --

roofEast = {image = love.graphics.newImage("img/Roof East.png"), tag = "roof"}
table.insert(tileTypes, roofEast)

roofNorthEast = {image = love.graphics.newImage("img/Roof North East.png"), tag = "roof"}
table.insert(tileTypes, roofNorthEast)

roofNorthWest = {image = love.graphics.newImage("img/Roof North West.png"), tag = "roof"}
table.insert(tileTypes, roofNorthWest)

roofNorth = {image = love.graphics.newImage("img/Roof North.png"), tag = "roof"}
table.insert(tileTypes, roofNorth)

roofSouthEast = {image = love.graphics.newImage("img/Roof South East.png"), tag = "roof"}
table.insert(tileTypes, roofSouthEast)

roofSouthWest = {image = love.graphics.newImage("img/Roof South West.png"), tag = "roof"}
table.insert(tileTypes, roofSouthWest)

roofSouth = {image = love.graphics.newImage("img/Roof South.png"), tages = "roof"}
table.insert(tileTypes, roofSouth)

roofWest = {image = love.graphics.newImage("img/Roof West.png"), tag = "roof"}
table.insert(tileTypes, roofWest)


-- More Misc --

selector = {image = love.graphics.newImage("img/Selector.png"), tag = "misc"}
table.insert(tileTypes, selector)

star = {image = love.graphics.newImage("img/Star.png"), tag = "misc"}
table.insert(tileTypes, star)

stoneBlockTall = {image = love.graphics.newImage("img/Stone Block Tall.png"), tag = "misc"}
table.insert(tileTypes, stoneBlockTall)

treeShort = {image = love.graphics.newImage("img/Tree Short.png"), tag = "misc"}
table.insert(tileTypes, treeShort)

treeTall = {image = love.graphics.newImage("img/Tree Tall.png"), tag = "misc"}
table.insert(tileTypes, treeTall)

treeUgly = {image = love.graphics.newImage("img/Tree Ugly.png"), tag = "misc"}
table.insert(tileTypes, treeUgly)

wallBlockTall = {image = love.graphics.newImage("img/Wall Block Tall.png"), tag = "misc"}
table.insert(tileTypes, wallBlockTall)

wallBlock = {image = love.graphics.newImage("img/Wall Block.png"), tag = "misc"}
table.insert(tileTypes, wallBlock)

windowTall = {image = love.graphics.newImage("img/Window Tall.png"), tag = "misc"}
table.insert(tileTypes, windowTall)


-- Characters --

characterBoy = {image = love.graphics.newImage("img/Character Boy.png"), tag = "character"}
table.insert(tileTypes, characterBoy)

characterCatGirl = {image = love.graphics.newImage("img/Character Cat Girl.png"), tag = "character"}
table.insert(tileTypes, characterCatGirl)

characterHornGirl = {image = love.graphics.newImage("img/Character Horn Girl.png"), tag = "character"}
table.insert(tileTypes, characterHornGirl)

characterPinkGirl = {image = love.graphics.newImage("img/Character Pink Girl.png"), tag = "character"}
table.insert(tileTypes, characterPinkGirl)

characterPrincessGirl = {image = love.graphics.newImage("img/Character Princess Girl.png"), tag = "character"}
table.insert(tileTypes, characterPrincessGirl)



return tileTypes