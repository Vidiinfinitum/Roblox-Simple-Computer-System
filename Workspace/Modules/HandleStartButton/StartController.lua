local StartController = {}

-- Modules --
local Musics = require(game.ReplicatedStorage.Computer.Modules.Workspace.ComputerStartButton.Musics)
local UserIcons = require(game.ReplicatedStorage.Computer.Modules.Workspace.ComputerStartButton.UserIcons)
local Wallpapers = require(game.ReplicatedStorage.Computer.Modules.Workspace.ComputerStartButton.Wallpapers)
local UIFunctions = require(game.ReplicatedStorage.Computer.Modules.Workspace.ComputerStartButton.UIFunctions)
local ConnectionsFunctions = require(game.ReplicatedStorage.Computer.Modules.Workspace.ConnectionsFunctions)

function StartController.Start(player:Player, toBlockButtons, options, Remotes, Connections, otherInstances, States)

	local currentHouseMusic = game.SoundService:WaitForChild("CurrentHouseMusic")
	
	-- Get the buttons to block interactions
	local gameButton = toBlockButtons.gameButton
	
	-- Get states
	local turningOff = States.turningOff
	local loggingOff = States.loggingOff

	-- Get other instances
	local desktopGui = otherInstances.desktopGui
	local background = otherInstances.background
	local startButton = otherInstances.startButton
	local startButtonClicked = otherInstances.startButtonClicked
	local oldMouseClick = otherInstances.oldMouseClick
	local windowsXpLogoff = otherInstances.windowsXpLogoff
	local windowsXpShutdown = otherInstances.windowsXpShutdown

	-- Get the events
	local GetCurrentUserIcon = Remotes.GetCurrentUserIcon
	local ChangeCurrentUserIcon = Remotes.ChangeCurrentUserIcon
	local GetCurrentHouseMusic = Remotes.GetCurrentHouseMusic
	local ChangeCurrentHouseMusic = Remotes.ChangeCurrentHouseMusic
	local GetCurrentWallpaper = Remotes.GetCurrentWallpaper
	local ChangeCurrentWallpaper = Remotes.ChangeCurrentWallpaper
	local GetAll = Remotes.GetAll
	local StartLogin = Remotes.StartLogin
	local TurnOffComputer = Remotes.TurnOffComputer

	-- Get the connections
	local optionsConnections = Connections.optionsConnections
	local userIconsConnections = Connections.userIconsConnections
	local wallpapersConnections = Connections.wallpapersConnections
	local musicsConnections = Connections.musicsConnections

	-- Get the functions
	local startSelection = UIFunctions.startSelection
	local connect = ConnectionsFunctions.connect
	local clearConnections = ConnectionsFunctions.clearConnections 
	local refreshOptions = UIFunctions.refreshOptions
	local updateCanvas = UIFunctions.updateCanvas

	-- Get options objects
	local optionsFrame = options:WaitForChild("OptionsFrame")
	local userIconsFrame = options:WaitForChild("UserIconsFrame")
	local wallpapersFrame = options:WaitForChild("WallpapersFrame")
	local musicsFrame = options:WaitForChild("MusicsFrame")

	-- Get options frame objects
	local logOffButton = optionsFrame:WaitForChild("DownBorder"):WaitForChild("LogOffButton")
	local logOffSelectionFrame = optionsFrame:WaitForChild("DownBorder"):WaitForChild("LogOffSelectionFrame")
	local turnOffButton = optionsFrame:WaitForChild("DownBorder"):WaitForChild("TurnOffButton")
	local turnOffSelectionFrame = optionsFrame:WaitForChild("DownBorder"):WaitForChild("TurnOffSelectionFrame")

	local userButton = optionsFrame:WaitForChild("UpBorder"):WaitForChild("PlayerUser"):WaitForChild("Button")
	local userButtonClicked = userButton:WaitForChild("Clicked")
	local userName = optionsFrame:WaitForChild("UpBorder"):WaitForChild("PlayerUser"):WaitForChild("Name")
	local userSelectionFrame = optionsFrame:WaitForChild("UpBorder"):WaitForChild("UserSelectionFrame")

	local wallpapersButton = optionsFrame:WaitForChild("MidFrame"):WaitForChild("WallpapersButton")
	local wallpapersButtonClicked = wallpapersButton:WaitForChild("Clicked")
	local wallpapersSelectionFrame = optionsFrame:WaitForChild("MidFrame"):WaitForChild("WallpaperSelectionFrame")
	local musicsButton = optionsFrame:WaitForChild("MidFrame"):WaitForChild("MusicsButton")
	local musicsButtonClicked = musicsButton:WaitForChild("Clicked")
	local musicsSelectionFrame = optionsFrame:WaitForChild("MidFrame"):WaitForChild("MusicsSelectionFrame")

	-- Get userIcons frame objects
	local userTemplate = userIconsFrame:WaitForChild("Template")
	local userIconOptions = userIconsFrame:WaitForChild("IconOptions")
	local userExitButton = userIconsFrame:WaitForChild("UpBorder"):WaitForChild("ExitButton")

	-- Get wallpapers frame objects
	local wallpaperTemplate = wallpapersFrame:WaitForChild("Template")
	local wallpaperOptions = wallpapersFrame:WaitForChild("WallpaperOptions")
	local wallpapersExitButton = wallpapersFrame:WaitForChild("UpBorder"):WaitForChild("ExitButton")

	-- Get musics frame objects
	local musicTemplate = musicsFrame:WaitForChild("Template")
	local musicOptions = musicsFrame:WaitForChild("MusicOptions")
	local musicsExitButton = musicsFrame:WaitForChild("UpBorder"):WaitForChild("ExitButton")

	-- Get the current user icon and set it
	local currentUserIconId = GetCurrentUserIcon:InvokeServer("Id")
	if currentUserIconId then
		userButton.Image = currentUserIconId
	end

	-- Set the user name
	userName.Text = player.Name

	-- Get the current wallpaper and set it
	local currentWallpaperName = GetCurrentWallpaper:InvokeServer("Name")
	print(currentWallpaperName)
	if currentWallpaperName == "Default" then
		background.ImageTransparency = 1
		background.BackgroundTransparency = 0
	else
		local currentWallpaperId = GetCurrentWallpaper:InvokeServer("Id")
		background.ImageTransparency = 0
		background.BackgroundTransparency = 0
		background.Image = currentWallpaperId
	end
	

	local startButtonConnection = startButton.MouseButton1Click:Connect(function()

		oldMouseClick:Play()
		if startButtonClicked.Value == false then

			-- To not bug
			if turningOff or loggingOff then
				return
			end
			
			-- Block the buttons in the table
			gameButton.Interactable = false
			
			-- To updadte de clicked value
			startButtonClicked.Value = true

			-- To be able to see and navegate in the options frame
			optionsFrame.Visible = true

			-- Handle log off button
			local logOffButtonConnection1 = logOffButton.MouseEnter:Connect(function()
				startSelection(logOffSelectionFrame, true)
			end)
			connect(optionsConnections, logOffButtonConnection1)

			local logOffButtonConnection2 = logOffButton.MouseLeave:Connect(function()
				startSelection(logOffSelectionFrame, false)
			end)
			connect(optionsConnections, logOffButtonConnection2)

			local logOffButtonConnection3 = logOffButton.MouseButton1Click:Connect(function()
				-- To not bugg
				if turningOff then
					return
				end

				loggingOff = true

				-- Disconnect all connections
				for index, connection in Connections do
					clearConnections(connection)
				end
				
				oldMouseClick:Play()
				windowsXpLogoff:Play()
				desktopGui:Destroy()
				StartLogin:Fire()
			end)
			connect(optionsConnections, logOffButtonConnection3)

			-- Handle turn off button
			local turnOffButtonConnection1 = turnOffButton.MouseEnter:Connect(function()
				startSelection(turnOffSelectionFrame, true)
			end)
			connect(optionsConnections, turnOffButtonConnection1)

			local turnOffButtonConnection2 = turnOffButton.MouseLeave:Connect(function()
				startSelection(turnOffSelectionFrame, false)
			end)
			connect(optionsConnections, turnOffButtonConnection2)

			local turnOffButtonConnection3 = turnOffButton.MouseButton1Click:Connect(function()
				-- To not bug
				if loggingOff then
					return
				end

				-- Disconnect all connections
				for index, connection in Connections do
					clearConnections(connection)
				end
				
				turningOff = true
				oldMouseClick:Play()
				windowsXpShutdown:Play()
				desktopGui:Destroy()
				TurnOffComputer:Fire()
			end)
			connect(optionsConnections, turnOffButtonConnection3)

			-- To handle user button
			local userButtonConnection1 = userButton.MouseEnter:Connect(function()
				startSelection(userSelectionFrame, true)
			end)
			connect(optionsConnections, userButtonConnection1)

			local userButtonConnection2 = userButton.MouseLeave:Connect(function()
				startSelection(userSelectionFrame, false)
			end)
			connect(optionsConnections, userButtonConnection2)

			local userButtonConnection3 = userButton.MouseButton1Click:Connect(function()
				if turningOff or loggingOff then
					return
				end

				oldMouseClick:Play()

				if userButtonClicked.Value == false then
					userButtonClicked.Value = true

					oldMouseClick:Play()

					-- Turn off interactable to not be able to click
					startButton.Interactable = false
					turnOffButton.Interactable = false
					logOffButton.Interactable = false
					wallpapersButton.Interactable = false
					musicsButton.Interactable = false
					userButton.Interactable = false

					-- Make the user icon frame visible
					userIconsFrame.Visible = true

					-- Make the selection frame on
					startSelection(userSelectionFrame, true)

					-- Hold exit button clicking
					local userExitButtonConnection = userExitButton.MouseButton1Click:Connect(function()
						oldMouseClick:Play()

						-- Reset the user button cliked value
						userButtonClicked.Value = false	

						userIconsFrame.Visible = false

						-- Disconnect icons connections
						clearConnections(userIconsConnections)

						-- Turn on interactable to be able to click
						startButton.Interactable = true
						turnOffButton.Interactable = true
						logOffButton.Interactable = true
						wallpapersButton.Interactable = true
						musicsButton.Interactable = true
						userButton.Interactable = true
					end)
					connect(userIconsConnections, userExitButtonConnection)

					UserIcons.StartFrame(
						userIconOptions,
						userTemplate,
						userIconsConnections,
						userButton,
						oldMouseClick,
						{
							startSelection = startSelection,
							refreshOptions = refreshOptions,
							connect = connect,
							updateCanvas = updateCanvas,
						},
						{
							GetCurrentUserIcon = GetCurrentUserIcon,
							ChangeCurrentUserIcon = ChangeCurrentUserIcon,
							GetAll = GetAll,
						}
					)
				end
			end)
			connect(optionsConnections, userButtonConnection3)

			-- To handle musics button
			local musicsButtonConnection1 = musicsButton.MouseEnter:Connect(function()
				startSelection(musicsSelectionFrame, true)
			end)
			connect(optionsConnections, musicsButtonConnection1)

			local musicsButtonConnection2 = musicsButton.MouseLeave:Connect(function()
				startSelection(musicsSelectionFrame, false)
			end)
			connect(optionsConnections, musicsButtonConnection2)

			local musicsButtonConnection3 = musicsButton.MouseButton1Click:Connect(function()
				if turningOff or loggingOff then
					return
				end

				oldMouseClick:Play()

				if musicsButtonClicked.Value == false then
					musicsButtonClicked.Value = true

					oldMouseClick:Play()

					-- Turn off interactable to not be able to click
					startButton.Interactable = false
					turnOffButton.Interactable = false
					logOffButton.Interactable = false
					wallpapersButton.Interactable = false
					musicsButton.Interactable = false
					userButton.Interactable = false

					-- Make the musics frame visible
					musicsFrame.Visible = true

					-- Make the selection frame on
					startSelection(musicsSelectionFrame, true)

					-- Hold exit button clicking
					local musicsExitButtonConnection = musicsExitButton.MouseButton1Click:Connect(function()
						oldMouseClick:Play()

						-- Reset the musics button cliked value
						musicsButtonClicked.Value = false	

						-- Make it desappear
						musicsFrame.Visible = false

						-- Disconnect musics connections
						clearConnections(musicsConnections)

						-- Turn on interactable to be able to click
						startButton.Interactable = true
						turnOffButton.Interactable = true
						logOffButton.Interactable = true
						wallpapersButton.Interactable = true
						musicsButton.Interactable = true
						userButton.Interactable = true
					end)
					connect(musicsConnections, musicsExitButtonConnection)

					Musics.StartFrame(
						musicOptions,
						musicTemplate, 
						currentHouseMusic, 
						musicsConnections, 
						oldMouseClick,
						{
							StartSelection = startSelection,
							refreshOptions = refreshOptions,
							connect = connect,
							updateCanvas = updateCanvas
						},
						{
							GetCurrentHouseMusic = GetCurrentHouseMusic,
							ChangeCurrentHouseMusic = ChangeCurrentHouseMusic,
							GetAll = GetAll
						}
					)

				end
			end)
			connect(optionsConnections, musicsButtonConnection3)

			-- To handle wallpapers button
			local wallpapersButtonConnection1 = wallpapersButton.MouseEnter:Connect(function()
				startSelection(wallpapersSelectionFrame, true)
			end)
			connect(optionsConnections, wallpapersButtonConnection1)

			local wallpapersButtonConnection2 = wallpapersButton.MouseLeave:Connect(function()
				startSelection(wallpapersSelectionFrame, false)
			end)
			connect(optionsConnections, wallpapersButtonConnection2)

			local wallpapersButtonConnection3 = wallpapersButton.MouseButton1Click:Connect(function()
				if turningOff or loggingOff then
					return
				end

				oldMouseClick:Play()

				if wallpapersButtonClicked.Value == false then
					wallpapersButtonClicked.Value = true

					oldMouseClick:Play()

					-- Turn off interactable to not be able to click
					startButton.Interactable = false
					turnOffButton.Interactable = false
					logOffButton.Interactable = false
					wallpapersButton.Interactable = false
					musicsButton.Interactable = false
					userButton.Interactable = false

					-- Make the wallpapers frame visible
					wallpapersFrame.Visible = true

					-- Make the selection frame on
					startSelection(wallpapersSelectionFrame, true)

					-- Hold exit button clicking
					local wallpapersExitButtonConnection = wallpapersExitButton.MouseButton1Click:Connect(function()
						oldMouseClick:Play()

						-- Reset the wallpapers button cliked value
						wallpapersButtonClicked.Value = false	

						-- Make it desappear
						wallpapersFrame.Visible = false

						-- Disconnect wallpapers connections
						clearConnections(wallpapersConnections)

						-- Turn on interactable to be able to click
						startButton.Interactable = true
						turnOffButton.Interactable = true
						logOffButton.Interactable = true
						wallpapersButton.Interactable = true
						musicsButton.Interactable = true
						userButton.Interactable = true
					end)
					connect(wallpapersConnections, wallpapersExitButtonConnection)

					Wallpapers.StartFrame(
						wallpaperOptions,
						wallpapersConnections, 
						wallpaperTemplate, 
						oldMouseClick, 
						background,
						{
							StartSelection = startSelection,
							refreshOptions = refreshOptions,
							connect = connect,
							updateCanvas = updateCanvas
						},
						{
							GetCurrentWallpaper = GetCurrentWallpaper,
							ChangeCurrentWallpaper = ChangeCurrentWallpaper,
							GetAll = GetAll
						}
					)
				end
			end)
			connect(optionsConnections, wallpapersButtonConnection3)
		else
			-- To not bug	
			if turningOff or loggingOff then
				return
			end
			
			-- Unblock the buttons in the table
			gameButton.Interactable = true
			
			startButtonClicked.Value = false

			optionsFrame.Visible = false

			-- Disconnect options connections
			clearConnections(optionsConnections)
		end
	end)
end

return StartController
