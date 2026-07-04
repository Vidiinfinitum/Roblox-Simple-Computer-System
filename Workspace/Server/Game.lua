-- Services --
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")

-- Events/Functions --
local GetChaptersData = ReplicatedStorage:WaitForChild("Computer"):WaitForChild("Remote"):WaitForChild("Function"):WaitForChild("Game"):WaitForChild("GetChaptersData")
local StartGameTeleport = ReplicatedStorage:WaitForChild("Computer"):WaitForChild("Remote"):WaitForChild("Event"):WaitForChild("StartGameTeleport")

-- Modules --
local DataManager = require(ServerScriptService:WaitForChild("Data"):WaitForChild("DataManager"))
local ChaptersData = require(ServerScriptService:WaitForChild("Libraries"):WaitForChild("ChaptersData"))

-- Functions --
local function openDoor(door:Part, duration:number, open:boolean, sound:Sound, destination:CFrame)
	if open then
		local openTween = TweenService:Create(door, TweenInfo.new(duration), {CFrame = destination})
		openTween:Play()
		sound:Play()
		openTween.Completed:Wait()
	else
		local closeTween = TweenService:Create(door, TweenInfo.new(duration), {CFrame = destination})
		closeTween:Play()
		sound:Play()
		closeTween.Completed:Wait()
	end
end

-- Main Script --

-- Responsible to send the player data --
GetChaptersData.OnServerInvoke = function(player:Player)
	-- Sanity check
	if not player then
		warn("Player not found!")
		return
	end
	
	-- Get the players profile
	local profile = DataManager.Profiles[player]
	-- Sees if the player profile exists
	if not profile then
		warn("Player profile not found!")
		return
	end
	-- Get the chapter progress and stores it
	local progressData = profile.Data.ChapterProgress
	
	-- Sees if the stored data exists
	if not progressData then
		warn("storedData not found!")
		return
	end
	
	-- Creates the data to return in the end
	local dataToSend = {}
	-- Fill the data to send
	for chapterKey, chapterInformation in pairs(ChaptersData) do
		dataToSend[chapterKey] = {
			Order = chapterInformation.Order,
			Key = chapterInformation.Key,
			Name = chapterInformation.Name,
			Title = chapterInformation.Title,
			ImageId = chapterInformation.ImageId,
			PlaceId = chapterInformation.PlaceId,
			Unlocked = progressData[chapterKey] and progressData[chapterKey].Unlocked or false,
			Memories = progressData[chapterKey] and progressData[chapterKey].Memories or {},
			Completed = progressData[chapterKey] and progressData[chapterKey].Completed or false
		}
	end 
	
	return dataToSend
end

-- Responsible to the teleport system --

-- Get the game door
local gameDoor = Workspace.Map.House.House.GameDoor
-- Get the open bool value
local open = gameDoor.Open
-- Get the first position
local firstPosition = gameDoor.CFrame
-- Get the final position
local finalPosition = gameDoor.FinalPosition.CFrame
-- Get the game door audio
local gameDoorAudio = gameDoor.GameDoorAudio

-- Get the teleport trigger
local trigger:Part = Workspace.Map.House.House.Base.DarkRoom.Trigger
-- Get the trigger touch bool value
local touch = trigger.Touch

-- Get the portal sound
local portalSound:Sound = trigger.PortalSound

-- Creates a connections table
local Connections = {}

local chapterActive = nil

-- Main --
StartGameTeleport.OnServerEvent:Connect(function(player:Player, chapterKey:string)
	
	-- Get the player profile
	local profile = DataManager.Profiles[player]
	if not profile then
		warn("Profile not found!")
		return
	end
	
	-- Get the chapter information
	local chapterInformation = ChaptersData[chapterKey]
	if not chapterInformation then
		warn("Chapter information not found!")
		return
	end
	
	-- Sees if the chapters is unlocked in the player data
	if not profile.Data.ChapterProgress[chapterKey].Unlocked then
		warn("This chapter is not unlocked!")
		return
	end
	
	-- Checks double cliking the same chapter
	if chapterKey == chapterActive then
		return
	end
	
	chapterActive = chapterKey
	
	-- Clear all previous connections
	for index, connection in pairs(Connections) do
		connection:Disconnect()
	end
	
	table.clear(Connections)
	
	local placeId = chapterInformation.PlaceId
	
	-- If the door is open, close it
	if open.Value then
		openDoor(gameDoor, 1, false, gameDoorAudio, firstPosition)
		if portalSound.IsPlaying then
			portalSound:Stop()
		end
	end 
	
	task.wait(2)
	
	-- Opens the door
	openDoor(gameDoor, 3, true, gameDoorAudio, finalPosition)
	portalSound:Play()
	
	-- Start a new connection with touch event to send the player to map when touch
	local triggerConnection = trigger.Touched:Connect(function(otherPart)
		if not touch.Value then
			local character = otherPart.Parent
			local player = Players:GetPlayerFromCharacter(character)
			local humanoid = character:WaitForChild("Humanoid")

			-- Sees if the touch was made by a player
			if player then
				touch.Value = true
				
				-- Freezes the player
				humanoid.WalkSpeed = 0
				
				-- Close the door
				task.spawn(function()
					openDoor(gameDoor, 1, false, gameDoorAudio, firstPosition)
				end)
				
				local success, err = pcall(function()
					TeleportService:TeleportAsync(placeId, {player})
				end)
				
				if not success then
					warn(err)
				end
			end
		end

	end)
	-- Put the triggerConnection in the Connections table
	table.insert(Connections, triggerConnection)
end)




