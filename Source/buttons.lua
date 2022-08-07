buttons = {}

function buttons.setButtonVisible(enumvalue)
	-- receives an enum (number) and sets the visibility of that button to true
	for k, button in pairs(GUI_BUTTONS) do
		if button.identifier == enumvalue then
			button.visible = true
			break
		end
	end
end

function buttons.setButtonInvisible(enumvalue)
	-- receives an enum (number) and sets the visibility of that button to false
	for k, button in pairs(GUI_BUTTONS) do
		if button.identifier == enumvalue then
			button.visible = false
			break
		end
	end
end

function buttons.buttonClicked(mx, my, button)
	-- the button table is a global table
	-- check if mouse click is inside any button
	-- mx, my = mouse click X/Y
	-- button is from the global table
	-- returns the identifier of the button (enum) or nil
	if mx >= button.x and mx <= button.x + button.width and
		my >= button.y and my <= button.y + button.height then
			return button.identifier
	else
		return nil
	end
end

function buttons.loadButtons()
	-- load the global GUI_BUTTONS table with buttons
	local mybutton = {}

	-- alarms off
	local mybutton = {}
	mybutton.x = 12
	mybutton.y = 151
	mybutton.width = 65
	mybutton.height = 20
	mybutton.drawOutline = false
	mybutton.label = ""		-- alarm off
	mybutton.image = nil
	-- mybutton.labelcolour = {1,1,1,1}
	mybutton.labeloffcolour = {1,1,1,1}
	mybutton.labeloncolour = {1,1,1,1}
	mybutton.bgcolour = {1,0,0,1}
	mybutton.state = "on"
	mybutton.visible = true
	mybutton.scene = enum.sceneAsteroid
	mybutton.identifier = enum.buttonAlarmOff
	table.insert(GUI_BUTTONS, mybutton)
	-- SOS Beacon
	local mybutton = {}
	mybutton.x = 115
	mybutton.y = 150
	mybutton.width = 60
	mybutton.height = 20
	mybutton.drawOutline = false
	mybutton.label = "SOS"
	mybutton.labelxoffset = 20
	mybutton.image = IMAGES[enum.imagesButton]
	mybutton.labeloffcolour = {1,1,1,1}
	mybutton.labeloncolour = {0,1,0,1}
	mybutton.bgcolour = {1,1,1,1}
	mybutton.state = "off"
	mybutton.visible = false
	mybutton.scene = enum.sceneAsteroid
	mybutton.identifier = enum.buttonSOSBeacon
	table.insert(GUI_BUTTONS, mybutton)
	-- Eject!
	local mybutton = {}
	mybutton.x = 115
	mybutton.y = 225
	mybutton.width = 60
	mybutton.height = 20
	mybutton.drawOutline = false
	mybutton.label = "Eject!"
	mybutton.labelxoffset = 20
	mybutton.image = IMAGES[enum.imagesButton]
	mybutton.labeloffcolour = {1,1,1,1}
	mybutton.labeloncolour = {0,1,0,1}
	mybutton.bgcolour = {1,1,1,1}
	mybutton.state = "off"
	mybutton.visible = false
	mybutton.scene = enum.sceneAsteroid
	mybutton.identifier = enum.buttonEjectionPod			-- ensure to give a unique enum
	table.insert(GUI_BUTTONS, mybutton)



	-- main menu
	local mybutton = {}
	mybutton.x = SCREEN_WIDTH / 2
	mybutton.y = SCREEN_HEIGHT / 3
	mybutton.width = 100
	mybutton.height = 25
	mybutton.label = "New game"
	mybutton.image = nil
	mybutton.labelcolour = {1,1,1,1}
	mybutton.bgcolour = {0,1,0,1}
	mybutton.state = "off"
	mybutton.visible = true
	mybutton.scene = enum.sceneMainMenu
	mybutton.identifier = enum.buttonNewGame
	table.insert(GUI_BUTTONS, mybutton)
	-- load game
	local mybutton = {}
	mybutton.x = SCREEN_WIDTH / 2
	mybutton.y = (SCREEN_HEIGHT / 3) + 100
	mybutton.width = 100
	mybutton.height = 25
	mybutton.label = "Load game"
	mybutton.image = nil
	mybutton.labelcolour = {1,1,1,1}
	mybutton.bgcolour = {0,1,0,1}
	mybutton.state = "off"
	mybutton.visible = true
	mybutton.scene = enum.sceneMainMenu
	mybutton.identifier = enum.buttonLoadGame
	table.insert(GUI_BUTTONS, mybutton)
	-- save game
	local mybutton = {}
	mybutton.x = SCREEN_WIDTH / 2
	mybutton.y = (SCREEN_HEIGHT / 3) + 200
	mybutton.width = 100
	mybutton.height = 25
	mybutton.label = "Save game"
	mybutton.image = nil
	mybutton.labelcolour = {1,1,1,1}
	mybutton.bgcolour = {0,1,0,1}
	mybutton.state = "off"
	mybutton.visible = true
	mybutton.scene = enum.sceneMainMenu
	mybutton.identifier = enum.buttonSaveGame
	table.insert(GUI_BUTTONS, mybutton)
	-- settings
	local mybutton = {}
	mybutton.x = SCREEN_WIDTH / 2
	mybutton.y = (SCREEN_HEIGHT / 3) + 300
	mybutton.width = 100
	mybutton.height = 25
	mybutton.label = "Settings"
	mybutton.image = nil
	mybutton.labelcolour = {1,1,1,1}
	mybutton.bgcolour = {0,1,0,1}
	mybutton.state = "off"
	mybutton.visible = false
	mybutton.scene = enum.sceneMainMenu
	mybutton.identifier = enum.buttonSettings
	table.insert(GUI_BUTTONS, mybutton)
	-- credits
	local mybutton = {}
	mybutton.x = SCREEN_WIDTH / 2
	mybutton.y = (SCREEN_HEIGHT / 3) + 300
	mybutton.width = 100
	mybutton.height = 25
	mybutton.label = "Credits"
	mybutton.image = nil
	mybutton.labelcolour = {1,1,1,1}
	mybutton.bgcolour = {0,1,0,1}
	mybutton.state = "off"
	mybutton.visible = false
	mybutton.scene = enum.sceneMainMenu
	mybutton.identifier = enum.buttonCredits		-- NOTE: ensure you set the identifier
	table.insert(GUI_BUTTONS, mybutton)




end





return buttons
