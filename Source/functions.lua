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

return functions
