tileTypes = {}

-- Tags: character, stair, roof, item, enemy, roof, wall, nowalk, nobuild, selector


-- Regular Tiles --

plainTile = {image = love.graphics.newImage("img/Plain Block.png"), tags = {"tile"}}
table.insert(tileTypes, plainTile)

dirtTile = {image = love.graphics.newImage("img/Dirt Block.png"), tags = {"tile"}}
table.insert(tileTypes, dirtTile)

grassTile = {image = love.graphics.newImage("img/Grass Block.png"), tags = {"tile"}}
table.insert(tileTypes, grassTile)

stoneTile = {image = love.graphics.newImage("img/Stone Block.png"), tags = {"tile"}}
table.insert(tileTypes, stoneTile)

woodTile = {image = love.graphics.newImage("img/Wood Block.png"), tags = {"tile"}}
table.insert(tileTypes, woodTile)

brownTile = {image = love.graphics.newImage("img/Brown Block.png"), tags = {"tile"}}
table.insert(tileTypes, brownTile)

waterTile = {image = love.graphics.newImage("img/Water Block.png"), tags = {"tile"}}
table.insert(tileTypes, waterTile)


-- Stairs --

rampEastTile = {image = love.graphics.newImage("img/Ramp East.png"), tags = {"stair"}}
table.insert(tileTypes, rampEastTile)

rampNorthTile = {image = love.graphics.newImage("img/Ramp North.png"), tags = {"stair"}}
table.insert(tileTypes, rampNorthTile)

rampSouthTile = {image = love.graphics.newImage("img/Ramp South.png"), tags = {"stair"}}
table.insert(tileTypes, rampSouthTile)

rampWestTile = {image = love.graphics.newImage("img/Ramp West.png"), tags = {"stair"}}
table.insert(tileTypes, rampWestTile)



-- Enemies --

enemyBug = {image = love.graphics.newImage("img/Enemy Bug.png"), tags = {"enemy", "nobuild"}}
table.insert(tileTypes, enemyBug)


-- Misc --

chestClosed = {image = love.graphics.newImage("img/Chest Closed.png"), tags = {"nobuild"}}
table.insert(tileTypes, chestClosed)

chestLid = {image = love.graphics.newImage("img/Chest Lid.png"), tags = {"nobuild"}}
table.insert(tileTypes, chestLid)

chestOpen = {image = love.graphics.newImage("img/Chest Open.png"), tags = {"nobuild"}}
table.insert(tileTypes, chestOpen)

doorTallClosed = {image = love.graphics.newImage("img/Door Tall Closed.png"), tags = {"nobuild"}}
table.insert(tileTypes, doorTallClosed)

doorTallOpen = {image = love.graphics.newImage("img/Door Tall Open.png"), tags = {"nobuild"}}
table.insert(tileTypes, doorTallOpen)


-- Items --

gemBlue = {image = love.graphics.newImage("img/Gem Blue.png"), tags = {"item", "nobuild"}}
table.insert(tileTypes, gemBlue)

gemGreen = {image = love.graphics.newImage("img/Gem Green.png"), tags = {"item", "nobuild"}}
table.insert(tileTypes, gemGreen)

gemOrange = {image = love.graphics.newImage("img/Gem Orange.png"), tags = {"item", "nobuild"}}
table.insert(tileTypes, gemOrange)

heart = {image = love.graphics.newImage("img/Heart.png"), tags = {"item", "nobuild"}}
table.insert(tileTypes, heart)

key = {image = love.graphics.newImage("img/Key.png"), tags = {"item", "nobuild"}}
table.insert(tileTypes, key)

rock = {image = love.graphics.newImage("img/Rock.png"), tags = {"item", "nobuild"}}
table.insert(tileTypes, rock)


-- Roof --

roofEast = {image = love.graphics.newImage("img/Roof East.png"), tags = {"roof", "nobuild"}}
table.insert(tileTypes, roofEast)

roofNorthEast = {image = love.graphics.newImage("img/Roof North East.png"), tags = {"roof", "nobuild"}}
table.insert(tileTypes, roofNorthEast)

roofNorthWest = {image = love.graphics.newImage("img/Roof North West.png"), tags = {"roof", "nobuild"}}
table.insert(tileTypes, roofNorthWest)

roofNorth = {image = love.graphics.newImage("img/Roof North.png"), tags = {"roof", "nobuild"}}
table.insert(tileTypes, roofNorth)

roofSouthEast = {image = love.graphics.newImage("img/Roof South East.png"), tags = {"roof", "nobuild"}}
table.insert(tileTypes, roofSouthEast)

roofSouthWest = {image = love.graphics.newImage("img/Roof South West.png"), tags = {"roof", "nobuild"}}
table.insert(tileTypes, roofSouthWest)

roofSouth = {image = love.graphics.newImage("img/Roof South.png"), tages = {"roof", "nobuild"}}
table.insert(tileTypes, roofSouth)

roofWest = {image = love.graphics.newImage("img/Roof West.png"), tags = {"roof", "nobuild"}}
table.insert(tileTypes, roofWest)


-- More Misc --

selector = {image = love.graphics.newImage("img/Selector.png"), tags = {"selector", "nobuild"}}
table.insert(tileTypes, selector)

star = {image = love.graphics.newImage("img/Star.png"), tags = {"item", "nobuild"}}
table.insert(tileTypes, star)

stoneBlockTall = {image = love.graphics.newImage("img/Stone Block Tall.png"), tags = {"nobuild"}}
table.insert(tileTypes, stoneBlockTall)

treeShort = {image = love.graphics.newImage("img/Tree Short.png"), tags = {"nobuild"}}
table.insert(tileTypes, treeShort)

treeTall = {image = love.graphics.newImage("img/Tree Tall.png"), tags = {"nobuild"}}
table.insert(tileTypes, treeTall)

treeUgly = {image = love.graphics.newImage("img/Tree Ugly.png"), tags = {"nobuild"}}
table.insert(tileTypes, treeUgly)

wallBlockTall = {image = love.graphics.newImage("img/Wall Block Tall.png"), tags = {"nobuild"}}
table.insert(tileTypes, wallBlockTall)

wallBlock = {image = love.graphics.newImage("img/Wall Block.png"), tags = {"nobuild"}}
table.insert(tileTypes, wallBlock)

windowTall = {image = love.graphics.newImage("img/Window Tall.png"), tags = { }}
table.insert(tileTypes, windowTall)

-- Characters --

characterBoy = {image = love.graphics.newImage("img/Character Boy.png"), tags = {"character"}}
table.insert(tileTypes, characterBoy)

characterCatGirl = {image = love.graphics.newImage("img/Character Cat Girl.png"), tags = {"character"}}
table.insert(tileTypes, characterCatGirl)

characterHornGirl = {image = love.graphics.newImage("img/Character Horn Girl.png"), tags = {"character"}}
table.insert(tileTypes, characterHornGirl)

characterPinkGirl = {image = love.graphics.newImage("img/Character Pink Girl.png"), tags = {"character"}}
table.insert(tileTypes, characterPinkGirl)

characterPrincessGirl = {image = love.graphics.newImage("img/Character Princess Girl.png"), tags = {"character"}}
table.insert(tileTypes, characterPrincessGirl)


--[[

plainTileImage = love.graphics.newImage("img/Plain Block.png")
table.insert(tileTypes, plainTileImage)
dirtTileImage = love.graphics.newImage("img/Dirt Block.png")
table.insert(tileTypes, dirtTileImage)
grassTileImage = love.graphics.newImage("img/Grass Block.png")
table.insert(tileTypes, grassTileImage)
stoneTileImage = love.graphics.newImage("img/Stone Block.png")
table.insert(tileTypes, stoneTileImage)
rampEastTileImage = love.graphics.newImage("img/Ramp East.png")
table.insert(tileTypes, rampEastTileImage)
rampNorthTileImage = love.graphics.newImage("img/Ramp North.png")
table.insert(tileTypes, rampNorthTileImage)
rampSouthTileImage = love.graphics.newImage("img/Ramp South.png")
table.insert(tileTypes, rampSouthTileImage)
rampWestTileImage = love.graphics.newImage("img/Ramp West.png")
table.insert(tileTypes, rampWestTileImage)
waterTileImage = love.graphics.newImage("img/Water Block.png")
table.insert(tileTypes, waterTileImage)
woodTileImage = love.graphics.newImage("img/Wood Block.png")
table.insert(tileTypes, woodTileImage)
brownTileImage = love.graphics.newImage("img/Brown Block.png")
table.insert(tileTypes, brownTileImage)

chestClosedImage = love.graphics.newImage("img/Chest Closed.png")
table.insert(tileTypes, chestClosedImage)
chestLidImage = love.graphics.newImage("img/Chest Lid.png")
table.insert(tileTypes, chestLidImage)
chestOpenImage = love.graphics.newImage("img/Chest Open.png")
table.insert(tileTypes, chestOpenImage)
doorTallClosedImage = love.graphics.newImage("img/Door Tall Closed.png")
table.insert(tileTypes, doorTallClosedImage)
doorTallOpenImage = love.graphics.newImage("img/Door Tall Open.png")
table.insert(tileTypes, doorTallOpenImage)
enemyBugImage = love.graphics.newImage("img/Enemy Bug.png")
table.insert(tileTypes, enemyBugImage)
gemBlueImage = love.graphics.newImage("img/Gem Blue.png")
table.insert(tileTypes, gemBlueImage)
gemGreenImage = love.graphics.newImage("img/Gem Green.png")
table.insert(tileTypes, gemGreenImage)
gemOrangeImage = love.graphics.newImage("img/Gem Orange.png")
table.insert(tileTypes, gemOrangeImage)
heartImage = love.graphics.newImage("img/Heart.png")
table.insert(tileTypes, heartImage)
keyImage = love.graphics.newImage("img/Key.png")
table.insert(tileTypes, keyImage)
rockImage = love.graphics.newImage("img/Rock.png")
table.insert(tileTypes, rockImage)
roofEastImage = love.graphics.newImage("img/Roof East.png")
table.insert(tileTypes, roofEastImage)
roofNorthEastImage = love.graphics.newImage("img/Roof North East.png")
table.insert(tileTypes, roofNorthEastImage)
roofNorthWestImage = love.graphics.newImage("img/Roof North West.png")
table.insert(tileTypes, roofNorthWestImage)
roofNorthImage = love.graphics.newImage("img/Roof North.png")
table.insert(tileTypes, roofNorthImage)
roofSouthEastImage = love.graphics.newImage("img/Roof South East.png")
table.insert(tileTypes, roofSouthEastImage)
roofSouthWestImage = love.graphics.newImage("img/Roof South West.png")
table.insert(tileTypes, roofSouthWestImage)
roofSouthImage = love.graphics.newImage("img/Roof South.png")
table.insert(tileTypes, roofSouthImage)
roofWestImage = love.graphics.newImage("img/Roof West.png")
table.insert(tileTypes, roofWestImage)
selectorImage = love.graphics.newImage("img/Selector.png")
table.insert(tileTypes, selectorImage)
starImage = love.graphics.newImage("img/Star.png")
table.insert(tileTypes, starImage)
stoneBlockTallImage = love.graphics.newImage("img/Stone Block Tall.png")
table.insert(tileTypes, stoneBlockTallImage)
treeShortImage = love.graphics.newImage("img/Tree Short.png")
table.insert(tileTypes, treeShortImage)
treeTallImage = love.graphics.newImage("img/Tree Tall.png")
table.insert(tileTypes, treeTallImage)
treeUglyImage = love.graphics.newImage("img/Tree Ugly.png")
table.insert(tileTypes, treeUglyImage)
wallBlockTallImage = love.graphics.newImage("img/Wall Block Tall.png")
table.insert(tileTypes, wallBlockTallImage)
wallBlockImage = love.graphics.newImage("img/Wall Block.png")
table.insert(tileTypes, wallBlockImage)
windowTallImage = love.graphics.newImage("img/Window Tall.png")
table.insert(tileTypes, windowTallImage)

]]
return tileTypes