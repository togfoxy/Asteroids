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

    local shipsize = fun.getEntitySize(entity)
    local physicsEntity = fun.getPhysEntity
    local x,y = physicsEntity.getPosition()
    savetable.shipsize = shipsize
    savetable.x = x
    savetable.y = y
    savetable.objectType = "Player" 

    local savedir = love.filesystem.getSourceBaseDirectory( )
    local savefile = savedir .. "\\savedata\\" .. "vessel.dat"

    local entity = fun.getEntity(PLAYER.UID)
    local str = entity:serialize()
    local serialisedString = bitser.dumps(str)
    local success, message = nativefs.write(savefile, serialisedString)
    print(success, message)
end

function fileops.loadGame()

    local savedir = love.filesystem.getSourceBaseDirectory( )
    local savefile = savedir .. "\\savedata\\" .. "vessel.dat"
	if nativefs.getInfo(savefile) then
		contents, size = nativefs.read(savefile)
        print(size)
	    local str = bitser.loads(contents)
        local entity = fun.getEntity(PLAYER.UID)
        entity:deserialize(str)
    else
		error = true
	end

end

return fileops
