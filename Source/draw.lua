draw = {}

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
					local drawx, drawy = body:getWorldPoints(shape:getPoint())
					drawx = drawx * BOX2D_SCALE
					drawy = drawy * BOX2D_SCALE
					local radius = shape:getRadius()
					radius = radius * BOX2D_SCALE
					love.graphics.setColor(1, 0, 0, 1)
					love.graphics.circle("line", drawx, drawy, radius)
					love.graphics.setColor(1, 1, 1, 1)
					love.graphics.print("r:" .. cf.round(radius,2), drawx + 7, drawy - 3)
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
					love.graphics.polygon("line", x1, y1, x2, y2, x3, y3, x4, y4)
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
	love.graphics.printf("STARBASE SAFE HAVEN", drawx - 750, drawy - 25, 1000, "left", 0, 7, 7)		--! test this on other resolutions

	-- draw the safezone
	local x1, y1, x2, y2		-- intentionally declared again to clear the old value
	x1 = 0
	y1 = (PHYSICS_HEIGHT - PHYSICS_SAFEZONE) * BOX2D_SCALE
	x2 = PHYSICS_WIDTH * BOX2D_SCALE
	y2 = y1
	love.graphics.line(x1,y1,x2,y2)
end

local function drawAsteroids()

	for k, obj in pairs(PHYSICS_ENTITIES) do
		local udtable = obj.fixture:getUserData()
		if udtable.objectType == "Asteroid" then
			local body = obj.body
			local mass = cf.round(body:getMass())
			local x0, y0 = body:getPosition()
			for _, fixture in pairs(body:getFixtures()) do
				local shape = fixture:getShape()
				local points = {body:getWorldPoints(shape:getPoints())}
				for i = 1, #points do
					points[i] = points[i] * BOX2D_SCALE
				end

				if udtable.isSelected then
					love.graphics.setColor(0, 1, 1, 1)
				else
					love.graphics.setColor(139/255,139/255,139/255,1)
				end
				love.graphics.polygon("line", points)

				-- print the mass for debug reasons
				love.graphics.setColor(1,1,1,1)
				love.graphics.print(cf.round(obj.currentMass), (x0 * BOX2D_SCALE) + 15, (y0 * BOX2D_SCALE) - 15)

			end
		end
	end
end

function draw.asteroids()

    cam:attach()
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(IMAGES[enum.imagesBackgroundStatic], 0, 0, 0, 5.24, 10)
    ECSWORLD:emit("draw")

    -- background
    drawStarbase()
    drawAsteroids()
    -- cf.printAllPhysicsObjects(PHYSICSWORLD, BOX2D_SCALE)
    cam:detach()

    -- draw the HUD
    love.graphics.draw(IMAGES[enum.imagesEjectButton],25,25)
    -- o2 left
    local o2left = fun.getO2left()
    if o2left > 100 then o2left = 100 end	-- 100 is an arbitrary 100 to make % easy
    local bars = math.ceil(o2left / 10)
    local drawx = 109
    local drawy = 30
    for i = 1, bars - 1 do
        love.graphics.draw(IMAGES[enum.imagesBlueBar],drawx,drawy,0,1,1)
        drawx = drawx + 7
        drawy = drawy + 0
    end
    if bars >= 1 then love.graphics.draw(IMAGES[enum.imagesBlueBarEnd],drawx,drawy,0,1,1) end

    -- fuel left (green)
    local fuel = fun.getFuelBurnTime()
    if fuel > 100 then fuel = 100 end	-- 100 is an arbitrary 100 to make % easy
    local bars = math.ceil(fuel / 10)
    local drawx = 109
    local drawy = 50
    for i = 1, bars - 1 do
        love.graphics.draw(IMAGES[enum.imagesGreenBar],drawx,drawy,0,1,1)
        drawx = drawx + 7
        drawy = drawy + 0
    end
    if bars >= 1 then love.graphics.draw(IMAGES[enum.imagesGreenBarEnd],drawx,drawy,0,1,1) end

    -- hold space (gold)
    local entity = fun.getEntity(PLAYER.UID)
    if entity:has("cargoHold") then
        local holdused = entity.cargoHold.currentAmount
        local holdpercent = cf.round(holdused/entity.cargoHold.maxAmount * 100)
        if holdpercent > 100 then holdpercent = 100 end	-- 100 is an arbitrary 100 to make % easy
        local bars = math.ceil(holdpercent / 10)
        local drawx = 109
        local drawy = 70
        for i = 1, bars - 1 do
            love.graphics.draw(IMAGES[enum.imagesOrangeBar],drawx,drawy,0,1,1)
            drawx = drawx + 7
            drawy = drawy + 0
        end
        if bars >= 1 then love.graphics.draw(IMAGES[enum.imagesOrangeBarEnd],drawx,drawy,0,1,1) end
    end

    -- draw the dead screen with alpha 0 (unless dead!)
    love.graphics.setColor(1,1,1,DEAD_ALPHA)
    love.graphics.draw(IMAGES[enum.imagesDead], 0, 0)
end

function draw.shop()

    local topmargin = 45
    local margin = 35
    local edge = 35
    local panelwidth = (SCREEN_WIDTH - (2 * margin) - (2 * edge)) / 3
print(panelwidth)
    local panel1x = margin
    local panel2x = panel1x + panelwidth + edge
    local panel3x = panel2x + panelwidth + edge

    love.graphics.setColor(1,1,1,1)
    -- love.graphics.rectangle("line", panel1x, topmargin, panelwidth, 900)
    -- love.graphics.rectangle("line", panel2x, topmargin, panelwidth, 900)
    -- love.graphics.rectangle("line", panel3x, topmargin, panelwidth, 900)

    TRANSLATEX = SCREEN_WIDTH / 2
    TRANSLATEY = SCREEN_HEIGHT / 2
    ZOOMFACTOR = 0.4


    local panelimagewidth = IMAGES[enum.imagesShopPanel]:getWidth()
    local panelxscale = panelwidth / panelimagewidth

    -- repair
    love.graphics.draw(IMAGES[enum.imagesShopPanel], panel1x, topmargin, 0, panelxscale, 1)


    -- purchase
    love.graphics.draw(IMAGES[enum.imagesShopPanel], panel2x, topmargin, 0, panelxscale, 1)


    -- sell
    love.graphics.draw(IMAGES[enum.imagesShopPanel], panel3x, topmargin, 0, panelxscale, 1)

end

function draw.dead()
    love.graphics.setColor(1,1,1,1)
    love.graphics.setFont(FONT[enum.fontDefault])
    love.graphics.print("You ded", 1000, 500)

    TRANSLATEX = SCREEN_WIDTH / 2
    TRANSLATEY = SCREEN_HEIGHT / 2
    ZOOMFACTOR = 0.4
end




return draw
