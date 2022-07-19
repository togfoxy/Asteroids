ecsDraw = {}

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
                if entity.uid.value == PLAYER.UID then
                    love.graphics.setColor(0, 1, 0, 1)
                else
                    love.graphics.setColor(1, 1, 1, 1)
                end

                for _, fixture in pairs(physEntity.body:getFixtures()) do
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
        				local x1, y1, x2, y2, x3, y3, x4, y4, x5, y5, x6, y6, x7, y7, x8, y8 = physEntity.body:getWorldPoints(shape:getPoints())
        				x1 = x1 * BOX2D_SCALE
        				y1 = y1 * BOX2D_SCALE
        				x2 = x2 * BOX2D_SCALE
        				y2 = y2 * BOX2D_SCALE
        				x3 = x3 * BOX2D_SCALE
        				y3 = y3 * BOX2D_SCALE
        				x4 = x4 * BOX2D_SCALE
        				y4 = y4 * BOX2D_SCALE
                        -- x5 = x5 * BOX2D_SCALE
        				-- y5 = y5 * BOX2D_SCALE
        				-- x6 = x6 * BOX2D_SCALE
        				-- y6 = y6 * BOX2D_SCALE
        				-- x7 = x7 * BOX2D_SCALE
        				-- y7 = y7 * BOX2D_SCALE
        				-- x8 = x8 * BOX2D_SCALE
        				-- y8 = y8 * BOX2D_SCALE

        				-- love.graphics.setColor(1, 0, 0, 1)
        				love.graphics.polygon("fill", x1, y1, x2, y2, x3, y3, x4, y4)
        			else
        				love.graphics.line(body:getWorldPoints(shape:getPoints()))
        				error("This physics object needs to be scaled before drawing")
        			end
        		end

                local x1, y1 = fun.getPhysEntityXY(entity.uid.value)
                x1 = x1 * BOX2D_SCALE
                y1 = y1 * BOX2D_SCALE
                local facing = physEntity.body:getAngle()       -- radians

                if DRAW.engineFlame then
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

            end
        end
    end
    ECSWORLD:addSystems(systemDraw)
end

return ecsDraw
