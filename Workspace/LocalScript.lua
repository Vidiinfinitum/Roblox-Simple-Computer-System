-- Services --
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")

-- Events/Functions --
local StartDesktop = ReplicatedStorage:WaitForChild("Computer"):WaitForChild("Bindable"):WaitForChild("Event"):WaitForChild("StartDesktop")
local StartLogin = ReplicatedStorage:WaitForChild("Computer"):WaitForChild("Bindable"):WaitForChild("Event"):WaitForChild("StartLogin")
local TurnOffComputer = ReplicatedStorage:WaitForChild("Computer"):WaitForChild("Bindable"):WaitForChild("Event"):WaitForChild("TurnOffComputer")
-- Customization
local ChangeCurrentHouseMusic = ReplicatedStorage:WaitForChild("Computer"):WaitForChild("Remote"):WaitForChild("Function"):WaitForChild("Customization"):WaitForChild("ChangeCurrentHouseMusic")
local ChangeCurrentUserIcon = ReplicatedStorage:WaitForChild("Computer"):WaitForChild("Remote"):WaitForChild("Function"):WaitForChild("Customization"):WaitForChild("ChangeCurrentUserIcon")
local ChangeCurrentWallpaper = ReplicatedStorage:WaitForChild("Computer"):WaitForChild("Remote"):WaitForChild("Function"):WaitForChild("Customization"):WaitForChild("ChangeCurrentWallpaper")
local GetCurrentHouseMusic = ReplicatedStorage:WaitForChild("Computer"):WaitForChild("Remote"):WaitForChild("Function"):WaitForChild("Customization"):WaitForChild("GetCurrentHouseMusic")
local GetCurrentUserIcon = ReplicatedStorage:WaitForChild("Computer"):WaitForChild("Remote"):WaitForChild("Function"):WaitForChild("Customization"):WaitForChild("GetCurrentUserIcon")
local GetCurrentWallpaper = ReplicatedStorage:WaitForChild("Computer"):WaitForChild("Remote"):WaitForChild("Function"):WaitForChild("Customization"):WaitForChild("GetCurrentWallpaper")
local GetAll = ReplicatedStorage:WaitForChild("Computer"):WaitForChild("Remote"):WaitForChild("Function"):WaitForChild("Customization"):WaitForChild("GetAll")
-- Game
local GetChaptersData = ReplicatedStorage:WaitForChild("Computer"):WaitForChild("Remote"):WaitForChild("Function"):WaitForChild("Game"):WaitForChild("GetChaptersData")
local StartGameTeleport = ReplicatedStorage:WaitForChild("Computer"):WaitForChild("Remote"):WaitForChild("Event"):WaitForChild("StartGameTeleport")
-- Tutorial
local HandleTutorial = ReplicatedStorage:WaitForChild("Tutorial"):WaitForChild("Bindable"):WaitForChild("HandleTutorial")

-- Sounds --
local windowsXpLogoff = SoundService:WaitForChild("Computer"):WaitForChild("WindowsXpLogoff")
local windowsXpShutdown = SoundService:WaitForChild("Computer"):WaitForChild("WindowsXpShutdown")
local oldMouseClick = SoundService:WaitForChild("Computer"):WaitForChild("OldMouseClick")
local loadingConfirmation = SoundService:WaitForChild("Others"):WaitForChild("LoadingConfirmation")

-- Modules --
local StartController = require(ReplicatedStorage:WaitForChild("Computer"):WaitForChild("Modules"):WaitForChild("Workspace"):WaitForChild("ComputerStartButton"):WaitForChild("StartController"))
local GameController = require(ReplicatedStorage:WaitForChild("Computer"):WaitForChild("Modules"):WaitForChild("Workspace"):WaitForChild("Game"):WaitForChild("GameController"))
local Clock = require(ReplicatedStorage:WaitForChild("Computer"):WaitForChild("Modules"):WaitForChild("Workspace"):WaitForChild("Clock"))

-- Start button Connections --
local optionsConnections = {}
local userIconsConnections = {}
local wallpapersConnections = {}
local musicsConnections = {}

-- Game button Connections --
local chapterSelectConnections = {}
local chapterScreenConnections = {}

-- Computer States --
local States ={
	turningOff = false,
	loggingOff = false
}

-- Main Script --

StartDesktop.Event:Connect(function()
	-- Get player and player gui
	local player = Players.LocalPlayer
	local playerGui = player.PlayerGui
	
	-- Get the desktop gui
	local desktopGui = ReplicatedStorage:WaitForChild("Computer"):WaitForChild("DesktopGui"):Clone()
	
	-- Show the desktop gui
	desktopGui.Parent = playerGui
	
	-- Get background
	local background = desktopGui:WaitForChild("Background")

	-- Get downBorder objects --
	local downBorder = background:WaitForChild("DownBorder")

	-- Get downBorder objects
	local startButton = downBorder:WaitForChild("StartFrame"):WaitForChild("StartButton")
	local startButtonClicked = startButton:WaitForChild("Clicked")
	local clock = downBorder:WaitForChild("Clock")
	
	-- Get game instances
	local gameButton = background:WaitForChild("Game"):WaitForChild("GameButton")
	local loadingFrame = background:WaitForChild("Game"):WaitForChild("LoadingFrame")
	local mainFrame = background:WaitForChild("Game"):WaitForChild("MainFrame")
	local chapterFrame = background:WaitForChild("Game"):WaitForChild("ChapterFrame")
	
	-- Start the real script --
	
	-- Start the clock
	Clock.Start(clock)
			
	-- To handle the start button
	StartController.Start(
		player,
		{
			gameButton = gameButton
		},
		background.Options,
		{
			GetCurrentUserIcon = GetCurrentUserIcon,
			ChangeCurrentUserIcon = ChangeCurrentUserIcon,
			GetCurrentHouseMusic = GetCurrentHouseMusic,
			ChangeCurrentHouseMusic = ChangeCurrentHouseMusic,
			GetCurrentWallpaper = GetCurrentWallpaper,
			ChangeCurrentWallpaper = ChangeCurrentWallpaper,
			GetAll = GetAll,
			StartLogin = StartLogin,
			TurnOffComputer = TurnOffComputer,
		},
		{
			optionsConnections = optionsConnections,
			userIconsConnections = userIconsConnections,
			wallpapersConnections = wallpapersConnections,
			musicsConnections = musicsConnections,
			chapterSelectConnections = chapterSelectConnections,
			chapterScreenConnections = chapterScreenConnections,
		},
		{
			desktopGui = desktopGui,
			background = background,
			startButton = startButton,
			startButtonClicked = startButtonClicked,
			oldMouseClick = oldMouseClick,
			windowsXpLogoff =  windowsXpLogoff,
			windowsXpShutdown = windowsXpShutdown,
		},
		States
	)
	
	-- To handle the game button
	GameController.Start(
		player,
		{
			startButton = startButton
		},
		States,
		{
			GetChaptersData = GetChaptersData,
			TurnOffComputer = TurnOffComputer,
			StartGameTeleport = StartGameTeleport,
			HandleTutorial = HandleTutorial,
		},
		{
			loadingFrame = loadingFrame,
			gameButton = gameButton,
			mainFrame = mainFrame,
			chapterFrame = chapterFrame,
			desktopGui = desktopGui
		},
		{
			optionsConnections = optionsConnections,
			userIconsConnections = userIconsConnections,
			wallpapersConnections = wallpapersConnections,
			musicsConnections = musicsConnections,
			chapterSelectConnections = chapterSelectConnections,
			chapterScreenConnections = chapterScreenConnections,
		},
		{
			oldMouseClick = oldMouseClick,
			windowsXpShutdown = windowsXpShutdown,
			loadingConfirmation = loadingConfirmation,
		}
	)
	
end)
