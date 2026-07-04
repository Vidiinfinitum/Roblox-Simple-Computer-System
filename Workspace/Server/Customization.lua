-- Services --
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

-- Modules --
local DataManager = require(ServerScriptService:WaitForChild("Data"):WaitForChild("DataManager"))
local ComputerCustomizationData = require(ServerScriptService:WaitForChild("Libraries"):WaitForChild("ComputerCustomizationData"))

-- Events/Functions --
local ChangeCurrentHouseMusic = ReplicatedStorage:WaitForChild("Computer"):WaitForChild("Remote"):WaitForChild("Function"):WaitForChild("Customization"):WaitForChild("ChangeCurrentHouseMusic")
local ChangeCurrentUserIcon = ReplicatedStorage:WaitForChild("Computer"):WaitForChild("Remote"):WaitForChild("Function"):WaitForChild("Customization"):WaitForChild("ChangeCurrentUserIcon")
local ChangeCurrentWallpaper = ReplicatedStorage:WaitForChild("Computer"):WaitForChild("Remote"):WaitForChild("Function"):WaitForChild("Customization"):WaitForChild("ChangeCurrentWallpaper")
local GetCurrentWallpaper = ReplicatedStorage:WaitForChild("Computer"):WaitForChild("Remote"):WaitForChild("Function"):WaitForChild("Customization"):WaitForChild("GetCurrentWallpaper")
local GetCurrentHouseMusic = ReplicatedStorage:WaitForChild("Computer"):WaitForChild("Remote"):WaitForChild("Function"):WaitForChild("Customization"):WaitForChild("GetCurrentHouseMusic")
local GetAll = ReplicatedStorage:WaitForChild("Computer"):WaitForChild("Remote"):WaitForChild("Function"):WaitForChild("Customization"):WaitForChild("GetAll")

-- Main Script --

-- Get the wallpaper data table
local Wallpapers = ComputerCustomizationData.Wallpapers

-- Get the user icons data table
local UserIcons = ComputerCustomizationData.UserIcons

-- Get the musics data table
local Musics = ComputerCustomizationData.Musics

-- To change current house music
ChangeCurrentHouseMusic.OnServerInvoke = function(player:Player, newMusic:string)
	if player then
		local profile = DataManager.Profiles[player]
		if profile then
			for index, music in pairs(Musics) do
				if music.Name == newMusic then
					DataManager.updateCurrentHouseMusic(player, music.Key)
				end
			end
		else
			warn("Profile not found")
			return false
		end
	else
		warn("Player not found")
		return false
	end
end

-- To change current user icon
ChangeCurrentUserIcon.OnServerInvoke = function(player:Player, newUserIcon:string)
	if player then
		local profile = DataManager.Profiles[player]
		if profile then
			for index, icon in pairs(UserIcons) do
				if icon.Name == newUserIcon then
					DataManager.updateCurrentUserIcon(player, icon.Key)
				end
			end	
		else
			warn("Profile not found")
			return false
		end
	else
		warn("Player not found")
		return false
	end
end

-- To change current wallpaper
ChangeCurrentWallpaper.OnServerInvoke = function(player:Player, newWallpaper:string)
	if player then
		local profile = DataManager.Profiles[player]
		if profile then
			for index, wallpaper in pairs(Wallpapers) do
				if wallpaper.Name == newWallpaper then
					DataManager.updateCurrentWallpaper(player, wallpaper.Key)
				end
			end
		else
			warn("Profile not found")
			return false
		end
	else
		warn("Player not found")
		return false
	end
end

-- To get current wallpaper
GetCurrentWallpaper.OnServerInvoke = function(player:Player, whatGet:string)
	if player then
		local profile = DataManager.Profiles[player]
		if profile then
			local currentWallpaper = profile.Data.ComputerCustomizationData.CurrentWallpaper
			if whatGet == "Name" then
				return Wallpapers[currentWallpaper].Name
			else
				return Wallpapers[currentWallpaper].Id				
			end
		else
			warn("Profile not found")
			return nil
		end 
	else
		warn("Player not found!")
		return nil
	end
end

-- To get current house music
GetCurrentHouseMusic.OnServerInvoke = function(player:Player, whatGet:string)
	if player then
		local profile = DataManager.Profiles[player]
		if profile then
			local currentHouseMusic = profile.Data.ComputerCustomizationData.CurrentHouseMusic
			if whatGet == "Name" then
				return Musics[currentHouseMusic].Name
			else
				return Musics[currentHouseMusic].Id				
			end
		else
			warn("Profile not found")
			return nil
		end 
	else
		warn("Player not found!")
		return nil
	end
end

-- To get the respective table
GetAll.OnServerInvoke = function(player:Player, whatGet:string)
	if player then
		local profile = DataManager.Profiles[player]
		if profile then
			if whatGet == "Musics" then
				return Musics
			elseif whatGet == "Wallpapers" then
				return Wallpapers
			elseif whatGet == "UserIcons" then
				return UserIcons
			else
				warn("Invalid table")
				return nil
			end
		else
			warn("Profile not found!")
			return nil
		end
	else
		warn("Player not found!")
		return nil
	end
end

-- The "get current user icon" is in LoginScript



