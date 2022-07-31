fileops = {}

function fileops.saveGame()
    -- local vessel_table = prepVessel()

    local entity = fun.getEntity(PLAYER.UID)        -- this has to be before "get size" function
    local physicsEntity = fun.getPhysEntity(PLAYER.UID)

    local x,y = physicsEntity.body:getPosition()
    local temptable = physicsEntity.fixture:getUserData()

    local savetable = {}
    savetable.x = x
    savetable.y = y
    savetable.objectType = temptable.objectType

    local savedir = love.filesystem.getSourceBaseDirectory( )

    -- vessel entity
    local savefile = savedir .. "\\savedata\\" .. "vessel.dat"
    local str = entity:serialize()
    local serialisedString = bitser.dumps(str)
    local success, message = nativefs.write(savefile, serialisedString)

    -- save the physical object
    local savefile = savedir .. "\\savedata\\" .. "vessel_physics.dat"
    local serialisedString = bitser.dumps(savetable)
    local success1, message = nativefs.write(savefile, serialisedString)

    -- player global table
    local savefile = savedir .. "\\savedata\\" .. "globals.dat"
    local serialisedString = bitser.dumps(PLAYER)
    local success2, message = nativefs.write(savefile, serialisedString)

    -- asteroids    --! need to create a custom table for serialising
    -- local savefile = savedir .. "\\savedata\\" .. "asteroids.dat"
    -- local serialisedString = bitser.dumps(PHYSICS_ENTITIES)
    -- local success2, message = nativefs.write(savefile, serialisedString)

    print(savefile, success, message)
    if success and success1 and success2 then
        lovelyToasts.show("Game saved",5)
    else
        lovelyToasts.show("Save failed", 5)
    end
end

function fileops.loadGame()

    local loaderror = false
    local entity = fun.getEntity(PLAYER.UID)
    local physEntity = fun.getPhysEntity(PLAYER.UID)

    local savedir = love.filesystem.getSourceBaseDirectory( )
    local savefile = savedir .. "\\savedata\\" .. "vessel.dat"
	if nativefs.getInfo(savefile) then
		contents, size = nativefs.read(savefile)
	    local str = bitser.loads(contents)
        entity:deserialize(str)
    else
        loaderror = true
	end

    -- load physics object
    local savefile = savedir .. "\\savedata\\" .. "vessel_physics.dat"
	if nativefs.getInfo(savefile) then
		contents, size = nativefs.read(savefile)
	    local savetable = bitser.loads(contents)

        local shipsize = fun.getEntitySize(entity)
        physEntity.body:setPosition(savetable.x, savetable.y)
    	physEntity.fixture:setSensor(false)

        local temptable = {}
    	temptable.uid = entity.uid.value
    	temptable.objectType = savetable.objectType
    	physEntity.fixture:setUserData(temptable)

        fun.changeShipPhysicsSize(entity)
    else
        loaderror = true
	end

    -- load player global table
    local savefile = savedir .. "\\savedata\\" .. "globals.dat"
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
