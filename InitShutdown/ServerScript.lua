-- Services --
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Events/Functions --
local StartComputer = ReplicatedStorage:WaitForChild("Computer"):WaitForChild("Remote"):WaitForChild("Event"):WaitForChild("StartComputer")
local ShutdownComputer = ReplicatedStorage:WaitForChild("Computer"):WaitForChild("Remote"):WaitForChild("Event"):WaitForChild("ShutdownComputer")

-- Functions --
local function getUpPlayer(seat:Seat, humanoid:Humanoid, duration:number, teleport_part:Part)
	if humanoid and humanoid.Sit then
		local character = humanoid.Parent
		local position = teleport_part.CFrame + Vector3.new(0,1,0)
		
		humanoid.Sit = false
		seat.Disabled = true
		task.wait(0.05)
		character:PivotTo(position)
		task.wait(duration)
		seat.Disabled = false
	end
end

-- Main Script --

-- Get the seat where the player sits to start the computer
local seat = Workspace:WaitForChild("Map"):WaitForChild("House"):WaitForChild("HouseInDoor"):WaitForChild("WoodChair"):WaitForChild("Seat")

-- Get the part where the player will teleport when get up
local teleport_part = Workspace:WaitForChild("Map"):WaitForChild("ComputerTP")

-- Detect if the player seated in the chair
seat:GetPropertyChangedSignal("Occupant"):Connect(function()
	local humanoid = seat.Occupant
	
	if not humanoid then
		return
	end
	
	local player = Players:GetPlayerFromCharacter(humanoid.Parent)
	
	if not player then
		return
	end
	
	-- Send signal to client to start the computer
	StartComputer:FireClient(player)
end)

-- Event when player turn off the computer
ShutdownComputer.OnServerEvent:Connect(function(player:Player)
	local character = player.Character
	local humanoid = character:WaitForChild("Humanoid")
	
	getUpPlayer(seat, humanoid, 5, teleport_part)
	
end)
