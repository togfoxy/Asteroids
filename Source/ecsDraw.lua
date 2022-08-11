ecsDraw = {}

local function drawDamageIndicator(str, x1, y1)
    -- input string and screen coordinates
    -- doesn't use entity etc

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

local function drawLowIndicator(str, x1, y1)
    -- print the text
    drawx = x1 - 200
    drawy = y1 - 115
    love.graphics.setFont(FONT[enum.fontDefault])
    love.graphics.setColor(1,1,0,1)
    love.graphics.print(str, drawx, drawy)

    -- draw a cool line
    x2, y2 = cf.AddVectorToPoint(x1,y1,315,75)
    x3, y3 = cf.AddVectorToPoint(x2,y2,315,75)
    x4, y4 = cf.AddVectorToPoint(x3,y3,270,35)

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

                -- draw the vessel png
                local vesselsize = fun.getEntitySize(entity)

                local x0, y0 = physEntity.body:getPosition()

                local temptable = physEntity.fixture:getUserData()

                local drawx = x0 * BOX2D_SCALE
                local drawy = y0 * BOX2D_SCALE
                local facing = physEntity.body:getAngle()       -- radians
                local xoffset = 25      -- idk why this hardcoded value works
                local yoffset = 28
                love.graphics.setColor(1, 1, 1, 1)
                if temptable.objectType == "Player" then
                     love.graphics.draw(IMAGES[enum.imagesVessel], drawx, drawy, facing, vesselsize/10, vesselsize/10, xoffset, yoffset)
                else
                    print(vesselsize)
                    love.graphics.draw(IMAGES[enum.imagesPod], drawx, drawy, facing, vesselsize / 5, vesselsize / 5, xoffset, yoffset)
                end

                -- draw the different flames
                local x1, y1 = fun.getPhysEntityXY(entity.uid.value)
                x1 = x1 * BOX2D_SCALE
                y1 = y1 * BOX2D_SCALE
                local facing = physEntity.body:getAngle()       -- radians
                local offset = cf.round((vesselsize - 11) / 2)      -- 11 is the 'baseline' for the flames
                if offset < 0 then offset = 0 end

                if DRAW.engineFlame then		-- these are globals but probably shouldn't be
                    love.graphics.setColor(1,1,1,1)
                    love.graphics.draw(IMAGES[enum.imagesEngineFlame], x1, y1, facing, 10, 10, 2, -3 - (offset / 2))        --  r, sx, sy, ox, oy, kx, ky)
                end
                if DRAW.leftFlame then
                    love.graphics.setColor(1,1,1,1)
                    love.graphics.draw(IMAGES[enum.imagesEngineFlame], x1, y1, facing + 1.57, 5, 5, 3, -6 - offset)        --  r, sx, sy, ox, oy, kx, ky)
                end
                if DRAW.rightFlame then
                    love.graphics.setColor(1,1,1,1)
                    love.graphics.draw(IMAGES[enum.imagesEngineFlame], x1, y1, facing - 1.57, 5, 5, 3, -6 - offset)        --  r, sx, sy, ox, oy, kx, ky)
                end
                if DRAW.reverseFlame then
                    love.graphics.setColor(1,1,1,1)
                    love.graphics.draw(IMAGES[enum.imagesEngineFlame], x1, y1, facing + 3.14, 5, 5, 3, -6 - offset)        --  r, sx, sy, ox, oy, kx, ky)
                end

                -- draw destroyed markers
                local dmgStr = ""
                dmgStr = fun.getDestroyedComponentString(entity)
                if dmgStr ~= "" then
                    drawDamageIndicator(dmgStr, x1, y1)     -- screen coodinates of entity
                end

                -- draw empty batteries etc
                local lowStr = ""
                lowStr = fun.getLowComponentString(entity)
                if lowStr ~= "" then
                    drawLowIndicator(lowStr, x1, y1)
                end

                -- draw mining laser
                if DRAW.miningLaser then
                    local x2 = DRAW.miningLaserX * BOX2D_SCALE
                    local y2 = DRAW.miningLaserY * BOX2D_SCALE
                    love.graphics.setColor(146/255, 89/255, 14/255, 1)
                    love.graphics.line(x1, y1, x2, y2)
                end

                -- draw SOS beacon
                if entity:has("SOSBeacon") and entity.SOSBeacon.activated and entity.SOSBeacon.currentHP > 0 then
    				if entity:has("battery") and entity.battery.capacity > 0 and entity.battery.currentHP > 0 then
                        love.graphics.setColor(1,0,0,SOSBEACON_ALARM_ALPHA)
                        love.graphics.circle("fill", x1, y1, vesselsize)
                    end
                end
            end
        end
    end
    ECSWORLD:addSystems(systemDraw)
end

return ecsDraw
