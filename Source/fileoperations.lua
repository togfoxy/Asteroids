fileops = {}



local function prepVessel()
    local entity = fun.getEntity(PLAYER.UID)

    local VESSEL_SAVE_TABLE = {}            --! should be lower case

    VESSEL_SAVE_TABLE.uid = PLAYER.UID

    if entity:has("chassis") then
        VESSEL_SAVE_TABLE.chassis = true
        VESSEL_SAVE_TABLE.chassissize = entity.chassis.size
        VESSEL_SAVE_TABLE.chassismaxHP = entity.chassis.maxHP
        VESSEL_SAVE_TABLE.chassiscurrentHP = entity.chassis.maxHP
        VESSEL_SAVE_TABLE.chassisdescription = entity.chassis.description
    end
    if entity:has("engine") then
        VESSEL_SAVE_TABLE.engine = true
        VESSEL_SAVE_TABLE.enginesize = entity.engine.size
		VESSEL_SAVE_TABLE.enginestrength = entity.engine.strength
		VESSEL_SAVE_TABLE.enginemaxHP = entity.engine.maxHP
		VESSEL_SAVE_TABLE.enginecurrentHP = entity.engine.maxHP
		VESSEL_SAVE_TABLE.enginedescription = entity.engine.description
    end
    if entity:has("leftThruster") then
        VESSEL_SAVE_TABLE.leftThruster = true
		VESSEL_SAVE_TABLE.leftThrustersize = entity.leftThruster.size
		VESSEL_SAVE_TABLE.leftThrusterstrength = entity.leftThruster.strength
		VESSEL_SAVE_TABLE.leftThrustermaxHP = entity.leftThruster.maxHP
		VESSEL_SAVE_TABLE.leftThrustercurrentHP = entity.leftThruster.maxHP
		VESSEL_SAVE_TABLE.leftThrusterdescription = entity.leftThruster.description
    end
    if entity:has("rightThruster") then
        VESSEL_SAVE_TABLE.rightThruster = true
		VESSEL_SAVE_TABLE.rightThrustersize = entity.rightThruster.size
		VESSEL_SAVE_TABLE.rightThrusterstrength = entity.rightThruster.strength
		VESSEL_SAVE_TABLE.rightThrustermaxHP = entity.rightThruster.maxHP
		VESSEL_SAVE_TABLE.rightThrustercurrentHP = entity.rightThruster.maxHP
		VESSEL_SAVE_TABLE.rightThrusterdescription = entity.rightThruster.description
    end
    if entity:has("reverseThruster") then
        VESSEL_SAVE_TABLE.reverseThruster = true
		VESSEL_SAVE_TABLE.reverseThrustersize = entity.reverseThruster.size
		VESSEL_SAVE_TABLE.reverseThrusterstrength = entity.reverseThruster.strength
		VESSEL_SAVE_TABLE.reverseThrustermaxHP = entity.reverseThruster.maxHP
		VESSEL_SAVE_TABLE.reverseThrustercurrentHP = entity.reverseThruster.maxHP
		VESSEL_SAVE_TABLE.reverseThrusterdescription = entity.reverseThruster.description
    end

    if entity:has("fuelTank") then
		VESSEL_SAVE_TABLE.fuelTanksize = entity.fuelTank.size
		VESSEL_SAVE_TABLE.fuelTankcapacity = entity.fuelTank.capacity
		VESSEL_SAVE_TABLE.fuelTankmaxCapacity = entity.fuelTank.maxCapacity
		VESSEL_SAVE_TABLE.fuelTankmaxHP = entity.fuelTank.maxHP
		VESSEL_SAVE_TABLE.fuelTankcurrentHP = entity.fuelTank.maxHP
		VESSEL_SAVE_TABLE.fuelTankdescription = entity.fuelTank.description
    end
    if entity:has("miningLaser") then
        VESSEL_SAVE_TABLE.miningLasersize = entity.miningLaser.size
		VESSEL_SAVE_TABLE.miningLaserminingRate = entity.miningLaser.miningRate
		VESSEL_SAVE_TABLE.miningLaserminingRange = entity.miningLaser.miningRange
		VESSEL_SAVE_TABLE.miningLasermaxHP = entity.miningLaser.maxHP
		VESSEL_SAVE_TABLE.miningLasercurrentHP = entity.miningLaser.maxHP
		VESSEL_SAVE_TABLE.miningLaserdescription = entity.miningLaser.description
    end
    if entity:has("battery") then
        VESSEL_SAVE_TABLE.batterysize = entity.battery.size
		VESSEL_SAVE_TABLE.batterycapacity = entity.battery.capacity
		VESSEL_SAVE_TABLE.batterymaxCapacity = entity.battery.maxCapacity
		VESSEL_SAVE_TABLE.batterymaxHP = entity.battery.maxHP
		VESSEL_SAVE_TABLE.batterycurrentHP = entity.battery.maxHP
		VESSEL_SAVE_TABLE.batterydescription = entity.battery.description
    end
    if entity:has("oxyGenerator") then
        VESSEL_SAVE_TABLE.oxyGeneratorsize = entity.oxyGenerator.size
		VESSEL_SAVE_TABLE.oxyGeneratorpowerNeeds = entity.oxyGenerator.powerNeeds
		VESSEL_SAVE_TABLE.oxyGeneratormaxHP = entity.oxyGenerator.maxHP
		VESSEL_SAVE_TABLE.oxyGeneratorcurrentHP = entity.oxyGenerator.maxHP
        VESSEL_SAVE_TABLE.oxyGeneratordescription = entity.oxyGenerator.description
    end
    if entity:has("oxyTank") then
        VESSEL_SAVE_TABLE.oxyTanksize = entity.oxyTank.size
        VESSEL_SAVE_TABLE.oxyTankcapacity = entity.oxyTank.capacity
        VESSEL_SAVE_TABLE.oxyTankmaxCapacity = entity.oxyTank.maxCapacity
        VESSEL_SAVE_TABLE.oxyTankmaxHP = entity.oxyTank.maxHP
        VESSEL_SAVE_TABLE.oxyTankcurrentHP = entity.oxyTank.maxHP
        VESSEL_SAVE_TABLE.oxyTankdescription = entity.oxyTank.description
    end
    if entity:has("solarPanel") then
        VESSEL_SAVE_TABLE.solarPanelsize = entity.solarPanel.size
        VESSEL_SAVE_TABLE.solarPanelrechargeRate = entity.solarPanel.rechargeRate
        VESSEL_SAVE_TABLE.solarPanelmaxHP = entity.solarPanel.maxHP
        VESSEL_SAVE_TABLE.solarPanelcurrentHP = entity.solarPanel.maxHP
        VESSEL_SAVE_TABLE.solarPaneldescription = entity.solarPanel.description
    end
    if entity:has("cargoHold") then
        VESSEL_SAVE_TABLE.cargoHoldsize = entity.cargoHold.size
        VESSEL_SAVE_TABLE.cargoHoldmaxAmount = entity.cargoHold.maxAmount
        VESSEL_SAVE_TABLE.cargoHoldcurrentAmount = entity.cargoHold.currentAmount
        VESSEL_SAVE_TABLE.cargoHoldmaxHP = entity.cargoHold.maxHP
        VESSEL_SAVE_TABLE.cargoHoldcurrentHP = entity.cargoHold.maxHP
        VESSEL_SAVE_TABLE.cargoHolddescription = entity.cargoHold.description
    end
    if entity:has("spaceSuit") then
        VESSEL_SAVE_TABLE.spaceSuitsize = entity.spaceSuit.size
		VESSEL_SAVE_TABLE.spaceSuitO2capacity = entity.spaceSuit.O2capacity
		VESSEL_SAVE_TABLE.spaceSuitmaxO2Capacity = entity.spaceSuit.maxO2Capacity
		VESSEL_SAVE_TABLE.spaceSuitdescription = entity.spaceSuit.description
    end

    return VESSEL_SAVE_TABLE
end


function fileops.saveGame()


     local vessel_table = prepVessel()

     local savedir = love.filesystem.getSourceBaseDirectory( )
     local savefile = savedir .. "\\savedata\\" .. "vessel.dat"
     local serialisedString = bitser.dumps(vessel_table)
     local success, message = nativefs.write(savefile, serialisedString)

     print(savedir)
     print(savefile)
     print(success, message)



end

return fileops
