local GameController = {}

local Loading = require(game.ReplicatedStorage.Computer.Modules.Workspace.Game.Loading)
local ChaptersSelection = require(game.ReplicatedStorage.Computer.Modules.Workspace.Game.ChaptersSelection)
local Functions = require(game.ReplicatedStorage.Computer.Modules.Workspace.Game.Functions)
local ConnectionsFunctions = require(game.ReplicatedStorage.Computer.Modules.Workspace.ConnectionsFunctions)

function GameController.Start(player:Player, toBlockButtons, States, Remotes, GameInstances, Connections, Sounds)
	-- Get the buttons to block interactions
	local startButton:ImageButton = toBlockButtons.startButton
	
	-- Get states
	local turningOff = States.turningOff
	local loggingOff = States.loggingOff
	
	-- Get events/functions
	local GetChaptersData = Remotes.GetChaptersData
	local TurnOffComputer = Remotes.TurnOffComputer
	local StartGameTeleport = Remotes.StartGameTeleport
	local HandleTutorial = Remotes.HandleTutorial
	
	-- Get game instances
	local loadingFrame:Frame = GameInstances.loadingFrame
	local gameButton:ImageButton = GameInstances.gameButton
	local mainFrame:Frame = GameInstances.mainFrame
	local chapterFrame:Frame = GameInstances.chapterFrame
	local desktopGui = GameInstances.desktopGui
	
	-- Get other instances
	local gameButtonClicked:BoolValue = gameButton.Clicked
	
	-- Get sounds
	local oldMouseClick = Sounds.oldMouseClick
	
	-- Main Script --
	
	-- Handle clicking the game button
	local gameButtonConnection = gameButton.MouseButton1Click:Connect(function()
		-- To not bug
		if turningOff or loggingOff then
			return
		end
		
		-- Handle not double clicking
		if gameButtonClicked.Value == false then
			
			oldMouseClick:Play()
			
			-- Change the clicked value
			gameButtonClicked.Value = true
			
			-- Block the buttons in the table
			startButton.Interactable = false
			
			-- Block the game button
			gameButton.Interactable = false
			
			-- Start the loading and awaits it end
			Loading.StartLoading(loadingFrame, Sounds)
			
			-- Handle tutorial phase 6
			HandleTutorial:Fire(6)
			
			-- Start the chapter selection
			ChaptersSelection.Start(
				player,
				{
					startButton = startButton,
					mainFrame = mainFrame,
					gameButton = gameButton,
					gameButtonClicked = gameButtonClicked,
					chapterFrame = chapterFrame,
					desktopGui = desktopGui,
				},
				{
					GetChaptersData = GetChaptersData,
					TurnOffComputer = TurnOffComputer,
					StartGameTeleport = StartGameTeleport,
					HandleTutorial = HandleTutorial,
				},
				Connections,
				Sounds
			)
		
		end
		
	end)
	
	
end

return GameController
