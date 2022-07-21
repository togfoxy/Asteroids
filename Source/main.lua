GAME_VERSION = "0.01"

inspect = require 'lib.inspect'
-- https://github.com/kikito/inspect.lua

res = require 'lib.resolution_solution'
-- https://github.com/Vovkiv/resolution_solution

Camera = require 'lib.cam11.cam11'
-- https://notabug.org/pgimeno/cam11

concord = require 'lib.concord'
-- https://github.com/Tjakka5/Concord


cf = require 'lib.commonfunctions'
enum = require 'enum'
fun = require 'functions'
constants = require 'constants'
cmp = require 'components'
ecs = require 'ecsFunctions'
ecsDraw = require 'ecsDraw'
ecsUpdate = require 'ecsUpdate'

local function establishPlayerVessel()
	-- add player
	local entity = concord.entity(ECSWORLD)
    :give("drawable")
    :give("uid")
	:give("chassis")
	:give("engine")
	:give("leftThruster")
	:give("rightThruster")
	:give("reverseThruster")
	:give("fuelTank")
	:give("miningLaser")
	:give("battery")
	:give("oxyGenerator")
	:give("oxyTank")
	:give("solarPanel")
	:give("cargoHold")
    table.insert(ECS_ENTITIES, entity)
	PLAYER.UID = entity.uid.value 		-- store this for easy recall
	-- debug
	-- entity.chassis.currentHP = 0
	local shipsize = fun.getEntitySize(entity)
	--DEBUG_VESSEL_SIZE = 10
	--shipsize = DEBUG_VESSEL_SIZE

	local physicsEntity = {}
    physicsEntity.body = love.physics.newBody(PHYSICSWORLD, PHYSICS_WIDTH / 2, (PHYSICS_HEIGHT) - 75, "dynamic")
	physicsEntity.body:setLinearDamping(0)
	-- physicsEntity.body:setMass(500)		-- kg		-- made redundant by newFixture
	physicsEntity.shape = love.physics.newRectangleShape(shipsize, shipsize)		-- will draw a rectangle around the body x/y. No need to offset it
	-- physicsEntity.shape = love.physics.newPolygonShape(PLAYER.POINTS)
	physicsEntity.fixture = love.physics.newFixture(physicsEntity.body, physicsEntity.shape, PHYSICS_DENSITY)		-- the 1 is the density
	physicsEntity.fixture:setRestitution(0.1)		-- between 0 and 1
	physicsEntity.fixture:setSensor(false)

	local temptable = {}
	temptable.uid = entity.uid.value
	temptable.objectType = "Player"

	physicsEntity.fixture:setUserData(temptable)		-- links the physics object to the ECS entity

    table.insert(PHYSICS_ENTITIES, physicsEntity)

	print("Ship mass is " .. physicsEntity.body:getMass())
	print("Ship size is " .. shipsize)
end

local function establishWorldBorders()
	-- bottom border
	local PHYSICSBORDER1 = {}
    PHYSICSBORDER1.body = love.physics.newBody(PHYSICSWORLD, 0 + (PHYSICS_WIDTH / 2), PHYSICS_HEIGHT, "static") -- x, y.  The shape comes next
    PHYSICSBORDER1.shape = love.physics.newRectangleShape(PHYSICS_WIDTH, 5) --make a rectangle with a width and a height
    PHYSICSBORDER1.fixture = love.physics.newFixture(PHYSICSBORDER1.body, PHYSICSBORDER1.shape) --attach shape to body
	PHYSICSBORDER1.fixture:setRestitution( 1 )
	local temptable = {}
	temptable.uid = cf.Getuuid()
	temptable.objectType = "Border"
	PHYSICSBORDER1.fixture:setUserData(temptable)
	-- top border
	local PHYSICSBORDER2 = {}
    PHYSICSBORDER2.body = love.physics.newBody(PHYSICSWORLD, 0 + (PHYSICS_WIDTH / 2), 0, "static") --remember, the shape (the rectangle we create next) anchors to the body from its center, so we have to move it to (650/2, 650-50/2)
    PHYSICSBORDER2.shape = love.physics.newRectangleShape(PHYSICS_WIDTH, 5) --make a rectangle with a width of 650 and a height of 50
    PHYSICSBORDER2.fixture = love.physics.newFixture(PHYSICSBORDER2.body, PHYSICSBORDER2.shape) --attach shape to body
	PHYSICSBORDER2.fixture:setRestitution( 1 )
	local temptable = {}
	temptable.uid = cf.Getuuid()
	temptable.objectType = "Border"
	PHYSICSBORDER2.fixture:setUserData(temptable)
	-- left border
	local PHYSICSBORDER3 = {}
    PHYSICSBORDER3.body = love.physics.newBody(PHYSICSWORLD, 0, 0 + (PHYSICS_HEIGHT / 2), "static") --remember, the shape (the rectangle we create next) anchors to the body from its center, so we have to move it to (650/2, 650-50/2)
    PHYSICSBORDER3.shape = love.physics.newRectangleShape(5, PHYSICS_HEIGHT) --make a rectangle with a width of 650 and a height of 50
    PHYSICSBORDER3.fixture = love.physics.newFixture(PHYSICSBORDER3.body, PHYSICSBORDER3.shape) --attach shape to body
	PHYSICSBORDER3.fixture:setRestitution( 1 )
	local temptable = {}
	temptable.uid = cf.Getuuid()
	temptable.objectType = "Border"
	PHYSICSBORDER3.fixture:setUserData(temptable)
	-- right border
	local PHYSICSBORDER4 = {}
    PHYSICSBORDER4.body = love.physics.newBody(PHYSICSWORLD, PHYSICS_WIDTH, 0 + (PHYSICS_HEIGHT / 2), "static") --remember, the shape (the rectangle we create next) anchors to the body from its center, so we have to move it to (650/2, 650-50/2)
    PHYSICSBORDER4.shape = love.physics.newRectangleShape(5, PHYSICS_HEIGHT) --make a rectangle with a width of 650 and a height of 50
    PHYSICSBORDER4.fixture = love.physics.newFixture(PHYSICSBORDER4.body, PHYSICSBORDER4.shape) --attach shape to body
	PHYSICSBORDER4.fixture:setRestitution( 1 )
	local temptable = {}
	temptable.uid = cf.Getuuid()
	temptable.objectType = "Border"
	PHYSICSBORDER4.fixture:setUserData(temptable)

	table.insert(PHYSICS_ENTITIES, PHYSICSBORDER1)
	table.insert(PHYSICS_ENTITIES, PHYSICSBORDER2)
	table.insert(PHYSICS_ENTITIES, PHYSICSBORDER3)
	table.insert(PHYSICS_ENTITIES, PHYSICSBORDER4)
end

local function establishPhysicsWorld()
	love.physics.setMeter(1)
	PHYSICSWORLD = love.physics.newWorld(0,0,false)
	PHYSICSWORLD:setCallbacks(beginContact,_,_,postSolve)

	establishWorldBorders()

	-- add starbase
	local starbase = {}
	starbase.body = love.physics.newBody(PHYSICSWORLD, PHYSICS_WIDTH / 2, (PHYSICS_HEIGHT) - 35, "static")
	-- physicsEntity.body:setLinearDamping(0)
	starbase.body:setMass(5000)

	starbase.shape = love.physics.newPolygonShape(-250,-25,250,-25,250,25,-250,25)

	starbase.fixture = love.physics.newFixture(starbase.body, starbase.shape) --attach shape to body
	starbase.fixture:setRestitution(0)		-- between 0 and 1
	starbase.fixture:setSensor(false)
	local temptable = {}
	temptable.uid = cf.Getuuid()
	temptable.objectType = "Starbase"
	starbase.fixture:setUserData(temptable)

	table.insert(PHYSICS_ENTITIES, starbase)

	establishPlayerVessel()
end

local function drawStarbase()
	love.graphics.setColor(100/256,87/256,188/256,1)
	local x1, y1, x2, y2, x3, y3, x4, y4

	local drawx, drawy

	for i = 1, (#PHYSICS_ENTITIES) do
		local udtable = PHYSICS_ENTITIES[i].fixture:getUserData()
		if udtable.objectType == "Starbase" then
			-- have located the starbase physics object
			drawx, drawy = PHYSICS_ENTITIES[i].body:getPosition()

			for _, fixture in pairs(PHYSICS_ENTITIES[i].body:getFixtures()) do
				local shape = fixture:getShape()
				if shape:typeOf("CircleShape") then
					local drawx, drawy = body:getWorldPoints(shape:getPoint())
					drawx = drawx * BOX2D_SCALE
					drawy = drawy * BOX2D_SCALE
					local radius = shape:getRadius()
					radius = radius * BOX2D_SCALE
					love.graphics.setColor(1, 0, 0, 1)
					love.graphics.circle("line", drawx, drawy, radius)
					love.graphics.setColor(1, 1, 1, 1)
					love.graphics.print("r:" .. cf.round(radius,2), drawx + 7, drawy - 3)
				elseif shape:typeOf("PolygonShape") then     -- currently only works on four points (square and rectangle)
					x1, y1, x2, y2, x3, y3, x4, y4 = PHYSICS_ENTITIES[i].body:getWorldPoints(shape:getPoints())
					x1 = x1 * BOX2D_SCALE
					y1 = y1 * BOX2D_SCALE
					x2 = x2 * BOX2D_SCALE
					y2 = y2 * BOX2D_SCALE
					x3 = x3 * BOX2D_SCALE
					y3 = y3 * BOX2D_SCALE
					x4 = x4 * BOX2D_SCALE
					y4 = y4 * BOX2D_SCALE
					-- love.graphics.setColor(1, 0, 0, 1)
					love.graphics.polygon("line", x1, y1, x2, y2, x3, y3, x4, y4)
				else
					love.graphics.line(body:getWorldPoints(shape:getPoints()))
					error("This physics object needs to be scaled before drawing")
				end
			end
		end
	end

	-- get starbase x/y
	drawx = drawx * BOX2D_SCALE
	drawy = drawy * BOX2D_SCALE

	love.graphics.setFont(FONT[enum.fontHeavyMetalLarge])
    love.graphics.setColor(1,1,1,1)
	love.graphics.printf("STARBASE SAFE HAVEN", drawx - 750, drawy - 25, 1000, "left", 0, 7, 7)		--! test this on other resolutions

	-- draw the safezone
	local x1, y1, x2, y2		-- intentionally declared again to clear the old value
	x1 = 0
	y1 = (PHYSICS_HEIGHT - PHYSICS_SAFEZONE) * BOX2D_SCALE
	x2 = PHYSICS_WIDTH * BOX2D_SCALE
	y2 = y1
	love.graphics.line(x1,y1,x2,y2)
end

local function drawAsteroids()

	for k, obj in pairs(PHYSICS_ENTITIES) do
		local udtable = obj.fixture:getUserData()
		if udtable.objectType == "Asteroid" then
			local body = obj.body
			local mass = cf.round(body:getMass())
			local x0, y0 = body:getPosition()
			for _, fixture in pairs(body:getFixtures()) do
				local shape = fixture:getShape()
				local points = {body:getWorldPoints(shape:getPoints())}
				for i = 1, #points do
					points[i] = points[i] * BOX2D_SCALE
				end

				if udtable.isSelected then
					love.graphics.setColor(0, 1, 1, 1)
				else
					love.graphics.setColor(139/255,139/255,139/255,1)
				end
				love.graphics.polygon("line", points)

				-- print the mass for debug reasons
				love.graphics.setColor(1,1,1,1)
				love.graphics.print(cf.round(obj.currentMass), (x0 * BOX2D_SCALE) + 15, (y0 * BOX2D_SCALE) - 15)

			end
		end
	end
end

function beginContact(a, b, coll)
end

function postSolve(a, b, coll, normalimpulse, tangentimpulse)

	-- a is the first fixture
	-- b is the second fixture
	-- coll is a contact objects

	local entity1, entity2
	local udtable1 = a:getUserData()
	local udtable2 = b:getUserData()

	local uid1 = udtable1.uid
	local uid2 = udtable2.uid

	if udtable1.objectType == "Border" or udtable2.objectType == "Border" then
		-- collision is with border. Do nothing.
	elseif udtable1.objectType == "Starbase" or udtable2.objectType == "Starbase" then
		--! do something
	else
		physicsEntity1 = fun.getPhysEntity(uid1)
		physicsEntity2 = fun.getPhysEntity(uid2)
		assert(physicsEntity1 ~= nil)
		assert(physicsEntity2 ~= nil)

		local mass1 = physicsEntity1.body:getMass( )
		local mass2 = physicsEntity2.body:getMass( )
		local totalmass = mass1 + mass2
		local rndnum = love.math.random(1, totalmass)
		if rndnum <= mass1 then
			-- damage object1
			if udtable1.objectType == "Player" then
				local entity = fun.getEntity(uid1)
				local component = fun.getRandomComponent(entity)

				print(component.label)

				component.currentHP = component.currentHP - normalimpulse
				if component.currentHP <= 0 then
					component.currentHP = 0
				end
			end
		else
			-- damage object2
			if udtable2.objectType == "Player" then
				local entity = fun.getEntity(uid2)
				local component = fun.getRandomComponent(entity)

				print(component.label)

				component.currentHP = component.currentHP - normalimpulse
				if component.currentHP <= 0 then
					component.currentHP = 0
				end
			end
		end
	end
end

function love.keyreleased( key, scancode )
	if key == "escape" then
		cf.RemoveScreen(SCREEN_STACK)
	end
	if key == "kp5" then
		local x1, y1 = fun.getPhysEntityXY(PLAYER.UID)
		TRANSLATEX = (x1 * BOX2D_SCALE)
		TRANSLATEY = (y1 * BOX2D_SCALE)
	    ZOOMFACTOR = 0.4
	end
end

function love.keypressed( key, scancode, isrepeat )

	local translatefactor = 5 * (ZOOMFACTOR * 2)		-- screen moves faster when zoomed in

	local leftpressed = love.keyboard.isDown("left")
	local rightpressed = love.keyboard.isDown("right")
	local uppressed = love.keyboard.isDown("up")
	local downpressed = love.keyboard.isDown("down")
	local shiftpressed = love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift")	-- either shift key will work

	-- adjust translatex/y based on keypress combinations
	if shiftpressed then translatefactor = translatefactor * 2 end	-- ensure this line is above the lines below
	if leftpressed then TRANSLATEX = TRANSLATEX - translatefactor end
	if rightpressed then TRANSLATEX = TRANSLATEX + translatefactor end
	if uppressed then TRANSLATEY = TRANSLATEY - translatefactor end
	if downpressed then TRANSLATEY = TRANSLATEY + translatefactor end
end

function love.wheelmoved(x, y)
	if y > 0 then
		-- wheel moved up. Zoom in
		ZOOMFACTOR = ZOOMFACTOR + 0.1
	end
	if y < 0 then
		ZOOMFACTOR = ZOOMFACTOR - 0.1
	end
	if ZOOMFACTOR < 0.1 then ZOOMFACTOR = 0.1 end
	--if ZOOMFACTOR > 4 then ZOOMFACTOR = 4 end
	print("Zoom factor is now ".. ZOOMFACTOR)
end

function love.mousepressed( x, y, button, istouch, presses )

	local wx,wy = cam:toWorld(x, y)	-- converts screen x/y to world x/y

	if button == 1 then

	end
end

function love.mousemoved( x, y, dx, dy, istouch )
	if love.mouse.isDown(3) then
		TRANSLATEX = TRANSLATEX - (dx * 3)
		TRANSLATEY = TRANSLATEY - (dy * 3)
	end
end

function love.load()

	constants.load()

	res.setGame(SCREEN_WIDTH, SCREEN_HEIGHT)

    if love.filesystem.isFused( ) then
        void = love.window.setMode(SCREEN_WIDTH, SCREEN_HEIGHT,{fullscreen=false,display=1,resizable=true, borderless=false})	-- display = monitor number (1 or 2)
        gbolDebug = false
    else
        void = love.window.setMode(SCREEN_WIDTH, SCREEN_HEIGHT,{fullscreen=false,display=1,resizable=true, borderless=false})	-- display = monitor number (1 or 2)
    end

	love.window.setTitle("Asteroids " .. GAME_VERSION)
	love.keyboard.setKeyRepeat(true)

	cf.AddScreen("Asteroids", SCREEN_STACK)

	-- create the world
    ECSWORLD = concord.world()
	ecsFunctions.init()
	fun.loadAudio()
	fun.loadImages()
	fun.loadFonts()
	establishPhysicsWorld()

	for i = 1, NUMBER_OF_ASTEROIDS do
		fun.createAsteroid()
	end

	local x1, y1 = fun.getPhysEntityXY(PLAYER.UID)
	cam = Camera.new(x1, y1, 1)

	TRANSLATEX = (x1 * BOX2D_SCALE)
	TRANSLATEY = (y1 * BOX2D_SCALE)
    ZOOMFACTOR = 0.4

end

function love.draw()

    res.start()

	if cf.currentScreenName(SCREEN_STACK) == "Asteroids" then
		cam:attach()
		love.graphics.setColor(1,1,1,1)
		love.graphics.draw(IMAGES[enum.imagesBackgroundStatic], 0, 0, 0, 5.24, 10)
		ECSWORLD:emit("draw")

		-- background
		drawStarbase()
		drawAsteroids()
		-- cf.printAllPhysicsObjects(PHYSICSWORLD, BOX2D_SCALE)
		cam:detach()

		love.graphics.setColor(1,1,1,DEAD_ALPHA)
		love.graphics.draw(IMAGES[enum.imagesDead], 0, 0)

	elseif cf.currentScreenName(SCREEN_STACK) == "Dead" then

		love.graphics.setColor(1,1,1,1)
		love.graphics.setFont(FONT[enum.fontDefault])
		love.graphics.print("You ded", 1000, 500)

		TRANSLATEX = SCREEN_WIDTH / 2
		TRANSLATEY = SCREEN_HEIGHT / 2
		ZOOMFACTOR = 0.4
	end
    res.stop()
end

function love.update(dt)

	if cf.currentScreenName(SCREEN_STACK) == "Asteroids" then

		SOUND = {}		-- a global that is updated during update calls and then reset at the start of each dt
		DRAW = {}

		ECSWORLD:emit("update", dt)
		PHYSICSWORLD:update(dt) --this puts the world into motion

		if SOUND.engine then
			AUDIO[enum.audioEngine]:play()
		else
			AUDIO[enum.audioEngine]:stop()
		end
		if SOUND.lowFuel then
			AUDIO[enum.audioLowFuel]:play()
		else
			AUDIO[enum.audioLowFuel]:stop()
		end
		if SOUND.warning then
			AUDIO[enum.audioWarning]:play()
		else
			AUDIO[enum.audioWarning]:stop()
		end
		if SOUND.miningLaser then
			AUDIO[enum.audioMiningLaser]:play()
		else
			AUDIO[enum.audioMiningLaser]:stop()
		end
		if SOUND.rockExplosion then
			AUDIO[enum.audioRockExplosion]:play()
		else
			--AUDIO[enum.audioRockExplosion]:play()
		end

		-- check for dead chassis
		fun.checkIfDead(dt)

		--! check for dead or empty o2 tank
		

		cam:setPos(TRANSLATEX, TRANSLATEY)
		cam:setZoom(ZOOMFACTOR)
	end

	res.update()
end
