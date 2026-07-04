-- Services --
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptServivce = game:GetService("ServerScriptService")

-- Modules --
local DataManager = require(ServerScriptServivce:WaitForChild("Data"):WaitForChild("DataManager"))
local ComputerCustomizationData = require(ServerScriptServivce:WaitForChild("Libraries"):WaitForChild("ComputerCustomizationData"))

-- Events/Functions --
local GetCurrentUserIcon = ReplicatedStorage:WaitForChild("Computer"):WaitForChild("Remote"):WaitForChild("Function"):WaitForChild("Customization"):WaitForChild("GetCurrentUserIcon")

-- Main Script --

local UserIcons = ComputerCustomizationData.UserIcons

-- Function to send the current user icon
GetCurrentUserIcon.OnServerInvoke = function(player:Player, whatGet:string)
	if player then
		local profile = DataManager.Profiles[player]
		if profile then
			local currentUserIcon = profile.Data.ComputerCustomizationData.CurrentUserIcon
			if whatGet == "Name" then
				return UserIcons[currentUserIcon].Name
			else
				return UserIcons[currentUserIcon].Id				
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
