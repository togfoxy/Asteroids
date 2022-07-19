cmp = {}

function cmp.init()

    concord.component("uid", function(c)
        c.value = cf.Getuuid()
    end)

    concord.component("drawable")   -- will be drawn during love.draw()

    concord.component("engine", function(c)
        c.size = 3
        c.strength = 10000      -- thrust
    end)

    concord.component("fuelTank", function(c)
        c.size = 3
        c.capacity = 1000000     -- how much thrust it contains
        c.maxCapacity = c.capacity
    end)


    concord.component("leftThruster", function(c)
        c.size = 1
        c.strength = 2500      -- thrust
    end)

    concord.component("rightThruster", function(c)
        c.size = 1
        c.strength = 2500      -- thrust
    end)

    concord.component("reverseThruster", function(c)
        c.size = 1
        c.strength = 2500      -- thrust
    end)
end

return cmp
