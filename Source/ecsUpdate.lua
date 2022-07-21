ecsUpdate = {}

local function activateMiningLaser(dt)

	x, y = love.mouse.getPosition( )
	local wx,wy = cam:toWorld(x, y)		-- converts screen x/y to world x/y
	local bx = wx / BOX2D_SCALE			-- converts world x/y to BOX2D x/y
	local by = wy / BOX2D_SCALE

	local playerEntity = fun.getEntity(PLAYER.UID)
	local playerPE = fun.getPhysEntity(PLAYER.UID)

	-- get distance between player and mouse click
	local x0,y0 = playerPE.body:getPosition()
	local distance = cf.GetDistance(x0, y0, bx, by)
	-- print(x0, y0, bx, by)
	-- print("dist = " .. distance)

	if distance <= playerEntity.miningLaser.miningRange then
		for _, asteroid in pairs(PHYSICSWORLD:getBodies()) do		-- this is bodies - not entities
			for _, fixture in pairs(asteroid:getFixtures()) do
				local temptable = fixture:getUserData()
				if temptable.objectType == "Asteroid" then			-- make this an enum
					local hit = fixture:testPoint(bx, by)
					if hit then
						local physicsEntity = fun.getPhysEntity(temptable.uid)
						physicsEntity.currentMass = physicsEntity.currentMass - (playerEntity.miningLaser.miningRate * dt)
						-- print(cf.round(asteroid.currentMass))
						DRAW.miningLaser = true
						DRAW.miningLaserX = bx
						DRAW.miningLaserY = by
						SOUND.miningLaser = true
						if physicsEntity.currentMass <= 0 then
							fun.killPhysicsEntity(physicsEntity)
							SOUND.rockExplosion = true
						end
					end
				end
			end
		end
	end
end

function ecsUpdate.init()
    systemEngine = concord.system({
        pool = {"engine"}
    })
    function systemEngine:update(dt)
        for _, entity in ipairs(self.pool) do
            local physEntity = fun.getPhysEntity(entity.uid.value)
            local x1 = physEntity.body:getX()
            local y1 = physEntity.body:getY()

            if love.keyboard.isDown("kp8") then
                if entity.engine.currentHP <= 0 then
                    SOUND.warning = true
                    break
                end
                if entity:has("fuelTank") then
                    if entity.fuelTank.currentHP <= 0 then
                        SOUND.warning = true
                        break
                    elseif entity.fuelTank.capacity <= 0 then
                        SOUND.lowFuel = true
                        break
                    end
                else
                    SOUND.warning = true
                    break
                end

                local facing = physEntity.body:getAngle()       -- radians. 0 = "right"
                facing = cf.convRadToCompass(facing)

                local vectordistance = entity.engine.strength      -- amount of force

        		local x2, y2 = cf.AddVectorToPoint(x1, y1, facing, vectordistance)
        		local xvector = (x2 - x1) * 20 * dt
        		local yvector = (y2 - y1) * 20 * dt

        		physEntity.body:applyForce(xvector, yvector)		-- the amount of force = vector distance

                entity.fuelTank.capacity = entity.fuelTank.capacity - (vectordistance / FUEL_CONSUMPTION_RATE)

                SOUND.engine = true
                DRAW.engineFlame = true

            end
        end
    end
    ECSWORLD:addSystems(systemEngine)

    systemLeftThruster = concord.system({
        pool = {"leftThruster"}
    })
    function systemLeftThruster:update(dt)
        for _, entity in ipairs(self.pool) do

            if love.keyboard.isDown("kp6") then
                if entity.leftThruster.currentHP <= 0 then
                    SOUND.warning = true
                    break
                end
                if entity:has("fuelTank") then
                    if entity.fuelTank.currentHP <= 0 then
                        SOUND.warning = true
                        break
                    elseif entity.fuelTank.capacity <= 0 then
                        SOUND.lowFuel = true
                        break
                    end
                else
                    SOUND.warning = true
                    break
                end

                local physEntity = fun.getPhysEntity(entity.uid.value)

                local facing = physEntity.body:getAngle()       -- radians. 0 = "right"
                facing = cf.convRadToCompass(facing)
                facing = cf.adjustHeading(facing, 90)

                local vectordistance = entity.leftThruster.strength      -- amount of force
                local x1 = physEntity.body:getX()
                local y1 = physEntity.body:getY()

        		local x2, y2 = cf.AddVectorToPoint(x1, y1, facing, vectordistance)
        		local xvector = (x2 - x1) * 20 * dt
        		local yvector = (y2 - y1) * 20 * dt

        		physEntity.body:applyForce(xvector, yvector)		-- the amount of force = vector distance

                entity.fuelTank.capacity = entity.fuelTank.capacity - (vectordistance / FUEL_CONSUMPTION_RATE)

                SOUND.engine = true
                DRAW.leftFlame = true

            end
            if entity:has("fuelTank") and love.keyboard.isDown("kp9") then
                -- rotate clockwise
                local physEntity = fun.getPhysEntity(entity.uid.value)
                physEntity.body:applyTorque(entity.leftThruster.strength)
            end
        end
    end
    ECSWORLD:addSystems(systemLeftThruster)

    systemRightThruster = concord.system({
        pool = {"rightThruster"}
    })
    function systemRightThruster:update(dt)
        for _, entity in ipairs(self.pool) do

            if love.keyboard.isDown("kp4") then
                if entity.rightThruster.currentHP <= 0 then
                    SOUND.warning = true
                    break
                end
                if entity:has("fuelTank") then
                    if entity.fuelTank.currentHP <= 0 then
                        SOUND.warning = true
                        break
                    elseif entity.fuelTank.capacity <= 0 then
                        SOUND.lowFuel = true
                        break
                    end
                else
                    SOUND.warning = true
                    break
                end

                local physEntity = fun.getPhysEntity(entity.uid.value)

                local facing = physEntity.body:getAngle()       -- radians. 0 = "right"
                facing = cf.convRadToCompass(facing)

                facing = cf.adjustHeading(facing, -90)      -- thrust to the left

                local vectordistance = entity.rightThruster.strength      -- amount of force
                local x1 = physEntity.body:getX()
                local y1 = physEntity.body:getY()

        		local x2, y2 = cf.AddVectorToPoint(x1, y1, facing, vectordistance)
        		local xvector = (x2 - x1) * 20 * dt
        		local yvector = (y2 - y1) * 20 * dt

        		physEntity.body:applyForce(xvector, yvector)		-- the amount of force = vector distance

                entity.fuelTank.capacity = entity.fuelTank.capacity - (vectordistance / FUEL_CONSUMPTION_RATE)

                SOUND.engine = true
                DRAW.rightFlame = true

            end
            if entity:has("fuelTank") and love.keyboard.isDown("kp7") then
                -- rotate anti-clockwise
                local physEntity = fun.getPhysEntity(entity.uid.value)
                physEntity.body:applyTorque(entity.leftThruster.strength * -1)
            end
        end
    end
    ECSWORLD:addSystems(systemRightThruster)

    systemReverseThruster = concord.system({
        pool = {"reverseThruster"}
    })
    function systemReverseThruster:update(dt)
        for _, entity in ipairs(self.pool) do

            if love.keyboard.isDown("kp2") then
                if entity.rightThruster.currentHP <= 0 then
                    SOUND.warning = true
                    break
                end
                if entity:has("fuelTank") then
                    if entity.fuelTank.currentHP <= 0 then
                        SOUND.warning = true
                        break
                    elseif entity.fuelTank.capacity <= 0 then
                        SOUND.lowFuel = true
                        break
                    end
                else
                    SOUND.warning = true
                    break
                end

                local physEntity = fun.getPhysEntity(entity.uid.value)

                local facing = physEntity.body:getAngle()       -- radians. 0 = "right"
                facing = cf.convRadToCompass(facing)
                facing = cf.adjustHeading(facing, 180)

                local vectordistance = entity.reverseThruster.strength      -- amount of force
                local x1 = physEntity.body:getX()
                local y1 = physEntity.body:getY()

                local x2, y2 = cf.AddVectorToPoint(x1, y1, facing, vectordistance)
                local xvector = (x2 - x1) * 20 * dt
                local yvector = (y2 - y1) * 20 * dt

                physEntity.body:applyForce(xvector, yvector)		-- the amount of force = vector distance

                entity.fuelTank.capacity = entity.fuelTank.capacity - (vectordistance / FUEL_CONSUMPTION_RATE)

                SOUND.engine = true
                DRAW.reverseFlame = true

            end
        end
    end
    ECSWORLD:addSystems(systemReverseThruster)

    systemMiningLaser = concord.system({
        pool = {"miningLaser"}
    })
    function systemMiningLaser:update(dt)
        if love.mouse.isDown(1) then
            for _, entity in ipairs(self.pool) do
                if entity.miningLaser.currentHP >=0 then
                    if entity:has("battery") then
                        if entity.battery.capacity >= 0 then
                            activateMiningLaser(dt)
                            entity.battery.capacity = entity.battery.capacity - dt
                            if  entity.battery.capacity <= 0 then  entity.battery.capacity = 0 end
                        end
                    end
                end
            end
        end
    end
    ECSWORLD:addSystems(systemMiningLaser)
end

return ecsUpdate
