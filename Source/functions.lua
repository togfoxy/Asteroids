functions = {}

function functions.loadImages()
	-- terrain tiles
	IMAGES[enum.imagesEngineFlame] = love.graphics.newImage("assets/images/flame.png")

end

function functions.loadAudio()
    AUDIO[enum.audioEngine] = love.audio.newSource("assets/audio/engine.ogg", "static")
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
        if PHYSICS_ENTITIES[i].fixture:getUserData() == uid then
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
        return physEntity.body:getX(), physEntity.body:getY()
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
    local totalsize = STARTING_SIZE
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
	asteroidpoints = {}
	
	-- first point is random heading and distance from origin
	local bearing = love.math.random(0,359)
	local distance = love.math.random(5,20)		-- physics metres
	x[1], y[1] = cf.AddVectorToPoint(x0,y0,0,distance)			--! see if this zero can be more random
	
	table.insert(asteroidpoints, x[1] * BOX2D_SCALE)
	table.insert(asteroidpoints, y[1] * BOX2D_SCALE)
	
	-- print(x[1],y[1])
	
	-- keep adding vectors in a clockwise direction
	local bestangle = 360 / numsegments		-- use this number to form a perfect polygon
	local segmentheading = 0				-- first point is pointing north.
	for i = 2, (numsegments) do
		-- local distance = love.math.random(1,5)		-- physics metres
		segmentheading = cf.adjustHeading(segmentheading, bestangle)
		x[i],y[i] = cf.AddVectorToPoint(x[i-1], y[i-1], segmentheading, distance)
		
		table.insert(asteroidpoints, x[i] * BOX2D_SCALE)
		table.insert(asteroidpoints, y[i] * BOX2D_SCALE)
		
		-- print(x[i],y[i])
	end

	table.insert(asteroidpoints, x[1] * BOX2D_SCALE)
	table.insert(asteroidpoints, y[1] * BOX2D_SCALE)
	
	
	
	
	-- create physical object
	-- draw asteroid (elsewhere)
	
	
	
	


end

return functions
