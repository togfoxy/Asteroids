ecsUpdate = {}

local function ejectPlayer(entity)
	-- kills the player ECS
	-- kills the play physics object
	-- creates a new ECS
	-- creates a new physics object
	local physEntity = fun.getPhysEntity(PLAYER.UID)

	local playerx, playery = physEntity.body:getPosition()		-- BOX2D x and y

	fun.killECSEntity(entity)
	fun.killPhysicsEntity(physEntity)

	local newentity = concord.entity(ECSWORLD)
	:give("drawable")
    :give("uid")
	:give("chassis")
	:give("oxyTank")
	:give("SOSBeacon")

	table.insert(ECS_ENTITIES, newentity)
	PLAYER.UID = newentity.uid.value 		-- store this for easy recall

	local shipsize = fun.getEntitySize(newentity)
	local physicsEntity = {}
    physicsEntity.body = love.physics.newBody(PHYSICSWORLD, playerx, playery, "dynamic")
	physicsEntity.body:setLinearDamping(0)
	-- physicsEntity.body:setMass(500)		-- kg		-- made redundant by newFixture
	physicsEntity.shape = love.physics.newRectangleShape(shipsize, shipsize)		-- will draw a rectangle around the body x/y. No need to offset it
	physicsEntity.fixture = love.physics.newFixture(physicsEntity.body, physicsEntity.shape, PHYSICS_DENSITY)		-- the 1 is the density
	physicsEntity.fixture:setRestitution(0.1)		-- between 0 and 1
	physicsEntity.fixture:setSensor(false)

	local temptable = {}
	temptable.uid = newentity.uid.value
	temptable.objectType = "Pod"
	physicsEntity.fixture:setUserData(temptable)		-- links the physics object to the ECS entity

    table.insert(PHYSICS_ENTITIES, physicsEntity)

end

local function activateMiningLaser(dt)

	x, y = love.mouse.getPosition()
	local wx,wy = cam:toWorld(x, y)		-- converts screen x/y to world x/y
	local bx = wx / BOX2D_SCALE			-- converts world x/y to BOX2D x/y
	local by = wy / BOX2D_SCALE

	local playerEntity = fun.getEntity(PLAYER.UID)		--! need to start passing ENTITY as a parameter more often
	local playerPE = fun.getPhysEntity(PLAYER.UID)

	-- get distance between player and mouse click
	local x0,y0 = playerPE.body:getPosition()
	local distance = cf.GetDistance(x0, y0, bx, by)

	if distance <= playerEntity.miningLaser.miningRange then
		for _, asteroid in pairs(PHYSICSWORLD:getBodies()) do		-- this is bodies - not entities
			for _, fixture in pairs(asteroid:getFixtures()) do
				local temptable = fixture:getUserData()
				if temptable.objectType == "Asteroid" then			-- make this an enum
					local hit = fixture:testPoint(bx, by)
					if hit then
						local physicsEntity = fun.getPhysEntity(temptable.uid)
						local massMoved = (playerEntity.miningLaser.miningRate * dt)
						physicsEntity.currentMass = physicsEntity.currentMass - massMoved
						-- print(cf.round(asteroid.currentMass))
						playerEntity.cargoHold.currentAmount = playerEntity.cargoHold.currentAmount + massMoved
						if playerEntity.cargoHold.currentAmount > playerEntity.cargoHold.maxAmount then playerEntity.cargoHold.currentAmount = playerEntity.cargoHold.maxAmount end

						DRAW.miningLaser = true
						DRAW.miningLaserX = bx
						DRAW.miningLaserY = by
						if love.math.random(1,100) == 1 then
							-- add bubble text
							local newbubble = {}
							newbubble.text = cf.round(math.max(massMoved, 1))
							newbubble.timeleft = 4
							newbubble.x = x --  * BOX2D_SCALE
							newbubble.y = y --  * BOX2D_SCALE
							table.insert(BUBBLE, newbubble)

						end

						SOUND.miningLaser = true
						if physicsEntity.currentMass <= 0 then
							fun.killPhysicsEntity(physicsEntity)
							SOUND.rockExplosion = true
							if PLAYER.ROCKSKILLED == nil then PLAYER.ROCKSKILLED = 0 end
							PLAYER.ROCKSKILLED = PLAYER.ROCKSKILLED + 1
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
                    elseif fun.getFuelBurnTime() <= 10 then
                        SOUND.lowFuel = true
                    end
                else
                    SOUND.warning = true
                    break
                end

				if fun.getFuelBurnTime() > 0 then
	                local facing = physEntity.body:getAngle()       -- radians. 0 = "right"
	                facing = cf.convRadToCompass(facing)

	                local vectordistance = entity.engine.strength      -- amount of force

	        		local x2, y2 = cf.AddVectorToPoint(x1, y1, facing, vectordistance)
	        		local xvector = (x2 - x1) * 20 * dt
	        		local yvector = (y2 - y1) * 20 * dt

	        		physEntity.body:applyForce(xvector, yvector)		-- the amount of force = vector distance

					local fuelused = vectordistance * dt
	                entity.fuelTank.capacity = entity.fuelTank.capacity - fuelused

	                SOUND.engine = true
	                DRAW.engineFlame = true
				end
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
                    elseif fun.getFuelBurnTime() <= 10 then
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
            if love.keyboard.isDown("kp9") and entity:has("fuelTank") and entity.leftThruster.currentHP > 0 then
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
                    elseif fun.getFuelBurnTime() <= 10 then
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
            if love.keyboard.isDown("kp7") and entity:has("fuelTank") and entity.rightThruster.currentHP > 0 then
                -- rotate anti-clockwise
                local physEntity = fun.getPhysEntity(entity.uid.value)
                physEntity.body:applyTorque(entity.rightThruster.strength * -1)
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
                if entity.reverseThruster.currentHP <= 0 then
                    SOUND.warning = true
                    break
                end
                if entity:has("fuelTank") then
                    if entity.fuelTank.currentHP <= 0 then
                        SOUND.warning = true
                        break
                    elseif fun.getFuelBurnTime() <= 10 then
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
                if entity.miningLaser.currentHP > 0 then
                    if entity:has("battery") then
                        if entity.battery.capacity > 0 then
							if entity:has("cargoHold") then
								if entity.cargoHold.currentAmount < entity.cargoHold.maxAmount then
									if entity.cargoHold.currentHP > 0 then
			                            activateMiningLaser(dt)
			                            entity.battery.capacity = entity.battery.capacity - dt
			                            if  entity.battery.capacity <= 0 then  entity.battery.capacity = 0 end
									end
								end
							end
                        end
                    end
                end
            end
        end
    end
    ECSWORLD:addSystems(systemMiningLaser)

    systemOxyGen = concord.system({
        pool = {"oxyGenerator"}
    })
    function systemOxyGen:update(dt)
        for _, entity in ipairs(self.pool) do
			if entity.oxyGenerator.currentHP > 0 then
            	if entity:has("battery") then
					if entity:has("oxyTank") then
						entity.oxyTank.capacity = entity.oxyTank.capacity + dt
						if entity.oxyTank.capacity > entity.oxyTank.maxCapacity then entity.oxyTank.capacity = entity.oxyTank.maxCapacity end
					end
					entity.battery.capacity = entity.battery.capacity - dt
					if entity.battery.capacity <= 0 then entity.battery.capacity = 0 end
                end
            end
        end
    end
    ECSWORLD:addSystems(systemOxyGen)

	systemBattery = concord.system({
		pool = {"battery"}
	})
	function systemBattery:update(dt)
		for _, entity in ipairs(self.pool) do
			if entity.battery.capacity <= BATTERY_THRESHOLD_SECONDS or entity.battery.currentHP <= 0 then
				-- the 25 is an arbitrary number of seconds
				SOUND.warning = true
			end
        end
	end
	ECSWORLD:addSystems(systemBattery)

    systemSolarPanel = concord.system({
        pool = {"solarPanel"}
    })
    function systemSolarPanel:update(dt)
        for _, entity in ipairs(self.pool) do
            if entity.solarPanel.currentHP > 0 then
                -- charge batter
                if entity:has("battery") then
                    if entity.battery.currentHP > 0 then
                        entity.battery.capacity = entity.battery.capacity + (dt * entity.solarPanel.rechargeRate)
                        if entity.battery.capacity > entity.battery.maxCapacity then entity.battery.capacity = entity.battery.maxCapacity end
                    end
                end
            end
        end
    end
    ECSWORLD:addSystems(systemSolarPanel)

	systemSOSBeacon = concord.system({
        pool = {"SOSBeacon"}
    })
    function systemSOSBeacon:update(dt)
        for _, entity in ipairs(self.pool) do
			if entity.SOSBeacon.activated and entity.SOSBeacon.currentHP > 0 then
				if entity:has("battery") and entity.battery.capacity > 0 and entity.battery.currentHP > 0 then
					entity.battery.capacity = entity.battery.capacity - dt	-- beacon drains the battery
					-- there is a chance the vessel is rescued
					if love.math.random(1,1000) == 1 then
						-- rescued!
						entity.SOSBeacon.activated = false
						cf.AddScreen(enum.sceneShop, SCREEN_STACK)
					end
				end
			end
			if love.mouse.isDown(1) and entity.SOSBeacon.currentHP > 0 then
				-- drawx/y is the top left corner of the box/button
				local drawheight = 20 		-- it's a square so width is the same
				local drawx = SCREEN_WIDTH - 100 - drawheight
				local drawy = 150
				x, y = love.mouse.getPosition()
				if x >= drawx and x <= drawx + drawheight and
					y >= drawy and y <= drawy + drawheight then

					entity.SOSBeacon.activated = not entity.SOSBeacon.activated
				end
			end
		end
	end
	ECSWORLD:addSystems(systemSOSBeacon)

	systemejectionPod = concord.system({
        pool = {"ejectionPod"}
    })
    function systemejectionPod:update(dt)
        for _, entity in ipairs(self.pool) do
			if love.mouse.isDown(1) and entity.ejectionPod.currentHP > 0 then
				x, y = love.mouse.getPosition()

				local buttonwidth = 20
				local buttonx = SCREEN_WIDTH - 100 + 50 - buttonwidth
				local buttony = 150


				if x >= buttonx and x <= buttonx + buttonwidth and
					y >= buttony and y <= buttony + buttonwidth then
					ejectPlayer(entity)

					--! Propel the pod towards the base
					-- local facing = physEntity.body:getAngle()       -- radians. 0 = "right"
	                -- facing = cf.convRadToCompass(facing)
					--
	                -- local vectordistance = entity.engine.strength      -- amount of force
					--
	        		-- local x2, y2 = cf.AddVectorToPoint(x1, y1, facing, vectordistance)
	        		-- local xvector = (x2 - x1) * 20 * dt
	        		-- local yvector = (y2 - y1) * 20 * dt
					--
	        		-- physEntity.body:applyForce(xvector, yvector)		-- the amount of force = vector distance


					-- get the players x/y
					local playerPhysEntity = fun.getPhysEntity(PLAYER.UID)
					local x1, y1 = playerPhysEntity.body:getPosition()
					local x2, y2

					-- get the starbase x/y
					for _, physEntity in pairs(PHYSICS_ENTITIES) do
						local temptable = physEntity.fixture:getUserData()
						if temptable.objectType == "Starbase" then
							x2, y2 = physEntity.body:getPosition()
							local xvector = (x2 - x1) * 2000
							local yvector = (y2 - y1) * 2000
							playerPhysEntity.body:applyForce(xvector, yvector)		-- the amount of force = vector distance
							print(xvector, yvector)
						end
					end
				end
			end
		end
	end
	ECSWORLD:addSystems(systemejectionPod)

	systemStabiliser = concord.system({
        pool = {"Stabiliser"}
    })
    function systemStabiliser:update(dt)
        for _, entity in ipairs(self.pool) do
			local physEntity = fun.getPhysEntity(entity.uid.value)
			local rotation = physEntity.body:getAngularVelocity()

			if not love.keyboard.isDown("kp7") and not love.keyboard.isDown("kp9") then
				if entity:has("fuelTank") then
					if rotation < 0 and entity:has("leftThruster") and entity.leftThruster.currentHP > 0 then
						physEntity.body:applyTorque(entity.leftThruster.strength)
					elseif rotation > 0 and entity:has("rightThruster") and entity.rightThruster.currentHP > 0 then
						physEntity.body:applyTorque(entity.rightThruster.strength * -1)
					else
						-- do nothing
					end
				end
			end
		end
	end
	ECSWORLD:addSystems(systemStabiliser)
end

return ecsUpdate
