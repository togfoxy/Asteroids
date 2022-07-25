cmp = {}

function cmp.init()

    concord.component("uid", function(c)
        c.value = cf.Getuuid()
    end)

    concord.component("drawable")   -- will be drawn during love.draw()

	concord.component("chassis", function(c)
		c.label = "Chassis"
        c.size = love.math.random(2,4)
		c.maxHP = 4000 + love.math.random(1,10) * 1000
		c.currentHP = 2000 --c.maxHP
        c.purchasePrice = 1000
        c.description = "Vessel frame. Size " .. c.size .. ". Health " .. c.maxHP .. "."
    end)

    concord.component("engine", function(c)
		c.label = "Main engine"
        c.size = love.math.random(2,4)
        c.strength = 4000 + love.math.random(1,10) * 1000     -- thrust
		c.maxHP = love.math.random(2,4) * 1000
		c.currentHP = c.maxHP
        c.purchasePrice = 1000
        c.description = "Main propulsion. Size " .. c.size .. ". Health " .. c.maxHP .. ". Thrust " .. c.strength .. "."
    end)

    concord.component("fuelTank", function(c)
		c.label = "Fuel tank"
        c.size = love.math.random(2,4)
        c.capacity = 50000 + love.math.random(1,10) * 10000   -- how much thrust it contains
        c.maxCapacity = c.capacity
		c.maxHP = love.math.random(2,4) * 1000
		c.currentHP = c.maxHP
        c.purchasePrice = 1000
        c.description = "Engine needs this. Size " .. c.size .. ". Health " .. c.maxHP .. ". Capacity " .. c.maxCapacity .. "."
    end)


    concord.component("leftThruster", function(c)
		c.label = "Left thruster"
        c.size = love.math.random(1,3)
        c.strength = 2000 + love.math.random(1,4) * 500      -- thrust
		c.maxHP = love.math.random(1,3) * 1000
		c.currentHP = c.maxHP
        c.purchasePrice = 1000
        c.description = "Slide to the right. Size " .. c.size .. ". Health " .. c.maxHP .. ". Thrust " .. c.strength .. "."
    end)

    concord.component("rightThruster", function(c)
		c.label = "Right thruster"
        c.size = love.math.random(1,3)
        c.strength = 2000 + love.math.random(1,4) * 500      -- thrust
		c.maxHP = love.math.random(1,3) * 1000
		c.currentHP = c.maxHP
        c.purchasePrice = 1000
        c.description = "Slide to the left. Size " .. c.size .. ". Health " .. c.maxHP .. ". Thrust " .. c.strength .. "."
    end)

    concord.component("reverseThruster", function(c)
		c.label = "Reverse thruster"
        c.size = love.math.random(1,3)
        c.strength = 2000 + love.math.random(1,4) * 500      -- thrust
		c.maxHP = love.math.random(1,3) * 1000
		c.currentHP = c.maxHP
        c.purchasePrice = 1000
        c.description = "Braking is good. Size " .. c.size .. ". Health " .. c.maxHP .. ". Thrust " .. c.strength .. "."
    end)

    concord.component("miningLaser", function(c)
		c.label = "Mining laser"
        c.size = love.math.random(1,3)
        c.miningRate = love.math.random(25, 75)       -- how much mass per dt/click/whatever
        c.miningRange = love.math.random(50, 150)     -- the reach of the laser
		c.maxHP = love.math.random(1,3) * 1000
		c.currentHP = c.maxHP
        c.purchasePrice = 1000
        c.description = "Mines rocks. Size " .. c.size .. ". Health " .. c.maxHP .. ". Mining speed " .. c.miningRate .. ". Laser range " .. c.miningRange
    end)

    concord.component("battery", function(c)
        c.label = "Battery"
        c.size = love.math.random(1,3)
        c.capacity = love.math.random(60, 240)   -- how much dt it holds (seconds)
        c.maxCapacity = c.capacity
        c.maxHP = love.math.random(1,3) * 1000
        c.currentHP = c.maxHP
        c.purchasePrice = 1000
        c.description = "Powers lasers. Size " .. c.size .. ". Health " .. c.maxHP .. ". Capacity " .. c.maxCapacity .. "."
    end)

    concord.component("oxyGenerator", function(c)
        c.label = "O2 Generator"
        c.size = love.math.random(1,3)
        c.powerNeeds = love.math.random(1,3)        -- how much power per dt
        c.maxHP = love.math.random(1,3) * 1000
        c.currentHP = c.maxHP
        c.purchasePrice = 1000
        c.description = "Makes O2 to keep you alive. Size " .. c.size .. ". Health " .. c.maxHP .. ". Draws " .. c.powerNeeds .. " per second."
    end)

    concord.component("oxyTank", function(c)
        c.label = "O2 tank"
        c.size = love.math.random(1,3)
        c.capacity = love.math.random(300, 600)   -- 430   -- how much dt it holds (seconds)
        c.maxCapacity = c.capacity
        c.maxHP = love.math.random(1,3) * 1000
        c.currentHP = c.maxHP
        c.purchasePrice = 1000
        c.description = "Holds spare oxygen. Size " .. c.size .. ". Health " .. c.maxHP .. ". Capactiy " .. c.capacity .. " seconds."
    end)

    concord.component("spaceSuit", function(c)
        c.label = "Space suit"
        c.size = 0
        c.O2capacity = love.math.random(50, 200)  -- 100   -- how much dt it holds (seconds)
        c.maxO2Capacity = c.O2capacity
        c.purchasePrice = 1000
        c.description = "Use when O2 runs out. O2 capacity " .. c.maxO2Capacity .. " seconds."
    end)

    concord.component("solarPanel", function(c)
        c.label = "Solar panel"
        c.size = love.math.random(1,3)
        c.rechargeRate = love.math.random(1,10) / 10
        c.maxHP = love.math.random(1,3) * 1000
        c.currentHP = c.maxHP
        c.purchasePrice = 1000
        c.description = "Recharges batteries. Size " .. c.size .. ". Health " .. c.maxHP .. ". Recharge rate " .. c.rechargeRate .. " power/sec."
    end)

    concord.component("cargoHold", function(c)
        c.label = "Cargo hold"
        c.size = love.math.random(1,3)
        c.maxAmount = 5000 * c.size
        c.currentAmount = 0         -- current amount stored
        c.maxHP = love.math.random(1,3) * 1000
        c.currentHP = c.maxHP
        c.purchasePrice = 1000
        c.description = "Holds rocks. Size " .. c.size .. ". Health " .. c.maxHP .. ". Capacity " .. c.maxAmount .. " tons."
    end)
end

return cmp
