draw = {}

local function fillShop(entity)
	-- entity = player entity

	local chance = 25		-- percent
	SHOP_ENTITY = nil
	SHOP_ENTITY = concord.entity(SHOPWORLD)
	:give("chassis")
	:give("engine")
	:give("leftThruster")
	:give("rightThruster")
	:give("reverseThruster")
	:give("fuelTank")
	:give("miningLaser")
	:give("battery")
	:give("oxyGenerator")
	:give("oxyTank")
	:give("solarPanel")
	:give("cargoHold")
	:give("spaceSuit")
	:give("SOSBeacon")
	:give("Stabiliser")
	:give("ejectionPod")

	local allComponents = SHOP_ENTITY:getComponents()
	for componentClass, component in pairs(allComponents) do
		if love.math.random(1,100) <= chance then
			-- keep this component in the shop
		else
			SHOP_ENTITY:remove(componentClass)
		end
	end

	-- let player buy cargo if there is none
	if not entity:has("cargoHold") then
		SHOP_ENTITY:give("cargoHold")
	end
end

local function drawStarbase()
	love.graphics.setColor(100/256,87/256,188/256,1)
	local x1, y1, x2, y2, x3, y3, x4, y4

	local drawx, drawy

	for i = 1, (#PHYSICS_ENTITIES) do
		local udtable = PHYSICS_ENTITIES[i].fixture:getUserData()
		if udtable.objectType == "Starbase" then
			-- have located the starbase physics object
			drawx, drawy = PHYSICS_ENTITIES[i].body:getPosition()

			for _, fixture in pairs(PHYSICS_ENTITIES[i].body:getFixtures()) do
				local shape = fixture:getShape()
				if shape:typeOf("CircleShape") then
					-- local drawx, drawy = body:getWorldPoints(shape:getPoint())
					-- drawx = drawx * BOX2D_SCALE
					-- drawy = drawy * BOX2D_SCALE
					-- local radius = shape:getRadius()
					-- radius = radius * BOX2D_SCALE
					-- love.graphics.setColor(1, 0, 0, 1)
					-- love.graphics.circle("line", drawx, drawy, radius)
					-- love.graphics.setColor(1, 1, 1, 1)
					-- love.graphics.print("r:" .. cf.round(radius,2), drawx + 7, drawy - 3)
				elseif shape:typeOf("PolygonShape") then     -- currently only works on four points (square and rectangle)
					x1, y1, x2, y2, x3, y3, x4, y4 = PHYSICS_ENTITIES[i].body:getWorldPoints(shape:getPoints())
					x1 = x1 * BOX2D_SCALE
					y1 = y1 * BOX2D_SCALE
					x2 = x2 * BOX2D_SCALE
					y2 = y2 * BOX2D_SCALE
					x3 = x3 * BOX2D_SCALE
					y3 = y3 * BOX2D_SCALE
					x4 = x4 * BOX2D_SCALE
					y4 = y4 * BOX2D_SCALE
					-- love.graphics.setColor(1, 0, 0, 1)
					-- love.graphics.polygon("line", x1, y1, x2, y2, x3, y3, x4, y4)

					local drawx = x4
					local drawy = y4

					love.graphics.setColor(1, 1, 1, 1)
					love.graphics.draw(IMAGES[enum.imagesStarbase], drawx, drawy)

				else
					love.graphics.line(body:getWorldPoints(shape:getPoints()))
					error("This physics object needs to be scaled before drawing")
				end
			end
		end
	end

	-- get starbase x/y
	drawx = drawx * BOX2D_SCALE
	drawy = drawy * BOX2D_SCALE

	love.graphics.setFont(FONT[enum.fontHeavyMetalLarge])
    love.graphics.setColor(1,1,1,1)
	love.graphics.printf("STARBASE SAFE HAVEN", drawx - 750, drawy + 150, 1000, "left", 0, 7, 7)

	-- -- draw the safezone
	-- local x1, y1, x2, y2		-- intentionally declared again to clear the old value
	-- x1 = 0
	-- y1 = (PHYSICS_HEIGHT - PHYSICS_SAFEZONE) * BOX2D_SCALE
	-- x2 = PHYSICS_WIDTH * BOX2D_SCALE
	-- y2 = y1
	-- love.graphics.line(x1,y1,x2,y2)
end

local function drawAsteroids()

	for k, obj in pairs(PHYSICS_ENTITIES) do
		local udtable = obj.fixture:getUserData()
		if udtable.objectType == "Asteroid" and udtable.isVisible then
				local body = obj.body
				local mass = cf.round(body:getMass())
				local x0, y0 = body:getPosition()
				for _, fixture in pairs(body:getFixtures()) do
					local shape = fixture:getShape()
					local points = {body:getWorldPoints(shape:getPoints())}
					for i = 1, #points do
						points[i] = points[i] * BOX2D_SCALE
					end

					if udtable.oreType == enum.oreTypeGold then
						love.graphics.setColor(236/255,164/255,18/255,0.75)
						love.graphics.polygon("fill", points)
					elseif udtable.oreType == enum.oreTypeSilver then
						love.graphics.setColor(192/255,192/255,192/255,1)
						love.graphics.polygon("fill", points)
					elseif udtable.oreType == enum.oreTypeBronze then
						love.graphics.setColor(122/255,84/255,9/255,0.5)
						love.graphics.polygon("fill", points)
					else
						love.graphics.setColor(139/255,139/255,139/255,1)
						love.graphics.polygon("line", points)
					end
					-- -- print the mass for debug reasons
					-- love.graphics.setColor(1,1,1,1)
					-- love.graphics.print(cf.round(obj.currentMass), (x0 * BOX2D_SCALE) + 15, (y0 * BOX2D_SCALE) - 15)
				end

		end
	end
end

local function drawHUD()
	-- draw the HUD
	love.graphics.setColor(1,1,1,1)
	love.graphics.draw(IMAGES[enum.imagesAsteroidBackground])

	-- o2 left
	local o2left = fun.getO2left()
	if o2left > 100 then o2left = 100 end	-- 100 is an arbitrary 100 to make % easy
	local drawx = 100
	local drawy = 50
	local scalex = 1
	love.graphics.setColor(0,188/255,1,1)
	love.graphics.setLineWidth(5)
	love.graphics.line(drawx,drawy, drawx + (o2left * scalex), drawy)
	love.graphics.setLineWidth(1)
	if o2left < 25 then
		-- draw flashing light
		love.graphics.setColor(1,0,0, O2_ALARM_ALPHA)
		love.graphics.circle("fill", drawx - 29, drawy, 6)
	end

	-- fuel left (green)
	local fuel = fun.getFuelBurnTime()
	if fuel > 100 then fuel = 100 end	-- 100 is an arbitrary 100 to make % easy
	local drawx = 100
	local drawy = 75
	local scalex = 1
	love.graphics.setColor(0,1,0,1)
	love.graphics.setLineWidth(5)
	love.graphics.line(drawx, drawy, drawx + (fuel * scalex), drawy)
	love.graphics.setLineWidth(1)
	if fuel < 10 then
		-- draw flashing light
		love.graphics.setColor(1,0,0, FUEL_ALARM_ALPHA)
		love.graphics.circle("fill", drawx - 29, drawy, 6)
	end

	-- hold space (gold)
	local entity = fun.getEntity(PLAYER.UID)
	if entity:has("cargoHold") then
		local cargopercent = (entity.cargoHold.currentAmount / entity.cargoHold.maxAmount)		-- decimal
		local drawx = 100
		local drawy = 100
		local barlength = 100 * cargopercent
		local scalex = 1
		love.graphics.setColor(1,1,0,1)
		love.graphics.setLineWidth(5)
		love.graphics.line(drawx, drawy, drawx + barlength, drawy)
		love.graphics.setLineWidth(1)
		if cargopercent > 0.98 then
			-- draw flashing light
			love.graphics.setColor(1,0,0, 1)
			love.graphics.circle("fill", drawx - 29, drawy, 6)
		end
	end

	-- battery
	if entity:has("battery") then
		local batterypercent = (entity.battery.capacity / entity.battery.maxCapacity)		-- decimal
		local drawx = 100
		local drawy = 125
		local barlength = 100 * batterypercent
		local scalex = 1
		love.graphics.setColor(1,0,1,1)
		love.graphics.setLineWidth(5)
		love.graphics.line(drawx, drawy, drawx + barlength, drawy)
		love.graphics.setLineWidth(1)
		if entity.battery.capacity < BATTERY_THRESHOLD_SECONDS then	-- note this is NOT percentage but hard seconds
			-- draw flashing light
			love.graphics.setColor(1,0,0, BATTERY_ALARM_ALPHA)
			love.graphics.circle("fill", drawx - 30, drawy, 5)
		end
	end

	-- draw the 'non-gauge' components that don't have capacity
	if entity:has("oxyTank") then
		local drawx = SCREEN_WIDTH - 190
		local drawy = 50
		if entity.oxyTank.currentHP > 0 then
			love.graphics.setColor(1,1,1,1)
		else
			love.graphics.setColor(1,0,0,1)
		end
		love.graphics.setFont(FONT[enum.fontDefault])
		love.graphics.print("O2 tank", drawx, drawy)
	end
	if entity:has("solarPanel") then
		local drawx = SCREEN_WIDTH - 100
		local drawy = 50
		if entity.solarPanel.currentHP > 0 then
			love.graphics.setColor(1,1,1,1)
		else
			love.graphics.setColor(1,0,0,1)
		end
		love.graphics.setFont(FONT[enum.fontDefault])
		love.graphics.print("Solar panel", drawx, drawy)
	end
	if entity:has("spaceSuit") then
		local drawx = SCREEN_WIDTH - 200
		local drawy = 90
		love.graphics.setColor(1,1,1,1)
		love.graphics.setFont(FONT[enum.fontDefault])
		love.graphics.print("Space suit", drawx, drawy)
	end
	if entity:has("Stabiliser") then
		local drawx = SCREEN_WIDTH - 95
		local drawy = 90
		if entity.Stabiliser.currentHP > 0 then
			love.graphics.setColor(1,1,1,1)
		else
			love.graphics.setColor(1,0,0,1)
		end
		love.graphics.setFont(FONT[enum.fontDefault])
		love.graphics.print("Stabiliser", drawx, drawy)
	end

	-- draw buttons
	for k, button in pairs(GUI_BUTTONS) do
		if button.scene == enum.sceneAsteroid and button.visible then
			-- draw the button
			love.graphics.setColor(button.bgcolour)

			if button.drawOutline == nil or button.drawOutline == true then
				if button.state == "on" then
					love.graphics.rectangle("fill", button.x, button.y, button.width, button.height)			-- drawx/y is the top left corner of the square
				else
					love.graphics.rectangle("line", button.x, button.y, button.width, button.height)			-- drawx/y is the top left corner of the square
				end
			end

			if button.image ~= nil then
				love.graphics.draw(button.image, button.x, button.y)
			end

			-- draw the label
			if button.state == "off" then
				love.graphics.setColor(button.labeloffcolour)
			else
				love.graphics.setColor(button.labeloncolour)
			end
			local labelxoffset = button.labelxoffset or 0
			love.graphics.setFont(FONT[enum.fontDefault])
			love.graphics.print(button.label, button.x + labelxoffset, button.y + 5)
		end
	end

	-- draw the F1 message
	local drawx = SCREEN_WIDTH / 2 - 50
	local drawy = 10
	love.graphics.setColor(1,1,1,1)
	love.graphics.setFont(FONT[enum.fontDefault])
	love.graphics.print("Press F1 for help", drawx, drawy)
end

function draw.asteroids()
    cam:attach()

	-- wallpaper
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(IMAGES[enum.imagesBackgroundStatic], 0, 0, 0, 5.24, 10)
    ECSWORLD:emit("draw")

    -- background
    drawStarbase()
    drawAsteroids()

    -- cf.printAllPhysicsObjects(PHYSICSWORLD, BOX2D_SCALE)
    cam:detach()

	draw.bubbles()
	drawHUD()

	-- draw the dead screen with alpha 0 (unless dead!)
	love.graphics.setColor(1,1,1,DEAD_ALPHA)
	love.graphics.draw(IMAGES[enum.imagesDead], 0, 0)

	-- debug
	-- draw ship mass and size
	-- local entity = fun.getEntity(PLAYER.UID)
	-- local physicsEntity = fun.getPhysEntity(PLAYER.UID)
	-- love.graphics.setColor(1,1,1,1)
	-- love.graphics.setFont(FONT[enum.fontDefault])
	-- love.graphics.print("Mass: " .. physicsEntity.body:getMass(), 30, SCREEN_HEIGHT - 100)
	-- love.graphics.print("Size: " .. fun.getEntitySize(entity), 30, SCREEN_HEIGHT - 80)
end

function draw.shop()

	love.graphics.setColor(1,1,1,0.25)
	love.graphics.draw(IMAGES[enum.imagesShop], 0,0)

	love.graphics.setColor(1,1,1,1)
	-- love.graphics.draw(IMAGES[enum.imagesShopPanel], 34, 148, 0, 0.88, 0.65)
	love.graphics.draw(IMAGES[enum.imagesShopPanels], 0, 0, 0, 1, 1, 8, 6)

	local numofcols = 4
	local numofmargins = numofcols + 1
    local topmargin = 90
    local margin = 35
	local panelheight = 62

	local panelwidth = SCREEN_WIDTH - (margin * numofmargins)
	panelwidth = panelwidth / numofcols

	local panelimagewidth = IMAGES[enum.imagesShopPanel]:getWidth()
    local panelxscale = panelwidth / panelimagewidth

	-- draw the panels
	local panelx = {}
	local panely = {}
	local drawx = margin

	for i = 1, numofcols do	-- this is actually columns
		panelx[i] = drawx		-- capture this for easy drawing later
		panely[i] = topmargin
		drawx = drawx + margin + panelwidth
	end

	-- draw the ship components
	local entity = fun.getEntity(PLAYER.UID)
	local allComponents = entity:getComponents()
	local drawx = panelx[1] + 10		-- indent the text
	local drawy = panely[1] + 10
	BUTTONS = {}
	BUTTONS[1] = {}
	local compindex = 0

	-- load the table to be sorted
	local tablesort = {}
	for _, component in pairs(allComponents) do
		if component.description ~= nil then
			-- add this name to the sort table
			table.insert(tablesort, component.label)
		end
	end
	table.sort(tablesort)

	while #tablesort > 0 do
		for _, component in pairs(allComponents) do
			if component.label ~= nil then
				if component.label == tablesort[1] then
					compindex = compindex + 1
					drawy = drawy + panelheight

					local txt = component.label .. ": "
					if component.currentHP ~= nil then
						if component.currentHP < component.maxHP then
							love.graphics.setColor(1,0,0,1)
						else
							love.graphics.setColor(1,1,1,1)
						end
						txt = txt .. cf.round(component.currentHP) .. " / " .. component.maxHP
					end
					love.graphics.setFont(FONT[enum.fontTech36])
					love.graphics.print(txt, drawx, drawy - 10)		-- colour and alpha is set up above

					-- draw the description
					local txt = component.description
					love.graphics.setFont(FONT[enum.fontDefault])
					love.graphics.setColor(1,1,1,1)
					love.graphics.print(txt, drawx, drawy + 17)

					-- draw the click zone (debugging)
					local zonex = panelx[1]
					local zoney = panely[1] + ((compindex) * panelheight)
					local zonewidth = panelwidth

					love.graphics.setColor(1,1,1,1)
					-- love.graphics.rectangle("line", zonex, zoney, zonewidth, panelheight)

					-- store buttons for later use
					BUTTONS[1][compindex] = {}		-- col/row format
					BUTTONS[1][compindex].col = 1
					BUTTONS[1][compindex].row = compindex
					BUTTONS[1][compindex].x = zonex
					BUTTONS[1][compindex].y = zoney
					BUTTONS[1][compindex].width = zonewidth
					BUTTONS[1][compindex].height = panelheight
					BUTTONS[1][compindex].component = component
					BUTTONS[1][compindex].type = enum.buttonTypeRepair

					table.remove(tablesort, 1)
					break		-- break the 'pairs' loop
				end
			end
		end
	end

	-- draw shop components that can be bought
	if SHOP_TIMER <= 0 then
		fillShop(entity)
		SHOP_TIMER = DEFAULT_SHOP_TIMER
	end
	BUTTONS[2] = {}
	local drawx = panelx[2] + 10			-- the 10 is to indent the text a little bit
	local drawy = panely[2] + 10
	local compindex = 0
	local allComponents = SHOP_ENTITY:getComponents()
	for _, component in pairs(allComponents) do
		-- these are for sale
		compindex = compindex + 1
		drawy = drawy + panelheight
		local txt = component.label .. " $" .. component.purchasePrice
		love.graphics.setFont(FONT[enum.fontTech36])
		love.graphics.setColor(1,1,1,1)
		love.graphics.print(txt, drawx, drawy - 10)

		-- draw the description
		local txt = component.description
		love.graphics.setFont(FONT[enum.fontDefault])
		love.graphics.setColor(1,1,1,1)
		love.graphics.print(txt, drawx, drawy + 17)

		-- draw the click zone (debugging)
		local zonex = panelx[2]
		local zoney = panely[2] + ((compindex) * panelheight)
		local zonewidth = panelwidth

		love.graphics.setColor(1,1,1,1)
		-- love.graphics.rectangle("line", zonex, zoney, zonewidth, panelheight)

		-- store buttons for later use
		BUTTONS[2][compindex] = {}		-- col/row format
		BUTTONS[2][compindex].col = 2
		BUTTONS[2][compindex].row = compindex
		BUTTONS[2][compindex].x = zonex
		BUTTONS[2][compindex].y = zoney
		BUTTONS[2][compindex].width = zonewidth
		BUTTONS[2][compindex].height = panelheight
		BUTTONS[2][compindex].component = component
		BUTTONS[2][compindex].type = enum.buttonTypeBuy
	end

	-- draw the shopping receipt
	love.graphics.setFont(FONT[enum.fontTech36])
	love.graphics.setColor(1,1,1,1)

	local drawx = panelx[4] + 10
	local drawy = panely[4] + 60
	for k, item in pairs(RECEIPT) do
		love.graphics.print(item.description, drawx, drawy)
		-- love.graphics.print(item.amount, drawx + 200, drawy)
		love.graphics.printf(item.amount, drawx, drawy, 275, "right")

		drawy = drawy + 20
	end

	-- print wealth and score
	if PLAYER.ROCKSKILLED == nil then PLAYER.ROCKSKILLED = 0 end
	if PLAYER.WEALTH == nil then PLAYER.WEALTH = 0 end

	love.graphics.setFont(FONT[enum.fontTech18])
	love.graphics.setColor(1,1,1,1)

	local drawx = SCREEN_WIDTH * 0.33 + 180
	local drawy = 33
	love.graphics.print("$" .. cf.strFormatThousand(PLAYER.WEALTH), drawx, drawy)

	local drawx = SCREEN_WIDTH * 0.66 + 70
	local drawy = 33
	love.graphics.print(PLAYER.ROCKSKILLED, drawx, drawy)
end

function draw.dead()
    love.graphics.setColor(1,1,1,1)
    love.graphics.setFont(FONT[enum.fontDefault])
    love.graphics.print("You ded", 1000, 500)
	love.graphics.printf(DEAD_REASON, 850, 530, 400)

    TRANSLATEX = SCREEN_WIDTH / 2
    TRANSLATEY = SCREEN_HEIGHT / 2
    ZOOMFACTOR = 0.4
end

function draw.bubbles()
	for _, bubble in pairs(BUBBLE) do
		love.graphics.setColor(1,1,1,1)
		love.graphics.setFont(FONT[enum.fontDefault])
		local drawy = bubble.y
		local yoffset = (4 - bubble.timeleft) * 10		-- need to scale up the y movement
		love.graphics.print(bubble.text, bubble.x, drawy - yoffset)
	end
end

function draw.mainMenu()

	love.graphics.setColor(1,1,1,1)
	love.graphics.draw(IMAGES[enum.imagesMenuBackground], 0,0)

	for k, button in pairs(GUI_BUTTONS) do
		if button.scene == enum.sceneMainMenu and button.visible then
			-- draw the button

			love.graphics.setColor(button.bgcolour)
			if button.state == "on" then
				-- love.graphics.rectangle("fill", button.x, button.y, button.width, button.height)			-- drawx/y is the top left corner of the square
			else
				-- love.graphics.rectangle("line", button.x, button.y, button.width, button.height)			-- drawx/y is the top left corner of the square
			end

			-- draw the label
			love.graphics.setFont(FONT[enum.fontDefault])
			love.graphics.setColor(button.labelcolour)
			love.graphics.print(button.label, button.x + 5, button.y + 5)
		end
	end
end

return draw
