constants = {}

function constants.load()
    -- constants and globals

    SCREEN_WIDTH = 1920
    SCREEN_HEIGHT = 1080

    PHYSICS_WIDTH = 1000	-- metres
    PHYSICS_HEIGHT = 1000	-- metres
	PHYSICS_SAFEZONE = 100	-- this is 1oo metres on/near the spacedock
    BOX2D_SCALE = 5

    ZOOMFACTOR = 0.9
    TRANSLATEX = (PHYSICS_WIDTH * BOX2D_SCALE) / 2
    TRANSLATEY = (PHYSICS_HEIGHT * BOX2D_SCALE) / 2

    SCREEN_STACK = {}

    SHOPWORLD = nil         -- this is to hold ALL the shopping components
    ECSWORLD = {}
    ECS_ENTITIES = {}
    PHYSICS_ENTITIES = {}
    SHOP_ENTITY = nil


    PLAYER = {}
    PLAYER.UID = 0              -- store this globally for easy recall
    PLAYER.POINTS = {}
    --PLAYER.POINTS = {-5, -5, 5, -5, 5, 5, -5, 5}
    -- PLAYER.POINTS = {-50, -50, 50, -50, 50, 50, -50, 50}

    AUDIO = {}
    IMAGES = {}
    FONT = {}
    BUTTONS = {}

    PHYSICS_DENSITY = 4    -- how many kg's each mass weighs

    PHYSICS_TURNRATE = 15       -- how fast can objects turn

	NUMBER_OF_ASTEROIDS = 65

    FUEL_CONSUMPTION_RATE = 400      -- low numbers = burns more fuel. High numbers = burns less fuel

    DEAD_ALPHA = 0                  -- used to fade to black when dead

    SHOP_TIMER = 0
    DEFAULT_SHOP_TIMER = 3 * 60     -- seconds
end


return constants
