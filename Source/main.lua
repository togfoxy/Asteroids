GAME_VERSION = "0.03"

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
buttons = require 'buttons'

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

				local item = {}
				item.description = "Income"
				item.amount = profit
				table.insert(RECEIPT, item)
			end
		end

		-- refill consumerables
		local allComponents = entity:getComponents()
		for _, component in pairs(allComponents) do
			if component.capacity ~= nil then
				component.capacity = component.maxCapacity
			end
		end
		if entity:has("spaceSuit") then entity.spaceSuit.O2capacity = entity.spaceSuit.maxO2Capacity end
		if entity:has("SOSBeacon") then entity.SOSBeacon.activated = false end

		AUDIO[enum.audioBGSkismo]:stop()

		local temptable = physEntity.fixture:getUserData()
		if temptable.objectType == "Pod" then
			temptable.objectType = "Player"
		end

		-- re-activate alarm sounds
		ALARM_OFF_TIMER = 0

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

		if cf.currentScreenName(SCREEN_STACK) == enum.sceneShop then
			local physEntity = fun.getPhysEntity(PLAYER.UID)
			local x1, y1 = physEntity.body:getPosition()

			-- ensure there is no rotation
			physEntity.body:setAngularVelocity(0)

			-- spawn a reasonable distance from the shop
			if y1 > 900 then
				physEntity.body:setPosition(x1, 900)
				x1, y1 = physEntity.body:getPosition()
			end
			TRANSLATEX = (x1 * BOX2D_SCALE)
			TRANSLATEY = (y1 * BOX2D_SCALE)

			-- reset the shopping receipt for next time
			RECEIPT = {}
			local item = {}
			item.description = "Opening balance"
			item.amount = PLAYER.WEALTH
			table.insert(RECEIPT, item)
		end

		ZOOMFACTOR = 0.4

		cf.RemoveScreen(SCREEN_STACK)
	end
	if input:down("centreview") then
		local x1, y1 = fun.getPhysEntityXY(PLAYER.UID)
		TRANSLATEX = (x1 * BOX2D_SCALE)
		TRANSLATEY = (y1 * BOX2D_SCALE)
	    ZOOMFACTOR = 0.4
	end
	if key == "f1" then
		-- local success = love.system.openURL("https://github.com/togfoxy/Asteroids/tree/master#readme")
		-- local success = love.system.openURL("https://docs.google.com/document/d/1X8Js3dxZ6TfYfF1FJ9Vdy2ck_zvzMC0CzXN_egpEFPY/edit?usp=sharing")

		local savedir = love.filesystem.getSourceBaseDirectory()
		local helpfile
		if love.filesystem.isFused() then
			savedir = savedir .. "\\assets\\"
		else
			savedir = savedir .. "/Source/assets/"
		end
		helpfile = savedir .. "AsteroidHunter.html"
		local success = love.system.openURL(helpfile)
		if success then PAUSED = true end
	end
	if key == "f6" then
		fileops.saveGame()
	end
	if key == "f7" then
		fileops.loadGame()
	end
	if key == "p" then
		PAUSED = not PAUSED
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
			physEntity.body:applyTorque(PHYSICS_TURNRATE * -1)
		end
	end

	if input:down('rotateright') and entity:has("fuelTank") and entity:has("leftThruster") and entity.leftThruster.currentHP > 0 then
		-- do nothing because the :update event has superior turning logic
	else
		-- offer a very basic and slow rotation
		if input:down('rotateright') then
			-- rotate cw
			physEntity.body:applyTorque(PHYSICS_TURNRATE)
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

function love.mousereleased( x, y, button, istouch, presses )
	local entity = fun.getEntity(PLAYER.UID)

	local wx, wy
	if cam == nil then
	else
		wx,wy = cam:toWorld(x, y)	-- converts screen x/y to world x/y
	end

	if button == 1 then
		local currentScreen = cf.currentScreenName(SCREEN_STACK)

		if currentScreen == enum.sceneShop then
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
									local item = {}
									item.description = "Repairs"
									item.amount = -1000
									table.insert(RECEIPT, item)
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
								-- exchange existing item
								local refund = love.math.random(400, 600)		-- should bake the refund into the component so it doesn't change on multiple clicks
								if PLAYER.WEALTH + refund >= purchaseprice then
									PLAYER.WEALTH = PLAYER.WEALTH + refund
									local item = {}
									item.description = "Refund"
									item.amount = refund
									table.insert(RECEIPT, item)
									entity:remove(shopcomponentType)
									fun.buyComponent(entity, shopcomponentType, button.component)
									PLAYER.WEALTH = PLAYER.WEALTH - purchaseprice
									SHOP_ENTITY:remove(shopcomponentType)
									fun.changeShipPhysicsSize(entity)
									SOUND.ding = true
									local item = {}
									item.description = "Upgrade"
									item.amount = -1000
									table.insert(RECEIPT, item)
								else
									-- play 'fail' sound
									SOUND.wrong = true
								end
							else
								-- purchase new item
								-- refactor this and above
								-- can always buy a cargohold, even if no money
								if PLAYER.WEALTH >= purchaseprice or shopcomponentType == "cargoHold" then

									fun.buyComponent(entity, shopcomponentType, button.component)

									PLAYER.WEALTH = PLAYER.WEALTH - purchaseprice
									SHOP_ENTITY:remove(shopcomponentType)
									fun.changeShipPhysicsSize(entity)
									SOUND.ding = true
									local item = {}
									item.description = "Purchase"
									item.amount = -1000
									table.insert(RECEIPT, item)
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

		elseif currentScreen == enum.sceneAsteroid then
			-- process buttons
			local rx, ry = res.toGame(x,y)		-- does this need to be applied consistently across all mouse clicks?
			for k, button in pairs(GUI_BUTTONS) do
				if button.scene == enum.sceneAsteroid and button.visible then
					local mybuttonID = buttons.buttonClicked(rx, ry, button)		-- bounding box stuff
					if mybuttonID == enum.buttonAlarmOff then
						-- turn sounds off for a number of minutes
						if button.state == "off" then
							-- Mute alarms
							ALARM_OFF_TIMER = DEFAULT_ALARM_TIMER
							button.state = "on"
						else
							-- Unmute alarms (turn button off)
							ALARM_OFF_TIMER = 0
							button.state = "off"
						end
					elseif mybuttonID == enum.buttonSOSBeacon then
						if button.state == "off" then
							button.state = "on"
							entity.SOSBeacon.activated = true

						else
							button.state = "off"
							entity.SOSBeacon.activated = false
						end
						break
					elseif	mybuttonID == enum.buttonEjectionPod then
						entity.ejectionPod.active = true
					end
				end
			end

		elseif currentScreen == enum.sceneMainMenu then
			local rx, ry = res.toGame(x,y)		-- does this need to be applied consistently across all mouse clicks?
			for k, button in pairs(GUI_BUTTONS) do
				if button.scene == enum.sceneMainMenu and button.visible then
					local mybuttonID = buttons.buttonClicked(rx, ry, button)		-- bounding box stuff

					if mybuttonID == enum.buttonNewGame then
						fun.InitialiseGame()
						cf.AddScreen(enum.sceneAsteroid, SCREEN_STACK)
						break
					elseif mybuttonID == enum.buttonSaveGame then
						fileops.saveGame()
						break
					elseif mybuttonID == enum.buttonLoadGame then
						fileops.loadGame()
						cf.AddScreen(enum.sceneAsteroid, SCREEN_STACK)
						break
					elseif mybuttonID == enum.buttonCredits then
						cf.AddScreen(enum.sceneCredits, SCREEN_STACK)
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
        void = love.window.setMode(SCREEN_WIDTH, SCREEN_HEIGHT,{fullscreen=true,display=1,resizable=false, borderless=true})	-- display = monitor number (1 or 2)
    else
        void = love.window.setMode(SCREEN_WIDTH, SCREEN_HEIGHT,{fullscreen=true,display=1,resizable=false, borderless=true})	-- display = monitor number (1 or 2)
    end

	love.window.setTitle("Asteroid hunter " .. GAME_VERSION)
	love.keyboard.setKeyRepeat(true)

	fun.loadAudio()
	fun.loadImages()
	fun.loadFonts()

	buttons.loadButtons()			-- the buttons that are displayed on different gui's
	keymaps.init()
    cmp.init()

	-- cf.AddScreen(enum.sceneAsteroid, SCREEN_STACK)
	cf.AddScreen(enum.sceneMainMenu, SCREEN_STACK)
end

function love.draw()

    res.start()

	if cf.currentScreenName(SCREEN_STACK) == enum.sceneAsteroid then
		draw.asteroids()
		if PAUSED then
			-- print PAUSED
			love.graphics.setColor(1,1,1,1)
			local drawx = (SCREEN_WIDTH / 2) - 30
			local drawy = (SCREEN_HEIGHT / 3)
			love.graphics.print("PAUSED", drawx, drawy)
		end
	elseif cf.currentScreenName(SCREEN_STACK) == enum.sceneDed then
		draw.dead()
	elseif cf.currentScreenName(SCREEN_STACK) == enum.sceneShop then
		draw.shop()
	elseif cf.currentScreenName(SCREEN_STACK) == enum.sceneMainMenu then
		draw.mainMenu()
	elseif cf.currentScreenName(SCREEN_STACK) == enum.sceneCredits then
		draw.credits()
	end
	lovelyToasts.draw()
    res.stop()
end

local function raycastCallback(fixture, x, y, xn, yn, fraction)

	local temptable = fixture:getUserData()
	temptable.isVisible = true
	fixture:setUserData(temptable)
	return 1
end

function love.update(dt)

	DRAW = {}

	if cf.currentScreenName(SCREEN_STACK) == enum.sceneAsteroid then

		if not PAUSED then

			ECSWORLD:emit("update", dt)
			PHYSICSWORLD:update(dt) --this puts the world into motion

			-- turn senser back on after leaving dock
			local physEntity = fun.getPhysEntity(PLAYER.UID)
			local x,y = physEntity.body:getPosition()
			if y <= (PHYSICS_HEIGHT - PHYSICS_SAFEZONE) then
				physEntity.fixture:setSensor(false)
			end

			fun.deductO2(dt)

			-- check for dead chassis
			-- check for dead or empty o2 tank
			local deadreason = fun.checkIfDead(dt)
			if deadreason ~= "" then
				DEAD_REASON = deadreason		-- refactor to not use globals
				DEAD_ALPHA = DEAD_ALPHA + (dt * 0.25)
				if DEAD_ALPHA >= 1 then
					fun.InitialiseGame()
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
					cf.AddScreen(enum.sceneShop, SCREEN_STACK)		--! should probably go to a screen with an explanation
				end
			end

			-- do raycasting stuff
			local facing = physEntity.body:getAngle()       -- radians
	        facing = cf.convRadToCompass(facing)
			local vectordistance = VISIBILITY_DISTANCE
			local x2, y2 = cf.AddVectorToPoint(x, y, facing, vectordistance)

			PHYSICSWORLD:rayCast(x, y, x2, y2, raycastCallback)

			input:update()
		else
		end

		cam:setPos(TRANSLATEX, TRANSLATEY)
		cam:setZoom(ZOOMFACTOR)
	elseif cf.currentScreenName(SCREEN_STACK) == enum.sceneShop then
		local physEntity = fun.getPhysEntity(PLAYER.UID)
		local x1, y1 = physEntity.body:getPosition()
		if y1 > 925 then
			physEntity.body:setPosition(x1, 925)
		end
	end

	fun.playSounds()

	SHOP_TIMER = SHOP_TIMER - dt		-- counts down regardless of which screen you on
	if SHOP_TIMER < 0 then
		SHOP_TIMER = 0
		SHOP_ENTITY = nil
	end

	ALARM_OFF_TIMER = ALARM_OFF_TIMER - dt
	if ALARM_OFF_TIMER <= 0 then
		-- turn off the mute button (i.e. make alarms)
		ALARM_OFF_TIMER = 0
		for k, button in pairs(GUI_BUTTONS) do
			if button.identifier == enum.buttonAlarmOff then
				button.state = "off"
			end
		end
	end

	fun.playAmbientMusic()

	lovelyToasts.update(dt)
	res.update()
end
