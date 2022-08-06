functions = {}

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
	:give("oxyTank")
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
	-- entity.battery.capacity = 20

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

function functions.loadImages()

	IMAGES[enum.imagesEngineFlame] = love.graphics.newImage("assets/images/flame.png")
	IMAGES[enum.imagesVessel] = love.graphics.newImage("assets/images/ship1.png")
	IMAGES[enum.imagesPod] = love.graphics.newImage("assets/images/pod.png")
	IMAGES[enum.imagesStarbase] = love.graphics.newImage("assets/images/starbase.png")

	-- hud
	IMAGES[enum.imagesEjectButton] = love.graphics.newImage("assets/images/ejectbutton.png")
	IMAGES[enum.imagesOrangeBar] = love.graphics.newImage("assets/images/orangebar.png")
	IMAGES[enum.imagesOrangeBarEnd] = love.graphics.newImage("assets/images/orangebarend.png")
	IMAGES[enum.imagesBlueBar] = love.graphics.newImage("assets/images/bluebar.png")
	IMAGES[enum.imagesBlueBarEnd] = love.graphics.newImage("assets/images/bluebarend.png")
	IMAGES[enum.imagesGreenBar] = love.graphics.newImage("assets/images/greenbar.png")
	IMAGES[enum.imagesGreenBarEnd] = love.graphics.newImage("assets/images/greenbarend.png")

	-- shop
	IMAGES[enum.imagesShopPanel] = love.graphics.newImage("assets/images/shoppanel.png")
	IMAGES[enum.imagesShopPanels] = love.graphics.newImage("assets/images/shoppanels.png")

	-- background
	IMAGES[enum.imagesBackgroundStatic] = love.graphics.newImage("assets/images/bg_space_seamless_2.png")
	IMAGES[enum.imagesDead] = love.graphics.newImage("assets/images/dead.jpg")
	IMAGES[enum.imagesShop] = love.graphics.newImage("assets/images/shop.jpg")
	IMAGES[enum.imagesMenuBackground] = love.graphics.newImage("assets/images/menubackground.png")
	IMAGES[enum.imagesAsteroidBackground] = love.graphics.newImage("assets/images/asteroidbg.png")

end

function functions.loadAudio()
    AUDIO[enum.audioEngine] = love.audio.newSource("assets/audio/engine.ogg", "static")
	AUDIO[enum.audioLowFuel] = love.audio.newSource("assets/audio/lowFuel.ogg", "static")
	AUDIO[enum.audioWarning] = love.audio.newSource("assets/audio/507906__m-cel__warning-sound.ogg", "static")
	AUDIO[enum.audioMiningLaser] = love.audio.newSource("assets/audio/223472__parabolix__underground-machine-heart-loop.mp3", "static")
	AUDIO[enum.audioRockExplosion] = love.audio.newSource("assets/audio/cannon_hit.ogg", "static")
	AUDIO[enum.audioRockScrape1] = love.audio.newSource("assets/audio/metalscrape1.mp3", "static")
	AUDIO[enum.audioRockScrape2] = love.audio.newSource("assets/audio/metalscrape2.mp3", "static")
	AUDIO[enum.audioDing] = love.audio.newSource("assets/audio/387232__steaq__badge-coin-win.wav", "static")
	AUDIO[enum.audioWrong] = love.audio.newSource("assets/audio/wrong.mp3", "static")


	-- bground music - asteroids
	AUDIO[enum.audioBGSkismo] = love.audio.newSource("assets/music/Reflekt.mp3", "stream")

	-- bground music - shop
	AUDIO[enum.audioBGEric1] = love.audio.newSource("assets/music/Urban-Jungle-2061.mp3", "stream")
	AUDIO[enum.audioBGEric2] = love.audio.newSource("assets/music/World-of-Automatons.mp3", "stream")

	AUDIO[enum.audioRockExplosion]:setVolume(0.5)
	AUDIO[enum.audioRockScrape1]:setVolume(0.5)
	AUDIO[enum.audioRockScrape2]:setVolume(0.5)
	AUDIO[enum.audioBGSkismo]:setVolume(0.5)
	AUDIO[enum.audioBGEric1]:setVolume(0.5)
end

function functions.loadFonts()
    FONT[enum.fontHeavyMetalLarge] = love.graphics.newFont("assets/fonts/Heavy Metal Box.ttf")
    FONT[enum.fontHeavyMetalSmall] = love.graphics.newFont("assets/fonts/Heavy Metal Box.ttf",10)
    FONT[enum.fontDefault] = love.graphics.newFont("assets/fonts/Vera.ttf", 12)
	FONT[enum.fontTech36] = love.graphics.newFont("assets/fonts/CorporateGothicNbpRegular-YJJ2.ttf", 36)
	FONT[enum.fontTech18] = love.graphics.newFont("assets/fonts/CorporateGothicNbpRegular-YJJ2.ttf", 24)
end

function functions.getPhysEntity(uid)
    -- gets a phyisics item from an ECS UID
    -- can then access body, fixture, shape etc.
    assert(uid ~= nil)
    for i = 1, #PHYSICS_ENTITIES do
		local udtable = PHYSICS_ENTITIES[i].fixture:getUserData()
		if udtable.uid == uid then
            return PHYSICS_ENTITIES[i]
        end
    end
    return nil
end

function functions.getPhysEntityXY(uid)
    -- returns a body x/y from an ECS UID
    assert(uid ~= nil)

    local physEntity = fun.getPhysEntity(uid)
    if physEntity ~= nil then
        -- return physEntity.body:getX(), physEntity.body:getY()
		return physEntity.body:getPosition()
    else
        return nil
    end
end

function functions.getEntity(uid)
    assert(uid ~= nil)
    for k,v in pairs(ECS_ENTITIES) do
        if v.uid.value == uid then
            return v
        end
    end
    return nil
end

function functions.getEntitySize(entity)
    -- receives an ECS entity and calculates the size of all components
    -- the size is used to form the ship square and is therefore half the width of the square
    local totalsize = 0
    local allComponents = entity:getComponents()
	for ComponentClass, Component in pairs(allComponents) do
	   -- Do stuff
	   if Component.size ~= nil then
           totalsize = totalsize + Component.size
	   end
   end
   return totalsize
end

function functions.createAsteroid()
	-- creates one asteroid in a random location

	-- determine physics x/y of origin/object
	local x0 = love.math.random(100, PHYSICS_WIDTH - 100)
	local y0 = love.math.random(100, PHYSICS_HEIGHT - PHYSICS_SAFEZONE - 100)

	-- determine number of segments
	local numsegments = love.math.random(4,8)
	local x = {}
	local y = {}

	-- determine x/y for each point
	local asteroidpoints = {}

	-- first point is random heading and distance from origin
	local bearing = love.math.random(0,359)
	local distance = love.math.random(5,20)		-- physics metres
	x[1], y[1] = cf.AddVectorToPoint(x0, y0, 0, distance)

	-- need to get x/y relative to body origin/position
	table.insert(asteroidpoints, x[1] - x0)
	table.insert(asteroidpoints, y[1] - y0)

	-- keep adding vectors in a clockwise direction
	local bestangle = 360 / numsegments		-- use this number to form a perfect polygon
	local segmentheading = 0				-- first point is pointing north.
	for i = 2, (numsegments) do
		local angleAdjustment = love.math.random(0, 10)		-- get a random angleAdjustment
		local angle = cf.adjustHeading(bestangle, angleAdjustment)

		segmentheading = cf.adjustHeading(segmentheading, angle)
		x[i],y[i] = cf.AddVectorToPoint(x[i-1], y[i-1], segmentheading, distance)

		table.insert(asteroidpoints, x[i] - x0)
		table.insert(asteroidpoints, y[i] - y0)
	end


	-- create physical object
	local asteroid = {}
    asteroid.body = love.physics.newBody(PHYSICSWORLD, x0, y0, "dynamic")
	asteroid.body:setLinearDamping(0)
	-- asteroid.body:setMass(500)		-- kg		-- made redundant by newFixture
	-- asteroid.shape = love.physics.newRectangleShape(shipsize, shipsize)		-- will draw a rectangle around the body x/y. No need to offset it
	asteroid.shape = love.physics.newPolygonShape(asteroidpoints)
	asteroid.fixture = love.physics.newFixture(asteroid.body, asteroid.shape, PHYSICS_DENSITY)		-- the 1 is the density
	asteroid.fixture:setRestitution(0.1)		-- between 0 and 1
	asteroid.fixture:setSensor(false)
	local temptable = {}
	temptable.uid = cf.Getuuid()
	temptable.objectType = "Asteroid"
	asteroid.originalMass = asteroid.body:getMass()
	asteroid.currentMass = asteroid.originalMass


	local rndnum = love.math.random(1, 100)
	if rndnum == 1 then
		temptable.oreType = enum.oreTypeGold	-- gold
	elseif rndnum == 2 or rndnum == 3 then
		temptable.oreType = enum.oreTypeSilver	-- silver
	elseif rndnum >= 4 and rndnum <= 6 then
		temptable.oreType = enum.oreTypeBronze	-- bronze
	else
		-- normal ore
		temptable.oreType = 0
	end
	temptable.isVisible = false
	asteroid.fixture:setUserData(temptable)

    table.insert(PHYSICS_ENTITIES, asteroid)
end

function functions.getRandomComponent(entity)
	-- get a random component from entity
	-- probability of getting a 'hit' depends on the size of each component

	local entitysize = cf.round(fun.getEntitySize(entity))
	local rndnum = love.math.random(1, entitysize)

	local allComponents = entity:getComponents()
	for ComponentClass, Component in pairs(allComponents) do
		if Component.size ~= nil then
			if Component.size > 0 then
				if Component.size >= rndnum	then
					return Component
				else
					rndnum = rndnum - Component.size
				end
			end
		end
   end

   error("Program flow should not have reached here")
end

function functions.getDestroyedComponentString(entity)
	-- cycle through all components looking for destroyed ones
	-- returns a sting

	local result = ""		-- string
	local allComponents = entity:getComponents()
	for _, component in pairs(allComponents) do
		if component.currentHP ~= nil then
			if component.currentHP <= 0 then
				result = result .. component.label .. "\n"
			end
		end
    end
	return result
end

function functions.getLowComponentString(entity)
	-- cycle through components looking for empty tanks and batteries
	-- returns a string
	local result = ""		-- string
	local allComponents = entity:getComponents()
	for _, component in pairs(allComponents) do
		if component.capacity ~= nil then
			if component.capacity <= 0 then
				result = result .. component.label .. "\n"
			end
		end
    end
	return result
end

function functions.killECSEntity(entity)
	-- does NOT kill the physics entity

	-- remove the entity from the arrary
    for i = 1, #ECS_ENTITIES do
        if ECS_ENTITIES[i] == entity then
            table.remove(ECS_ENTITIES, i)
            break
        end
    end
	-- destroy the entity
    entity:destroy()
end

function functions.killPhysicsEntity(physEntity)
	-- used on rocks and other things
	-- receives a physics entity

    -- unit test
    local physicsOrigsize = #PHYSICS_ENTITIES
    --
    -- destroy the body then remove empty body from the array
    for i = 1, #PHYSICS_ENTITIES do		-- needs to be a for i loop so we can do a table remove
        if PHYSICS_ENTITIES[i] == physEntity then
            PHYSICS_ENTITIES[i].body:destroy()
            table.remove(PHYSICS_ENTITIES, i)
            break
        end
    end

    -- unit test
    assert(#PHYSICS_ENTITIES < physicsOrigsize)
end

local function entityHasO2(entity)
	local hasO2 = false

	if entity:has("oxyGenerator") and entity.oxyGenerator.currentHP > 0 then
		if entity:has("battery") and entity.battery.capacity > 0 and entity.battery.currentHP > 0 then
			return true
		end
	end

	if entity:has("oxyTank") and entity.oxyTank.capacity > 0 and entity.oxyTank.currentHP > 0 then
		return true
	end

	if entity:has("spaceSuit") and entity.spaceSuit.O2capacity > 0 then
		return true
	end

	return false
end

function functions.checkIfDead(dt)
	-- returns nothing (is a sub that returns nothing)
	local reason = ""
	local entity = fun.getEntity(PLAYER.UID)
	if entity:has("chassis") then
		if entity.chassis.currentHP <= 0 then
			reason = "The ship body (chassis) has been destroyed. Don't crash into so many things."
		end
	else
		error("Vessel has no chassis!")
	end

	if not entityHasO2(entity) then
		reason = "You have run out of oxygen. Ensure you have an O2 generator with batteries, or O2 tanks or a space suit with sufficient O2."
	end
	return reason
end

function functions.deductO2(dt)
	-- deduct O2 from player vessel
	local entity = fun.getEntity(PLAYER.UID)

	if entity:has("oxyGenerator") and entity.oxyGenerator.currentHP > 0 then
		if entity:has("battery") and entity.battery.currentHP > 0 and entity.battery.capacity > 0 then
			-- functional generator. Nothing to do
			return
		end
	end
	if entity:has("oxyTank") then
		if entity.oxyTank.currentHP > 0 and entity.oxyTank.capacity > 0 then
			-- deduct from tank
			entity.oxyTank.capacity = entity.oxyTank.capacity - dt
			if entity.oxyTank.capacity <= 0 then entity.oxyTank.capacity = 0 end
			return
		end
	end
	if entity:has("spaceSuit") then
		if entity.spaceSuit.O2capacity > 0 then
			-- deduct from suit
			entity.spaceSuit.O2capacity = entity.spaceSuit.O2capacity - dt
			if entity.spaceSuit.O2capacity < 0 then entity.spaceSuit.O2capacity = 0 end
			return
		end
	end
	print("No oxygen. Needs to be ded")
end

function functions.getO2left()
	-- count how many seconds of o2 in tank + suit
	local result = 0
	local entity = fun.getEntity(PLAYER.UID)
	if entity:has("oxyTank") then
		if entity.oxyTank.currentHP > 0 and entity.oxyTank.capacity > 0 then
			result = result + entity.oxyTank.capacity
		end
	end
	if entity:has("spaceSuit") then
		if entity.spaceSuit.O2capacity > 0 then
			result = result + entity.spaceSuit.O2capacity
		end
	end
	return result
end

function functions.getFuelBurnTime()
	-- burn time = fuel / thrust
	-- returns a number (seconds)
	local entity = fun.getEntity(PLAYER.UID)
	if entity:has("engine") then
		if entity.engine.currentHP > 0 then
			if entity:has("fuelTank") then
				if entity.fuelTank.currentHP > 0 then
					return cf.round(entity.fuelTank.capacity / entity.engine.strength)
				end
			end
		end
	end
	return 0
end

function functions.changeShipPhysicsSize(entity)
	-- destroys the physics object and recreates it
	-- receives an ECS entity
	-- returns nothing

	assert(PLAYER.UID ~= nil)

	local shipsize = fun.getEntitySize(entity)
	local temptable = {}
	local physicsEntity = fun.getPhysEntity(PLAYER.UID)
	assert(physicsEntity ~= nil)
	local x,y = physicsEntity.body:getPosition()
	temptable = physicsEntity.fixture:getUserData()
	fun.killPhysicsEntity(physicsEntity)

	local physicsEntity = {}
	physicsEntity.body = love.physics.newBody(PHYSICSWORLD, x, y, "dynamic")
	physicsEntity.body:setLinearDamping(0)
	physicsEntity.shape = love.physics.newRectangleShape(shipsize, shipsize)		-- will draw a rectangle around the body x/y. No need to offset it
	physicsEntity.fixture = love.physics.newFixture(physicsEntity.body, physicsEntity.shape, PHYSICS_DENSITY)		-- the 1 is the density
	physicsEntity.fixture:setRestitution(0.1)		-- between 0 and 1
	physicsEntity.fixture:setSensor(false)
	physicsEntity.fixture:setUserData(temptable)		-- links the physics object to the ECS entity

	table.insert(PHYSICS_ENTITIES, physicsEntity)
end

function functions.buyComponent(entity, strShopComponentType, shopcomponent)
	-- entity is an ECS entity that reflects the player
	-- strShopComponentType is a string with the name of the component
	-- component is the actual component stored in the button (shop)

	local shopitemserial = shopcomponent:serialize()

	entity:give(strShopComponentType)

	local allComponents = entity:getComponents()
	for _, component in pairs(allComponents) do
		if component.label == shopcomponent.label then
			component:deserialize(shopitemserial)
		end
	end



	-- if strShopComponentType == "chassis" then
	-- 	entity:give("chassis")
	-- 	entity.chassis.size = component.size
	-- 	entity.chassis.maxHP = component.maxHP
	-- 	entity.chassis.currentHP = component.maxHP
	-- 	entity.chassis.description = "Vessel frame. Size " .. component.size .. ". Health " .. component.maxHP .. "."
	-- end
	-- if strShopComponentType == "engine" then
	-- 	entity:give("engine")
	-- 	entity.engine.size = component.size
	-- 	entity.engine.strength = component.strength
	-- 	entity.engine.maxHP = component.maxHP
	-- 	entity.engine.currentHP = component.maxHP
	-- 	entity.engine.description = "Main propulsion. Size " .. component.size .. ". Health " .. component.maxHP .. ". Thrust " .. component.strength .. "."
	-- end
	-- if strShopComponentType == "fuelTank" then
	-- 	entity:give("fuelTank")
	-- 	entity.fuelTank.size = component.size
	-- 	entity.fuelTank.capacity = component.capacity
	-- 	entity.fuelTank.maxCapacity = component.maxCapacity
	-- 	entity.fuelTank.maxHP = component.maxHP
	-- 	entity.fuelTank.currentHP = component.maxHP
	-- 	entity.fuelTank.description = "Engine needs this. Size " .. component.size .. ". Health " .. component.maxHP .. ". Capacity " .. component.maxCapacity .. "."
	-- end
	-- if strShopComponentType == "leftThruster" then
	-- 	entity:give("leftThruster")
	-- 	entity.leftThruster.size = component.size
	-- 	entity.leftThruster.strength = component.strength
	-- 	entity.leftThruster.maxHP = component.maxHP
	-- 	entity.leftThruster.currentHP = component.maxHP
	-- 	entity.leftThruster.description = "Slide to the right. Size " .. component.size .. ". Health " .. component.maxHP .. ". Thrust " .. component.strength .. "."
	-- end
	-- if strShopComponentType == "rightThruster" then
	-- 	entity:give("rightThruster")
	-- 	entity.rightThruster.size = component.size
	-- 	entity.rightThruster.strength = component.strength
	-- 	entity.rightThruster.maxHP = component.maxHP
	-- 	entity.rightThruster.currentHP = component.maxHP
	-- 	entity.rightThruster.description = "Slide to the right. Size " .. component.size .. ". Health " .. component.maxHP .. ". Thrust " .. component.strength .. "."
	-- end
	-- if strShopComponentType == "reverseThruster" then
	-- 	entity:give("reverseThruster")
	-- 	entity.reverseThruster.size = component.size
	-- 	entity.reverseThruster.strength = component.strength
	-- 	entity.reverseThruster.maxHP = component.maxHP
	-- 	entity.reverseThruster.currentHP = component.maxHP
	-- 	entity.reverseThruster.description = "Braking is good. Size " .. component.size .. ". Health " .. component.maxHP .. ". Thrust " .. component.strength .. "."
	-- end
	-- if strShopComponentType == "miningLaser" then
	-- 	entity:give("miningLaser")
	-- 	entity.miningLaser.size = component.size
	-- 	entity.miningLaser.miningRate = component.miningRate
	-- 	entity.miningLaser.miningRange = component.miningRange
	-- 	entity.miningLaser.maxHP = component.maxHP
	-- 	entity.miningLaser.currentHP = component.maxHP
	-- 	entity.miningLaser.description = "Mines rocks. Size " .. component.size .. ". Health " .. component.maxHP .. ". Mining speed " .. component.miningRate .. ". Laser range " .. component.miningRange
	-- end
	-- if strShopComponentType == "battery" then
	-- 	entity:give("battery")
	-- 	entity.battery.size = component.size
	-- 	entity.battery.capacity = component.capacity
	-- 	entity.battery.maxCapacity = component.maxCapacity
	-- 	entity.battery.maxHP = component.maxHP
	-- 	entity.battery.currentHP = component.maxHP
	-- 	entity.battery.description = "Powers lasers. Size " .. component.size .. ". Health " .. component.maxHP .. ". Capacity " .. component.maxCapacity .. "."
	-- end
	-- if strShopComponentType == "oxyGenerator" then
	-- 	entity:give("oxyGenerator")
	-- 	entity.oxyGenerator.size = component.size
	-- 	entity.oxyGenerator.powerNeeds = component.powerNeeds
	-- 	entity.oxyGenerator.maxHP = component.maxHP
	-- 	entity.oxyGenerator.currentHP = component.maxHP
	-- 	entity.oxyGenerator.description = "Makes O2 to keep you alive. Size " .. component.size .. ". Health " .. component.maxHP .. ". Draws " .. component.powerNeeds .. " per second."
	-- end
	-- if strShopComponentType == "oxyTank" then
	-- 	entity:give("oxyTank")
	-- 	entity.oxyTank.size = component.size
	-- 	entity.oxyTank.capacity = component.capacity
	-- 	entity.oxyTank.maxCapacity = component.maxCapacity
	-- 	entity.oxyTank.maxHP = component.maxHP
	-- 	entity.oxyTank.currentHP = component.maxHP
	-- 	entity.oxyTank.description = "Holds spare oxygen. Size " .. component.size .. ". Health " .. component.maxHP .. ". Capactiy " .. component.capacity .. " seconds."
	-- end
	-- if strShopComponentType == "spaceSuit" then
	-- 	entity:give("spaceSuit")
	-- 	entity.spaceSuit.size = component.size
	-- 	entity.spaceSuit.O2capacity = component.O2capacity
	-- 	entity.spaceSuit.maxO2Capacity = component.maxO2Capacity
	-- 	entity.spaceSuit.description = "Use when O2 runs out. O2 capacity " .. component.maxO2Capacity .. " seconds."
	-- end
	-- if strShopComponentType == "solarPanel" then
	-- 	entity:give("solarPanel")
	-- 	entity.solarPanel.size = component.size
	-- 	entity.solarPanel.rechargeRate = component.rechargeRate
	-- 	entity.solarPanel.maxHP = component.maxHP
	-- 	entity.solarPanel.currentHP = component.maxHP
	-- 	entity.solarPanel.description = "Recharges batteries. Size " .. component.size .. ". Health " .. component.maxHP .. ". Recharge rate " .. component.rechargeRate .. " power/sec."
	-- end
	-- if strShopComponentType == "cargoHold" then
	-- 	entity:give("cargoHold")
	-- 	entity.cargoHold.size = component.size
	-- 	entity.cargoHold.maxAmount = component.maxAmount
	-- 	entity.cargoHold.currentAmount = 0
	-- 	entity.cargoHold.maxHP = component.maxHP
	-- 	entity.cargoHold.currentHP = component.maxHP
	-- 	entity.cargoHold.description = "Holds rocks. Size " .. component.size .. ". Health " .. component.maxHP .. ". Capacity " .. component.maxAmount .. " tons."
	-- end

end

function functions.playAmbientMusic()
	local intCount = love.audio.getActiveSourceCount()
	if intCount == 0 then
		if cf.currentScreenName(SCREEN_STACK) == enum.sceneAsteroid then
			if love.math.random(1,2000) == 1 then		-- allow for some silence between ambient music
				AUDIO[enum.audioBGSkismo]:play()
				print("playing Skismo")
			end
		elseif	cf.currentScreenName(SCREEN_STACK) == enum.sceneShop then
			if love.math.random(1,2000) == 1 then		-- allow for some silence between ambient music
				if love.math.random(1,2) == 1 then
					AUDIO[enum.audioBGEric1]:play()
					print("playing Eric1")
				else
					AUDIO[enum.audioBGEric2]:play()
					print("playing Eric2")
				end
			end
		end
	end
end

function functions.playSounds()
	-- called from love.update

	if SOUND.engine then
		AUDIO[enum.audioEngine]:play()
		SOUND.engine = false
	else
		AUDIO[enum.audioEngine]:stop()
	end
	if SOUND.lowFuel and ALARM_OFF_TIMER <= 0 then
		AUDIO[enum.audioLowFuel]:play()
		SOUND.lowFuel = false
	else
		AUDIO[enum.audioLowFuel]:stop()
	end
	if SOUND.warning and ALARM_OFF_TIMER <= 0  then
		AUDIO[enum.audioWarning]:play()
		SOUND.warning = false
	else
		AUDIO[enum.audioWarning]:stop()
	end
	if SOUND.miningLaser then
		AUDIO[enum.audioMiningLaser]:play()
		SOUND.miningLaser = false
	else
		AUDIO[enum.audioMiningLaser]:stop()
	end
	if SOUND.rockExplosion then
		AUDIO[enum.audioRockExplosion]:play()
		SOUND.rockExplosion = false
	end
	if SOUND.scrape1 then
		AUDIO[enum.audioRockScrape1]:play()
		SOUND.scrape1 = false
	end
	if SOUND.scrape2 then
		AUDIO[enum.audioRockScrape2]:play()
		SOUND.scrape2 = false
	end
	if SOUND.ding then
		AUDIO[enum.audioDing]:play()
		SOUND.ding = false
	end
	if SOUND.wrong then
		AUDIO[enum.audioWrong]:play()
		SOUND.wrong = false
	end
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

	starbase.shape = love.physics.newPolygonShape(-250,-19,250,-19,250,20,-250,20)

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

function functions.InitialiseGame()
	-- do all the stuff that starts the game

	for k, entity in pairs(ECS_ENTITIES) do
		fun.killECSEntity(entity)
	end

	for k, physEntity in pairs(PHYSICS_ENTITIES) do
		fun.killPhysicsEntity(physEntity)
	end

	ECS_ENTITIES = {}
	PHYSICS_ENTITIES = {}
	SHOPWORLD = {}
	ECSWORLD = {}

	SHOPWORLD = concord.world()
	ECSWORLD = concord.world()
	ecsFunctions.init()
	establishPhysicsWorld()		-- creates borders, starbase and player vessel and player physics
	for i = 1, NUMBER_OF_ASTEROIDS do
		fun.createAsteroid()
	end
	local x1, y1 = fun.getPhysEntityXY(PLAYER.UID)
	cam = Camera.new(x1, y1, 1)		-- this is a global cam

	RECEIPT = {}
	local item = {}
	item.description = "Opening balance"
	item.amount = 0
	table.insert(RECEIPT, item)

	TRANSLATEX = (x1 * BOX2D_SCALE)
	TRANSLATEY = (y1 * BOX2D_SCALE)
    ZOOMFACTOR = 0.4

end

return functions
