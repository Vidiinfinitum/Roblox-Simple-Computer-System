local ConnectionsFunctions = require(game.ReplicatedStorage.Computer.Modules.Workspace.ConnectionsFunctions)
local Functions = require(game.ReplicatedStorage.Computer.Modules.Workspace.Game.Functions)

local ChapterScreen = {}

function ChapterScreen.Start(player:Player, chapterInformation, Instances, Remotes, Connections, Sounds)
	
	-- Get userfull instances
	local mainFrame:Frame = Instances.mainFrame
	local chapterFrame:Frame = Instances.chapterFrame
	local desktopGui:ScreenGui = Instances.desktopGui
	
	-- Get events/functions
	local TurnOffComputer:BindableEvent = Remotes.TurnOffComputer
	local StartGameTeleport:RemoteEvent = Remotes.StartGameTeleport
	local HandleTutorial = Remotes.HandleTutorial
	
	-- Get connections
	local chapterScreenConnections = Connections.chapterScreenConnections
	
	-- Get chapterFrame userfull instances
	local chapterImage:ImageLabel = chapterFrame.ChapterImage
	local completedText:TextLabel = chapterFrame.CompletedText
	local memoriesText:TextLabel = chapterFrame.MemoriesText
	local title:TextLabel = chapterFrame.Title
	local chapter:TextLabel = chapterFrame.UpFrame.Chapter
	local exitButton:ImageButton = chapterFrame.UpFrame.ExitButton
	local playButton:TextButton = chapterFrame.PlayFrame.PlayButton
	
	-- Get sounds
	local oldMouseClick:Sound = Sounds.oldMouseClick
	local windowsXpShutdown:Sound = Sounds.windowsXpShutdown
	local loadingConfirmation = Sounds.loadingConfirmation
	
	-- Main Script --
	
	-- Turns the mainFrame invisible
	mainFrame.Visible = false
	
	-- Put the chapterImage
	chapterImage.Image = chapterInformation.ImageId
	
	-- Set the completed text format
	if chapterInformation.Completed then
		completedText.Text = "Completed"
		completedText.TextColor3 = Color3.fromRGB(0, 255, 0)
		playButton.Text = "Retry"
	else
		completedText.Text = "Not completed"
		completedText.TextColor3 = Color3.fromRGB(255, 0, 0)
	end
	
	-- Set the memories text
	local totalMemories = Functions.getTableSize(chapterInformation.Memories)
	local memoriesGot = Functions.getMemoriesGot(chapterInformation.Memories)
	
	if totalMemories == 0 then
		memoriesText.Text = "No memories"
	else
		memoriesText.Text = string.format("Memories: %d/%d", memoriesGot, totalMemories)
	end
	
	-- Set the title
	title.Text = chapterInformation.Title
	
	-- Set the chapter number
	chapter.Text = chapterInformation.Name
	
	-- Turn the chapterFrame visible
	chapterFrame.Visible = true
	
	-- Handles clicking in exit button
	local exitButtonConnection = exitButton.MouseButton1Click:Connect(function()
		oldMouseClick:Play()
		-- Make invisible the chapterFrame
		chapterFrame.Visible = false
		-- Make the mainFrame visible again
		mainFrame.Visible = true
		-- Clear connections
		ConnectionsFunctions.clearConnections(chapterScreenConnections)
	end)
	ConnectionsFunctions.connect(chapterScreenConnections, exitButtonConnection)
	
	-- Handle play button
	
	local playButtonClickConnection = playButton.MouseButton1Click:Connect(function()
		oldMouseClick:Play()
		
		-- Handle tutorial phase 8
		if chapterInformation.Key == "Tutorial" then
			HandleTutorial:Fire(8)
		end
		
		-- Clear all connections in computer
		for index, connection in pairs(Connections) do
			ConnectionsFunctions.clearConnections(connection)
		end
		
		-- Responsible to turn off the computer
		windowsXpShutdown:Play()
		desktopGui:Destroy()
		TurnOffComputer:Fire()
		
		-- Start the teleport event
		StartGameTeleport:FireServer(chapterInformation.Key)
		
	end) 
	ConnectionsFunctions.connect(chapterScreenConnections, playButtonClickConnection)
	
end

return ChapterScreen
