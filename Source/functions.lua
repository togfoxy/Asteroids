functions = {}

function functions.loadImages()

	IMAGES[enum.imagesEngineFlame] = love.graphics.newImage("assets/images/flame.png")
	IMAGES[enum.imagesVessel] = love.graphics.newImage("assets/images/ship1.png")

	-- background
	IMAGES[enum.imagesBackgroundStatic] = love.graphics.newImage("assets/images/bg_space_seamless_2.png")
	IMAGES[enum.imagesDead] = love.graphics.newImage("assets/images/dead.jpg")
end

function functions.loadAudio()
    AUDIO[enum.audioEngine] = love.audio.newSource("assets/audio/engine.ogg", "static")
	AUDIO[enum.audioLowFuel] = love.audio.newSource("assets/audio/lowFuel.ogg", "static")
	AUDIO[enum.audioWarning] = love.audio.newSource("assets/audio/507906__m-cel__warning-sound.ogg", "static")
	AUDIO[enum.audioMiningLaser] = love.audio.newSource("assets/audio/223472__parabolix__underground-machine-heart-loop.mp3", "static")
	AUDIO[enum.audioRockExplosion] = love.audio.newSource("assets/audio/cannon_hit.ogg", "static")
end

function functions.loadFonts()
    FONT[enum.fontHeavyMetalLarge] = love.graphics.newFont("assets/fonts/Heavy Metal Box.ttf")
    FONT[enum.fontHeavyMetalSmall] = love.graphics.newFont("assets/fonts/Heavy Metal Box.ttf",10)
    FONT[enum.fontDefault] = love.graphics.newFont("assets/fonts/Vera.ttf", 12)
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
	asteroid.fixture:setUserData(temptable)		--
	asteroid.originalMass = asteroid.body:getMass()
	asteroid.currentMass = asteroid.originalMass

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
			if Component.size >= rndnum	then
				return Component
			else
				rndnum = rndnum - Component.size
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

function functions.killPhysicsEntity(entity)
    -- unit test
    local physicsOrigsize = #PHYSICS_ENTITIES
    --

	--!ensure this is only done to asteroids. Perhaps change name of function

    -- destroy the body then remove empty body from the array
    for i = 1, #PHYSICS_ENTITIES do		-- needs to be a for i loop so we can do a table remove
        if PHYSICS_ENTITIES[i] == entity then
            PHYSICS_ENTITIES[i].body:destroy()
            table.remove(PHYSICS_ENTITIES, i)
            break
        end
    end

    -- unit test
    assert(#PHYSICS_ENTITIES < physicsOrigsize)
end

function functions.checkIfDead(dt)
	-- returns nothing (is a sub that returns nothing)
	local entity = fun.getEntity(PLAYER.UID)
	if entity.chassis.currentHP <= 0 then
		DEAD_ALPHA = DEAD_ALPHA + (dt * 0.25)

		if DEAD_ALPHA >= 1 then
			cf.SwapScreen("Dead", SCREEN_STACK)
		end


		--! do other 'dead' clean ups here
	end
end
return functions
