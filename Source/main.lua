GAME_VERSION = "0.01"

inspect = require 'lib.inspect'
-- https://github.com/kikito/inspect.lua

res = require 'lib.resolution_solution'
-- https://github.com/Vovkiv/resolution_solution

Camera = require 'lib.cam11.cam11'
-- https://notabug.org/pgimeno/cam11

concord = require 'lib.concord'
-- https://github.com/Tjakka5/Concord

bitser = require 'lib.bitser'
-- https://github.com/gvx/bitser

nativefs = require 'lib.nativefs'
-- https://github.com/megagrump/nativefs

lovelyToasts = require 'lib.lovelyToasts'
-- https://github.com/Loucee/Lovely-Toasts

baton = require 'lib.baton'
-- https://github.com/tesselode/baton


cf = require 'lib.commonfunctions'
enum = require 'enum'
fun = require 'functions'
draw = require 'draw'
constants = require 'constants'
cmp = require 'components'
ecs = require 'ecsFunctions'
ecsDraw = require 'ecsDraw'
ecsUpdate = require 'ecsUpdate'
fileops = require 'fileoperations'
keymaps = require 'keymaps'

local function establishPlayerVessel()
	-- add player
	local entity = concord.entity(ECSWORLD)
    :give("drawable")
    :give("uid")

	:give("chassis")
	:give("engine")
	:give("fuelTank")
	:give("miningLaser")
	:give("battery")
	:give("oxyGenerator")
	:give("cargoHold")

	-- :give("leftThruster")
	-- :give("rightThruster")
	-- :give("reverseThruster")
	-- :give("oxyTank")
	-- :give("solarPanel")
	-- :give("spaceSuit")
	-- :give("SOSBeacon")
	-- :give("Stabiliser")
	-- :give("ejectionPod")

    table.insert(ECS_ENTITIES, entity)
	PLAYER.UID = entity.uid.value 		-- store this for easy recall

	-- debug
	-- PLAYER.WEALTH = 10000
	-- entity.chassis.currentHP = 0

	local shipsize = fun.getEntitySize(entity)
	-- DEBUG_VESSEL_SIZE = 10
	-- shipsize = DEBUG_VESSEL_SIZE

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
	temptable.objectType = "Player"						-- other type is "Pod"
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
		-- go to shop
		TRANSLATEX = SCREEN_WIDTH / 2
		TRANSLATEY = SCREEN_HEIGHT / 2
		ZOOMFACTOR = 1
		local physEntity = fun.getPhysEntity(PLAYER.UID)
		local entity = fun.getEntity(PLAYER.UID)
		physEntity.body:setLinearVelocity( 0, 0)
		physEntity.fixture:setSensor(false)

		-- get credit for items in hold
		if entity:has("cargoHold") then
			if entity.cargoHold.currentHP > 0 then
				local profit = cf.round(entity.cargoHold.currentAmount)
				if PLAYER.WEALTH == nil then PLAYER.WEALTH = 0 end
				PLAYER.WEALTH = PLAYER.WEALTH + profit
				entity.cargoHold.currentAmount = 0
			end
		end

		-- refill consumerables
		local allComponents = entity:getComponents()
		for _, component in pairs(allComponents) do
			if component.capacity ~= nil then
				component.capacity = component.maxCapacity		--! check this includes space suit
			end
		end

		AUDIO[enum.audioBGSkismo]:stop()		--!  need to stop other tracks if there are any.

		local temptable = physEntity.fixture:getUserData()
		if temptable.objectType == "Pod" then
			temptable.objectType = "Player"
		end

		cf.AddScreen(enum.sceneShop, SCREEN_STACK)
	else
		-- collision with asteroids and players
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
			if udtable1.objectType == "Player" or udtable1.objectType == "Pod" then
				local entity = fun.getEntity(uid1)
				local component = fun.getRandomComponent(entity)
				component.currentHP = component.currentHP - normalimpulse
				if component.currentHP <= 0 then
					component.currentHP = 0
				end
				local rndscrape = love.math.random(1,2)
				if rndscrape == 1 then
					SOUND.scrape1 = true
				else
					SOUND.scrape2 = true
				end
			end
		else
			-- damage object2
			if udtable2.objectType == "Player" or udtable2.objectType == "Pod" then
				local entity = fun.getEntity(uid2)
				local component = fun.getRandomComponent(entity)
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

		local physEntity = fun.getPhysEntity(PLAYER.UID)
		local x1, y1 = physEntity.body:getPosition()
		if y1 > 915 then
			physEntity.body:setPosition(x1, 915)
			x1, y1 = physEntity.body:getPosition()
		end

		TRANSLATEX = (x1 * BOX2D_SCALE)
		TRANSLATEY = (y1 * BOX2D_SCALE)
		ZOOMFACTOR = 0.4

		cf.RemoveScreen(SCREEN_STACK)
	end
	if input:down("centreview") then
		local x1, y1 = fun.getPhysEntityXY(PLAYER.UID)
		TRANSLATEX = (x1 * BOX2D_SCALE)
		TRANSLATEY = (y1 * BOX2D_SCALE)
	    ZOOMFACTOR = 0.4
	end
	if key == "f6" then
		fileops.saveGame()
	end
	if key == "f7" then
		fileops.loadGame()
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

	local entity = fun.getEntity(PLAYER.UID)
	local physEntity = fun.getPhysEntity(PLAYER.UID)

	if input:down('rotateleft') and entity:has("fuelTank") and entity:has("rightThruster") and entity.rightThruster.currentHP > 0 then
		-- do nothing because the :update event has superior turning logic
	else
		if input:down('rotateleft') then
			-- rotate ccw
			physEntity.body:applyTorque(-2500)
		end
	end

	if input:down('rotateright') and entity:has("fuelTank") and entity:has("leftThruster") and entity.leftThruster.currentHP > 0 then
		-- do nothing because the :update event has superior turning logic
	else
		-- offer a very basic and slow rotation
		if input:down('rotateright') then
			-- rotate cw
			physEntity.body:applyTorque(2500)
		end
	end
end

function love.wheelmoved(x, y)
	if y > 0 then
		-- wheel moved up. Zoom in
		ZOOMFACTOR = ZOOMFACTOR + 0.1
		if ZOOMFACTOR == 0.6 then ZOOMFACTOR = 0.7 end
	end
	if y < 0 then
		ZOOMFACTOR = ZOOMFACTOR - 0.1
		if ZOOMFACTOR == 0.6 then ZOOMFACTOR = 0.5 end
	end
	if ZOOMFACTOR < 0.1 then ZOOMFACTOR = 0.1 end
	--if ZOOMFACTOR > 4 then ZOOMFACTOR = 4 end
	print("Zoom factor is now ".. ZOOMFACTOR)

	-- delete the bubbles to stop them being drawn funny on zoom change
	BUBBLE = {}
end

function love.mousepressed( x, y, button, istouch, presses )

	local wx,wy = cam:toWorld(x, y)	-- converts screen x/y to world x/y
	if button == 1 then
		if cf.currentScreenName(SCREEN_STACK) == enum.sceneShop then
			-- determine which screen button was clicked
			for i = 1, #BUTTONS do
				for j = 1, #BUTTONS[i] do
					-- do a bounding box check
					if wx >= BUTTONS[i][j].x and wx <= (BUTTONS[i][j].x + BUTTONS[i][j].width) and
						wy >= BUTTONS[i][j].y and wy <= (BUTTONS[i][j].y + BUTTONS[i][j].height) then

						local button = BUTTONS[i][j]

						-- repair items
						if button.type == enum.buttonTypeRepair then
							if PLAYER.WEALTH > 1000 then
								if button.component.currentHP ~= nil then
									button.component.currentHP = button.component.currentHP + 1000
									if button.component.currentHP > button.component.maxHP then button.component.currentHP = button.component.maxHP end
									PLAYER.WEALTH = PLAYER.WEALTH - 1000
									if PLAYER.WEALTH < 0 then PLAYER.WEALTH = 0 end
								end
							end
						end

						-- purchase items
						if button.type == enum.buttonTypeBuy then
							local entity = fun.getEntity(PLAYER.UID)
							local shopcomponentType

							for k, v in pairs(button.component) do
								if k == "__componentClass" then
									shopcomponentType = v.__name
								end
							end

							local purchaseprice = button.component.purchasePrice
							if entity:has(shopcomponentType) then		-- this is a string
								--! get a refund on old component

								if PLAYER.WEALTH >= purchaseprice then
									entity:remove(shopcomponentType)
									fun.buyComponent(entity, shopcomponentType, button.component)
									PLAYER.WEALTH = PLAYER.WEALTH - purchaseprice
									SHOP_ENTITY:remove(shopcomponentType)
									fun.changeShipPhysicsSize(entity)
									SOUND.ding = true
								else
									-- play 'fail' sound
									SOUND.wrong = true
								end
							else
								--! purchase
								--! refactor this and above
								if PLAYER.WEALTH >= purchaseprice then
									fun.buyComponent(entity, shopcomponentType, button.component)

									PLAYER.WEALTH = PLAYER.WEALTH - purchaseprice
									SHOP_ENTITY:remove(shopcomponentType)
									fun.changeShipPhysicsSize(entity)
									SOUND.ding = true
								else
									print("Can't afford purchase")
									-- play 'fail' sound
									SOUND.wrong = true
								end
							end
						end
					end
				end
			end
		end
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

	cf.AddScreen(enum.sceneAsteroid, SCREEN_STACK)

	-- create the world
	SHOPWORLD = concord.world()
    ECSWORLD = concord.world()
	ecsFunctions.init()
	fun.loadAudio()
	fun.loadImages()
	fun.loadFonts()
	establishPhysicsWorld()

	keymaps.init()

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

	if cf.currentScreenName(SCREEN_STACK) == enum.sceneAsteroid then
		draw.asteroids()

	elseif cf.currentScreenName(SCREEN_STACK) == enum.sceneDed then
		draw.dead()
	elseif cf.currentScreenName(SCREEN_STACK) == enum.sceneShop then
		draw.shop()
	end
	lovelyToasts.draw()
    res.stop()
end

function love.update(dt)

	if cf.currentScreenName(SCREEN_STACK) == enum.sceneAsteroid then

		SOUND = {}		-- a global that is updated during update calls and then reset at the start of each dt
		DRAW = {}

		ECSWORLD:emit("update", dt)
		PHYSICSWORLD:update(dt) --this puts the world into motion

		-- turn senser back on after leaving dock
		local physEntity = fun.getPhysEntity(PLAYER.UID)
		local x,y = physEntity.body:getPosition()
		if y <= (PHYSICS_HEIGHT - PHYSICS_SAFEZONE) then
			physEntity.fixture:setSensor(false)
		end

		--! put this into a sub function
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
		end
		if SOUND.scrape1 then
			AUDIO[enum.audioRockScrape1]:play()
		end
		if SOUND.scrape2 then
			AUDIO[enum.audioRockScrape2]:play()
		end
		if SOUND.ding then
			AUDIO[enum.audioDing]:play()
		end
		if SOUND.wrong then
			AUDIO[enum.audioWrong]:play()
		end

		fun.deductO2(dt)

		-- check for dead chassis
		-- check for dead or empty o2 tank
		local deadreason = fun.checkIfDead(dt)
		if deadreason ~= "" then
			DEAD_REASON = deadreason		--! refactor to not use globals
			DEAD_ALPHA = DEAD_ALPHA + (dt * 0.25)
			if DEAD_ALPHA >= 1 then
				cf.SwapScreen(enum.sceneDed, SCREEN_STACK)
				-- cleanDeadData()		-!
			end
		end

		-- decrease bubble text timers
		for i = #BUBBLE, 1, -1 do
			BUBBLE[i].timeleft = BUBBLE[i].timeleft - dt
			if BUBBLE[i].timeleft <= 0 then table.remove(BUBBLE, i) end
		end

		-- alarm lights
		O2_ALARM_ALPHA = O2_ALARM_ALPHA + dt
		if O2_ALARM_ALPHA > 1 then O2_ALARM_ALPHA = 0 end

		FUEL_ALARM_ALPHA = FUEL_ALARM_ALPHA + dt
		if FUEL_ALARM_ALPHA > 1 then FUEL_ALARM_ALPHA = 0 end

		BATTERY_ALARM_ALPHA = BATTERY_ALARM_ALPHA + dt
		if BATTERY_ALARM_ALPHA > 1 then BATTERY_ALARM_ALPHA = 0 end

		SOSBEACON_ALARM_ALPHA = SOSBEACON_ALARM_ALPHA + dt
		if SOSBEACON_ALARM_ALPHA > 1 then SOSBEACON_ALARM_ALPHA = 0 end

		-- see if rescued while in escape pod
		-- there is a chance the vessel is rescued

		local temptable	 = physEntity.fixture:getUserData()
		if temptable.objectType == "Pod" then
			if love.math.random(1,2000) == 1 then			-- this is half the chance of an SOS beacon
				-- rescued!
				entity.SOSBeacon.activated = false
				cf.AddScreen(enum.sceneShop, SCREEN_STACK)		--! should probably go to a screen with an explanation
			end
		end

		input:update()

		cam:setPos(TRANSLATEX, TRANSLATEY)
		cam:setZoom(ZOOMFACTOR)


	elseif cf.currentScreenName(SCREEN_STACK) == enum.sceneShop then
		local physEntity = fun.getPhysEntity(PLAYER.UID)
		local x1, y1 = physEntity.body:getPosition()
		if y1 > 925 then
			physEntity.body:setPosition(x1, 925)			--! hack
		end
	end

	SHOP_TIMER = SHOP_TIMER - dt		-- counts down regardless of which screen you on
	if SHOP_TIMER < 0 then
		SHOP_TIMER = 0
		SHOP_ENTITY = nil
	end

	fun.playAmbientMusic()

	lovelyToasts.update(dt)
	res.update()
end
