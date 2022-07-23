cmp = {}

function cmp.init()

    concord.component("uid", function(c)
        c.value = cf.Getuuid()
    end)

    concord.component("drawable")   -- will be drawn during love.draw()

	concord.component("chassis", function(c)
		c.label = "Chassis"
        c.size = 3
		c.maxHP = 10000
		c.currentHP = c.maxHP
        c.purchasePrice = 1000
    end)

    concord.component("engine", function(c)
		c.label = "Main engine"
        c.size = 3
        c.strength = 10000      -- thrust
		c.maxHP = 3000
		c.currentHP = c.maxHP
        c.purchasePrice = 1000
    end)

    concord.component("fuelTank", function(c)
		c.label = "Fuel tank"
        c.size = 3
        c.capacity = 1000000   -- how much thrust it contains
        c.maxCapacity = c.capacity
		c.maxHP = 3000
		c.currentHP = c.maxHP
        c.purchasePrice = 1000
    end)


    concord.component("leftThruster", function(c)
		c.label = "Left thruster"
        c.size = 1
        c.strength = 2500      -- thrust
		c.maxHP = 1000
		c.currentHP = c.maxHP
        c.purchasePrice = 1000
    end)

    concord.component("rightThruster", function(c)
		c.label = "Right thruster"
        c.size = 1
        c.strength = 2500      -- thrust
		c.maxHP = 1000
		c.currentHP = c.maxHP
        c.purchasePrice = 1000
    end)

    concord.component("reverseThruster", function(c)
		c.label = "Reverse thruster"
        c.size = 1
        c.strength = 2500      -- thrust
		c.maxHP = 1000
		c.currentHP = c.maxHP
        c.purchasePrice = 1000
    end)

    concord.component("miningLaser", function(c)
		c.label = "Mining laser"
        c.size = 1
        c.miningRate = 50       -- how much mass per dt/click/whatever
        c.miningRange = 100     -- the reach of the laser
		c.maxHP = 1000
		c.currentHP = c.maxHP
        c.purchasePrice = 1000
    end)

    concord.component("battery", function(c)
        c.label = "Battery"
        c.size = 1
        c.capacity = 9   -- how much dt it holds (seconds)
        c.maxCapacity = c.capacity
        c.maxHP = 1000
        c.currentHP = c.maxHP
        c.purchasePrice = 1000
    end)

    concord.component("oxyGenerator", function(c)
        c.label = "O2 Generator"
        c.size = 1
        c.capacity = 10   -- how much dt it holds (seconds)
        c.powerNeeds = 1        -- how much power per dt
        c.maxHP = 1000
        c.currentHP = c.maxHP
        c.purchasePrice = 1000
    end)

    concord.component("oxyTank", function(c)
        c.label = "O2 tank"
        c.size = 1
        c.capacity = 430   -- 430   -- how much dt it holds (seconds)
        c.maxCapacity = c.capacity
        c.maxHP = 1000
        c.currentHP = c.maxHP
        c.purchasePrice = 1000
    end)

    concord.component("spaceSuit", function(c)
        c.label = "Space suit"
        c.size = 0
        c.O2capacity = 100-- 100   -- how much dt it holds (seconds)
        c.maxO2Capacity = c.capacity
        c.purchasePrice = 1000
    end)

    concord.component("solarPanel", function(c)
        c.label = "Solar panel"
        c.size = 1
        c.rechargeRate = 1
        c.maxHP = 1000
        c.currentHP = c.maxHP
        c.purchasePrice = 1000
    end)

    concord.component("cargoHold", function(c)
        c.label = "Cargo hold"
        c.size = 2
        c.maxAmount = 10000          -- idk
        c.currentAmount = 0         -- current amount stored
        c.maxHP = 2000
        c.currentHP = c.maxHP
        c.purchasePrice = 1000
    end)

end

return cmp
