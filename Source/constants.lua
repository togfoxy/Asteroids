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

    ECSWORLD = {}
    ECS_ENTITIES = {}
    PHYSICS_ENTITIES = {}

    PLAYER = {}
    PLAYER.UID = 0              -- store this globally for easy recall
    PLAYER.POINTS = {}
    --PLAYER.POINTS = {-5, -5, 5, -5, 5, 5, -5, 5}
    -- PLAYER.POINTS = {-50, -50, 50, -50, 50, 50, -50, 50}

    AUDIO = {}
    IMAGES = {}
    FONT = {}

    STARTING_SIZE = 3        -- the size of the chassis or base ship
    PHYSICS_DENSITY = 4    -- how many kg's each mass weighs

    PHYSICS_TURNRATE = 15       -- how fast can objects turn

end


return constants
