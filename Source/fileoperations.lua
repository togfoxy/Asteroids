fileops = {}

function fileops.saveGame()

    local entity = fun.getEntity(PLAYER.UID)        -- this has to be before "get size" function
    local physicsEntity = fun.getPhysEntity(PLAYER.UID)

    local x,y = physicsEntity.body:getPosition()
    local temptable = physicsEntity.fixture:getUserData()



    local savedir = love.filesystem.getSourceBaseDirectory( )

    -- vessel entity
    local savefile
    if love.filesystem.isFused() then
        savedir = savedir .. "\\savedata\\"
    else
        savedir = savedir .. "/Source/savedata/"
    end

    savefile = savedir .. "vessel.dat"
    local str = entity:serialize()
    local serialisedString = bitser.dumps(str)
    local success, message = nativefs.write(savefile, serialisedString)

    -- save the key data for the physical object
    local savetable = {}
    savetable.x = x
    savetable.y = y
    savetable.uid = entity.uid.value

print("Beta" .. savetable.uid)

    savetable.objectType = temptable.objectType

    local savefile = savedir .. "vessel_physics.dat"
    local serialisedString = bitser.dumps(savetable)
    local success1, message = nativefs.write(savefile, serialisedString)

    -- player global table
    local savefile = savedir .. "globals.dat"
    local serialisedString = bitser.dumps(PLAYER)
    local success2, message = nativefs.write(savefile, serialisedString)

    -- asteroids    --! need to create a custom table for serialising
    -- local savefile = savedir .. "\\savedata\\" .. "asteroids.dat"
    -- local serialisedString = bitser.dumps(PHYSICS_ENTITIES)
    -- local success2, message = nativefs.write(savefile, serialisedString)

    -- print(savefile, success, message)
    if success and success1 and success2 then
        lovelyToasts.show("Game saved",5)
    else
        lovelyToasts.show("Save failed", 5)
    end
end

function fileops.loadGame()
    -- calls InitialiseGame which already establishes a bunch of stuff

    local loaderror = false     --! need to fix this

    fun.InitialiseGame()

    local savedir = love.filesystem.getSourceBaseDirectory( )
    local savefile
    if love.filesystem.isFused() then
        savedir = savedir .. "\\savedata\\"
    else
        savedir = savedir .. "/Source/savedata/"
    end

    -- local entity = concord.entity(ECSWORLD)
    local entity = fun.getEntity(PLAYER.UID)
    local savefile = savedir .. "vessel.dat"
	if nativefs.getInfo(savefile) then
		contents, size = nativefs.read(savefile)
	    local str = bitser.loads(contents)
        entity:deserialize(str)
        -- table.insert(ECS_ENTITIES, entity)
    else
        loaderror = true
	end
    assert(loaderror == false)



    -- load physics object
    local physEntity = fun.getPhysEntity(PLAYER.UID)
    local savefile = savedir .. "vessel_physics.dat"
	if nativefs.getInfo(savefile) then
		contents, size = nativefs.read(savefile)
	    local savetable = bitser.loads(contents)

        physEntity.body:setPosition(savetable.x, savetable.y)

        -- load the whole temp table here so can save the whole temp table later
        local temptable = {}
        temptable.x = savetable.x
        temptable.y = savetable.y
    	temptable.uid = savetable.uid
    	temptable.objectType = savetable.objectType
    	physEntity.fixture:setUserData(temptable)

-- print("alpha" .. savetable.uid, PLAYER.UID)

    else
        loaderror = true
	end

    -- load player global table
    local savefile = savedir .. "globals.dat"
	if nativefs.getInfo(savefile) then
		contents, size = nativefs.read(savefile)
	    PLAYER = bitser.loads(contents)
    else
        loaderror = true
    end

    if loaderror then
        lovelyToasts.show("Game failed to load",5)
    else
        lovelyToasts.show("Game loaded",5)
    end
end
return fileops
