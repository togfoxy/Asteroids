fileops = {}

local function prepVessel()
     -- physics objects


    return VESSEL_SAVE_TABLE
end

local function loadFromVesselTable(savetable)

    PLAYER.UID = savetable.uid
    local entity = fun.getEntity(PLAYER.UID)

    -- destroy the physical object
    killPhysicsEntity(entity)
    -- destroy the ecs object
    killECSEntity(entity)

    -- create the ecs object
    if savetable.chassis ~= nil then
        entity:give("chassis")
        entity.chassis.size = savetable.chassissize
        entity.chassis.maxHP = savetable.chassismaxHP
        entity.chassis.maxHP = savetable.chassiscurrentHP
        entity.chassis.description = savetable.chassisdescription
    end
    if savetable.engine ~= nil then
        entity:give("engine")
        entity.engine.size = savetable.enginesize
		entity.engine.strength = savetable.enginestrength
		entity.engine.maxHP = savetable.enginemaxHP
		entity.engine.maxHP = savetable.enginecurrentHP
		entity.engine.description = savetable.enginedescription
    end
    if savetable.leftThruster ~= nil then
        entity:give("leftThruster")
		entity.leftThruster.size = savetable.leftThrustersize
		entity.leftThruster.strength = savetable.leftThrusterstrength
		entity.leftThruster.maxHP = savetable.leftThrustermaxHP
		entity.leftThruster.currentHP = savetable.leftThrustermaxHP
		entity.leftThruster.description = savetable.leftThrusterdescription
    end



    -- create the physical object

end

function fileops.saveGame()
    -- local vessel_table = prepVessel()

    local entity = fun.getEntity(PLAYER.UID)        -- this has to be before "get size" function
    local physicsEntity = fun.getPhysEntity(PLAYER.UID)

    local x,y = physicsEntity.body:getPosition()
--local shipsize = fun.getEntitySize(entity)
    -- savetable.shipsize = shipsize
    local savetable = {}
    savetable.x = x
    savetable.y = y
    savetable.objectType = "Player"

    local savedir = love.filesystem.getSourceBaseDirectory( )
    local savefile = savedir .. "\\savedata\\" .. "vessel.dat"

    local str = entity:serialize()
    local serialisedString = bitser.dumps(str)
    local success, message = nativefs.write(savefile, serialisedString)
    print(savefile, success, message)

    -- save the physical object
    local savefile = savedir .. "\\savedata\\" .. "vessel_physics.dat"
    local serialisedString = bitser.dumps(savetable)
    local success1, message = nativefs.write(savefile, serialisedString)
    print(savefile, success, message)
    if success and success1 then
        lovelyToasts.show("Game saved",5)
    else
        lovelyToasts.show("Save failed", 5)
    end
end

function fileops.loadGame()

    local entity = fun.getEntity(PLAYER.UID)
    local physEntity = fun.getPhysEntity(PLAYER.UID)


    local savedir = love.filesystem.getSourceBaseDirectory( )
    local savefile = savedir .. "\\savedata\\" .. "vessel.dat"
	if nativefs.getInfo(savefile) then
		contents, size = nativefs.read(savefile)
	    local str = bitser.loads(contents)
        entity:deserialize(str)
    else
        --! make this error trapping a bit more sophisticated
	end

    -- load physics object
    local savefile = savedir .. "\\savedata\\" .. "vessel_physics.dat"
	if nativefs.getInfo(savefile) then
		contents, size = nativefs.read(savefile)
	    local savetable = bitser.loads(contents)

        local shipsize = fun.getEntitySize(entity)
        physEntity.body:setPosition(savetable.x, savetable.y)
    	physEntity.fixture:setSensor(false)
        fun.changeShipPhysicsSize(entity)

        lovelyToasts.show("Game loaded",5)
    else
        lovelyToasts.show("Game failed to load",5)
	end
end

return fileops
