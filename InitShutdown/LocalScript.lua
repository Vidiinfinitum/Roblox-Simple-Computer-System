-- Services --
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Events/Functions -- 
local StartComputer = ReplicatedStorage:WaitForChild("Computer"):WaitForChild("Remote"):WaitForChild("Event"):WaitForChild("StartComputer")
local ShutdownComputer = ReplicatedStorage:WaitForChild("Computer"):WaitForChild("Remote"):WaitForChild("Event"):WaitForChild("ShutdownComputer")
local StartLogin = ReplicatedStorage:WaitForChild("Computer"):WaitForChild("Bindable"):WaitForChild("Event"):WaitForChild("StartLogin")
local TurnOffComputer = ReplicatedStorage:WaitForChild("Computer"):WaitForChild("Bindable"):WaitForChild("Event"):WaitForChild("TurnOffComputer")
local CanDoWalkingSounds = ReplicatedStorage:WaitForChild("Loading/Menu"):WaitForChild("Bindable"):WaitForChild("Event"):WaitForChild("CanDoWalkingSounds")
local HandleTutorial = ReplicatedStorage:WaitForChild("Tutorial"):WaitForChild("Bindable"):WaitForChild("HandleTutorial")
-- Sounds --
local currentHouseMusic = SoundService:WaitForChild("CurrentHouseMusic")

-- Functions --

local function setCamera(camera:Part)
	local currentCamera = Workspace.CurrentCamera
	currentCamera.CameraType = Enum.CameraType.Scriptable
	currentCamera.CFrame = camera.CFrame
end

local function resetCamera()
	local currentCamera = Workspace.CurrentCamera
	local player = Players.LocalPlayer
	currentCamera.CameraType = Enum.CameraType.Custom
	currentCamera.CameraSubject = player.Character:WaitForChild("Humanoid")
	currentCamera.CFrame = currentCamera.CFrame * CFrame.Angles(0, math.rad(90), 0)
end

local function computerCameraTween(desk_camera:Part, computer_camera:Part, duration:number, in_out:BoolValue, currentCamera:Camera)
	local firstPosition = desk_camera.CFrame
	local finalPosition = computer_camera.CFrame
	
	if in_out then
		TweenService:Create(currentCamera, TweenInfo.new(duration), {CFrame = finalPosition}):Play()
		task.wait(duration)
	else
		TweenService:Create(currentCamera, TweenInfo.new(duration), {CFrame = firstPosition}):Play()
		task.wait(duration)
	end
end

local function computerScreenTween(screen:Part, duration:number, activate:boolean)
	if activate then
		TweenService:Create(screen, TweenInfo.new(duration), {Color = Color3.fromRGB(255, 255, 255)}):Play()
		task.wait(duration)
	else
		TweenService:Create(screen, TweenInfo.new(duration), {Color = Color3.fromRGB(17, 17, 17)}):Play()
		task.wait(duration)
	end
end

local function computerCabinetLedTween(led:Part, duration:number, activate:boolean)
	if activate then
		TweenService:Create(led, TweenInfo.new(duration), {Color = Color3.fromRGB(0, 255, 0)}):Play()
		task.wait(duration)
	else
		TweenService:Create(led, TweenInfo.new(duration), {Color = Color3.fromRGB(255, 0, 0)}):Play()
		task.wait(duration)
	end
end

local function setMusicEffect(sound:Sound, activate:BoolValue, duration:number)
	
	if activate then
		-- Creates or get the equalizer effect
		local equalizer
		if sound:FindFirstChild("EqualizerSoundEffect") then
			equalizer = sound:FindFirstChild("EqualizerSoundEffect")
		else
			equalizer = Instance.new("EqualizerSoundEffect")
			equalizer.LowGain = 0
			equalizer.MidGain = 0
			equalizer.Parent = sound
		end
		
		-- Start the tween
		TweenService:Create(equalizer, TweenInfo.new(duration), {HighGain = -25, MidGain = -10}):Play()
	else
		-- Get the equalizer
		local equalizer = sound:WaitForChild("EqualizerSoundEffect")
		
		-- Start the tween
		TweenService:Create(equalizer, TweenInfo.new(duration), {HighGain = 0, MidGain = 0}):Play()
	end
	
end

-- Main Script --

-- Get player
local player = Players.LocalPlayer

-- Get cameras
local deskCamera = Workspace:WaitForChild("Map"):WaitForChild("Cameras"):WaitForChild("DeskCamera")
local computerCamera = Workspace:WaitForChild("Map"):WaitForChild("Cameras"):WaitForChild("ComputerCamera")
local currentCamera = Workspace.CurrentCamera

-- Get computer monitor screen
local computerScreen = Workspace:WaitForChild("Map"):WaitForChild("House"):WaitForChild("HouseInDoor"):WaitForChild("Computer"):WaitForChild("Monitor"):WaitForChild("Screen")

-- Get cabinet led
local cabinetLed = Workspace:WaitForChild("Map"):WaitForChild("House"):WaitForChild("HouseInDoor"):WaitForChild("Computer"):WaitForChild("Cabinet"):WaitForChild("Led")

-- Get signal if can start the computer script
StartComputer.OnClientEvent:Connect(function()
	
	-- Handle the phase 4 of tutorial
	HandleTutorial:Fire(4)
	
	-- To remove walking sound
	CanDoWalkingSounds:Fire(false)
	
	-- Set the desktop camera
	setCamera(deskCamera)
	
	-- Set sound effect
	setMusicEffect(currentHouseMusic, true, 2)
	
	-- Waits some seconds 
	task.wait(0.5)
	
	-- Starts the camera, screen and led tween
	task.spawn(function()
		computerCameraTween(deskCamera, computerCamera, 2, true, currentCamera)
	end)
	
	task.spawn(function()
		computerScreenTween(computerScreen, 2, true)
	end)
	
	computerCabinetLedTween(cabinetLed, 2, true)
	
	-- Starts the user login gui
	StartLogin:Fire()
	
	-- To be able to use the mouse icon
	UserInputService.MouseIconEnabled = true
	
end)

-- Fires when the computer is turned off from LoginScript or DesktopScript
TurnOffComputer.Event:Connect(function()
	
	-- To not be able to see the mouse icon
	UserInputService.MouseIconEnabled = false
	
	-- Freezes the player
	local humanoid = player.Character:WaitForChild("Humanoid")
	humanoid.WalkSpeed = 0
	
	-- Fires to the server to make the player get up from the chair
	ShutdownComputer:FireServer()
	
	-- Do the turn off tween
	task.spawn(function()
		computerCameraTween(deskCamera, computerCamera, 2, false, currentCamera)
	end)
	
	task.spawn(function()
		computerScreenTween(computerScreen, 2, false)
	end)
	
	computerCabinetLedTween(cabinetLed, 2, false)
	
	-- Reset the player camera
	resetCamera()
	
	-- Unfreeze the player
	humanoid.WalkSpeed = 6
	
	-- To put walking sound
	CanDoWalkingSounds:Fire(true)
	
	setMusicEffect(currentHouseMusic, false, 2)
	
end)

