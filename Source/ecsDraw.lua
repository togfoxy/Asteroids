ecsDraw = {}

local function drawDamageIndicator(str, x1, y1)
    -- screen coordinates

    -- print the text
    drawx = x1 + 150
    drawy = y1 - 115
    love.graphics.setFont(FONT[enum.fontDefault])
    love.graphics.setColor(1,0,0,1)
    love.graphics.print(str, drawx, drawy)

    -- draw a cool line
    x2, y2 = cf.AddVectorToPoint(x1,y1,45,75)
    x3, y3 = cf.AddVectorToPoint(x2,y2,45,75)
    x4, y4 = cf.AddVectorToPoint(x3,y3,90,35)

    love.graphics.line(x2,y2,x3,y3,x4,y4)



end

function ecsDraw.init()

    systemDraw = concord.system({
        pool = {"drawable"}
    })
    -- define same systems
    function systemDraw:draw()
        love.graphics.setColor(1,1,1,1)
        for _, entity in ipairs(self.pool) do
            local physEntity = fun.getPhysEntity(entity.uid.value)
            if physEntity ~= nil then

				-- draw the 'front'
				local x0, y0 = physEntity.body:getPosition()
				local facing = physEntity.body:getAngle()       -- radians
				facing = cf.convRadToCompass(facing)
				local x1, y1 = cf.AddVectorToPoint(x0,y0,facing,10)
				love.graphics.setColor(1, 1, 1, 1)
				love.graphics.line(x0 * BOX2D_SCALE,y0 * BOX2D_SCALE,x1 * BOX2D_SCALE,y1 * BOX2D_SCALE)

                if entity.uid.value == PLAYER.UID then
                    love.graphics.setColor(0, 1, 0, 1)
                else
                    love.graphics.setColor(1, 1, 1, 1)
                end

                for _, fixture in pairs(physEntity.body:getFixtures()) do
        			local shape = fixture:getShape()

        			if shape:typeOf("CircleShape") then
        			elseif shape:typeOf("PolygonShape") then     -- currently only works on four points (square and rectangle)
        				local x1, y1, x2, y2, x3, y3, x4, y4, x5, y5, x6, y6, x7, y7, x8, y8 = physEntity.body:getWorldPoints(shape:getPoints())
        				x1 = x1 * BOX2D_SCALE
        				y1 = y1 * BOX2D_SCALE
        				x2 = x2 * BOX2D_SCALE
        				y2 = y2 * BOX2D_SCALE
        				x3 = x3 * BOX2D_SCALE
        				y3 = y3 * BOX2D_SCALE
        				x4 = x4 * BOX2D_SCALE
        				y4 = y4 * BOX2D_SCALE
        				love.graphics.polygon("fill", x1, y1, x2, y2, x3, y3, x4, y4)
        			else
        				love.graphics.line(body:getWorldPoints(shape:getPoints()))
        				error("This physics object needs to be scaled before drawing")
        			end
        		end

                -- draw the different flames
                local x1, y1 = fun.getPhysEntityXY(entity.uid.value)
                x1 = x1 * BOX2D_SCALE
                y1 = y1 * BOX2D_SCALE
                local facing = physEntity.body:getAngle()       -- radians

                if DRAW.engineFlame then		--! these are globals but probably shouldn't be
                    love.graphics.setColor(1,1,1,1)
                    love.graphics.draw(IMAGES[enum.imagesEngineFlame], x1, y1, facing, 10, 10, 2, -3)        --  r, sx, sy, ox, oy, kx, ky)
                end
                if DRAW.leftFlame then
                    love.graphics.setColor(1,1,1,1)
                    love.graphics.draw(IMAGES[enum.imagesEngineFlame], x1, y1, facing + 1.57, 5, 5, 3, -6)        --  r, sx, sy, ox, oy, kx, ky)
                end
                if DRAW.rightFlame then
                    love.graphics.setColor(1,1,1,1)
                    love.graphics.draw(IMAGES[enum.imagesEngineFlame], x1, y1, facing - 1.57, 5, 5, 3, -6)        --  r, sx, sy, ox, oy, kx, ky)
                end
                if DRAW.reverseFlame then
                    love.graphics.setColor(1,1,1,1)
                    love.graphics.draw(IMAGES[enum.imagesEngineFlame], x1, y1, facing + 3.14, 5, 5, 3, -6)        --  r, sx, sy, ox, oy, kx, ky)
                end

                -- draw damamge markers
                local dmgStr = ""
                local dmgStr = fun.getDestroyedComponentString(entity)
                if dmgStr ~= "" then
                    drawDamageIndicator(dmgStr, x1, y1)     -- screen coodinates of entity
                end
            end
        end
    end
    ECSWORLD:addSystems(systemDraw)
end

return ecsDraw
