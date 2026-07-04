local ConnectionsFunctions = require(game.ReplicatedStorage.Computer.Modules.Workspace.ConnectionsFunctions)
local ChapterScreen = require(game.ReplicatedStorage.Computer.Modules.Workspace.Game.ChapterScreen)
local Functions = require(game.ReplicatedStorage.Computer.Modules.Workspace.Game.Functions)

local ChaptersSelection = {}

-- Table to stores the loaded chapters (for organization)
local LoadedChapters = {}

function ChaptersSelection.Start(player:Player, Instances, Remotes, Connections, Sounds)
	
	-- Get the userfull frames
	local mainFrame:Frame = Instances.mainFrame
	local gameButton:ImageButton = Instances.gameButton
	local gameButtonClicked:BoolValue = Instances.gameButtonClicked
	local startButton:ImageButton = Instances.startButton
	local chapterFrame:Frame = Instances.chapterFrame
	
	-- Get desktopGui
	local desktopGui = Instances.desktopGui
	
	-- Get the events/functions
	local GetChaptersData = Remotes.GetChaptersData
	local TurnOffComputer = Remotes.TurnOffComputer
	local StartGameTeleport = Remotes.StartGameTeleport
	local HandleTutorial = Remotes.HandleTutorial
	
	-- Get connections
	local chapterSelectConnections = Connections.chapterSelectConnections
	
	-- Get sounds
	local oldMouseClick = Sounds.oldMouseClick
	
	-- Get mainFrame instances
	local chaptersFrame:ScrollingFrame = mainFrame.ChaptersFrame
	local template:Frame = mainFrame.Template
	local upFrame:Frame = mainFrame.UpFrame
	
	-- Get chaptersFrame uiGrid
	local UiGrid:UIGridLayout = chaptersFrame.UIGridLayout

	-- Get exit button instance
	local exitButton:ImageButton = upFrame.ExitButton
	
	-- Main Script --
	
	-- Make the mainFrame visible
	mainFrame.Visible = true
	
	-- Handle exitButton
	local exitButtonConnection = exitButton.MouseButton1Click:Connect(function()
		oldMouseClick:Play()
		-- Make the mainFrame not visible
		mainFrame.Visible = false
		-- Make the game button interactable again
		gameButton.Interactable = true
		gameButtonClicked.Value = false
		-- Make the start button interactable again
		startButton.Interactable = true
		-- Clear connections
		ConnectionsFunctions.clearConnections(chapterSelectConnections)
	end)
	ConnectionsFunctions.connect(chapterSelectConnections, exitButtonConnection)
	
	-- Sees if the chaptersFrame is already filled
	local clear = true
	for index, chapter in pairs(chaptersFrame:GetChildren()) do
		if chapter:IsA("Frame") then
			clear = false
			break
		end
	end
	
	-- Handles creation/getting chapters in chaptersFrame
	if clear then
		
		-- Get the made up chapters data
		local madeUpData = GetChaptersData:InvokeServer()
		
		-- Get the chapters table sorted
		local chapters = {}
		
		for chapter, chapterInformation in pairs(madeUpData) do
			table.insert(chapters, chapterInformation)
		end
		
		table.sort(chapters, function(a, b)
			return a.Order < b.Order
		end)
		
		-- Creates the new chapters
		for index, chapterInformation in ipairs(chapters) do
			
			-- Stores the chapter in the loaded chapter
			LoadedChapters[chapterInformation.Key] = chapterInformation
			
			-- Creates a new chapter frame
			local newChapter = template:Clone()
			-- Set the name of it as key data
			newChapter.Name = chapterInformation.Key
			-- Set the text of it as the name data
			newChapter.ChapterText.Text = chapterInformation.Name
			-- Set the image of the chapter
			newChapter.ChapterButton.Image = chapterInformation.ImageId
			-- Set the string key value 
			newChapter.ChapterKey.Value = chapterInformation.Key

			-- Sees if is a unlocked chapter
			if chapterInformation.Unlocked then
				-- Make the button interactable
				newChapter.ChapterButton.Interactable = true
				newChapter.ChapterButton.ZIndex = 2
				-- Make the ChapterCover and ChapterLock image not visible
				newChapter.ChapterLock.Visible = false
				newChapter.ChapterLock.ZIndex = 1
				newChapter.ChapterCover.Visible = false
				newChapter.ChapterCover.ZIndex = 1
			else
				-- Make the button not interactable
				newChapter.ChapterButton.Interactable = false
				-- Make the ChapterCover and ChapterLock image visible
				newChapter.ChapterLock.Visible = true
				newChapter.ChapterCover.Visible = true
			end

			-- Make the newChapter visible and set it's parent
			newChapter.Visible = true
			newChapter.Parent = chaptersFrame
			
			-- Handle mouse enter
			local newChapterHooverConnection1 = newChapter.ChapterButton.MouseEnter:Connect(function()
				newChapter.ChapterText.TextColor3 = Color3.fromRGB(255, 255, 0)
			end)
			ConnectionsFunctions.connect(chapterSelectConnections, newChapterHooverConnection1)
			
			-- Handle mouse leaving
			local newChapterHooverConnection2 = newChapter.ChapterButton.MouseLeave:Connect(function()
				newChapter.ChapterText.TextColor3 = Color3.fromRGB(255, 255, 255)
			end)
			ConnectionsFunctions.connect(chapterSelectConnections, newChapterHooverConnection2)
			
			-- Now, handle clicking in the chapter
			local newChapterButtonConnection = newChapter.ChapterButton.MouseButton1Click:Connect(function()
				oldMouseClick:Play()
				
				-- Handle tutorial phase 7
				if newChapter.ChapterKey.Value == "Tutorial" then
					HandleTutorial:Fire(7)
				end
				
				-- Get the respective chapter information
				local chapterInformation = LoadedChapters[newChapter.ChapterKey.Value]
				
				ChapterScreen.Start(
					player,
					chapterInformation,
					{
						mainFrame = mainFrame,
						chapterFrame = chapterFrame,
						desktopGui = desktopGui
					},
					{
						TurnOffComputer = TurnOffComputer,
						StartGameTeleport = StartGameTeleport,
						HandleTutorial = HandleTutorial,
					},
					Connections,
					Sounds
				)
			end)
			ConnectionsFunctions.connect(chapterSelectConnections, newChapterButtonConnection)
		end
		-- Set the chapterFrame size
		Functions.updateCanvas(chaptersFrame, UiGrid)
	else
		for index, chapter in pairs(chaptersFrame:GetChildren()) do
			if chapter:IsA("Frame") then
				-- Get the chapter button
				local chapterButton = chapter.ChapterButton
				local chapterText = chapter.ChapterText
				
				-- Handle mouse enter
				local chapterHooverConnection1 = chapterButton.MouseEnter:Connect(function()
					chapterText.TextColor3 = Color3.fromRGB(255, 255, 0)
				end)
				ConnectionsFunctions.connect(chapterSelectConnections, chapterHooverConnection1)
				
				-- Handle mouse leaving
				local chapterHooverConnection2 = chapterButton.MouseLeave:Connect(function()
					chapterText.TextColor3 = Color3.fromRGB(255, 255, 255)
				end)
				ConnectionsFunctions.connect(chapterSelectConnections, chapterHooverConnection2)
				
				-- Handle clicking in the chapter
				local chapterButtonConnection = chapterButton.MouseButton1Click:Connect(function()
					oldMouseClick:Play()
					
					-- Handle tutorial phase 7
					if chapter.ChapterKey.Value == "Tutorial" then
						HandleTutorial:Fire(7)
					end
					
					-- Get the respective chapter information
					local chapterInformation = LoadedChapters[chapter.ChapterKey.Value]
					
					ChapterScreen.Start(
						player,
						chapterInformation,
						{
							mainFrame = mainFrame,
							chapterFrame = chapterFrame,
							desktopGui = desktopGui,
						},
						{
							TurnOffComputer = TurnOffComputer,
							StartGameTeleport = StartGameTeleport,
							HandleTutorial = HandleTutorial,
						},
						Connections,
						Sounds
					)
				end)
				ConnectionsFunctions.connect(chapterSelectConnections, chapterButtonConnection)
			end
		end
	end
end

return ChaptersSelection
