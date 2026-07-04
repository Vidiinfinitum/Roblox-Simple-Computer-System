-- Services --

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local UserInputService = game:GetService("UserInputService")

-- Events/Functions --

local StartLogin = ReplicatedStorage:WaitForChild("Computer"):WaitForChild("Bindable"):WaitForChild("Event"):WaitForChild("StartLogin")
local StartDesktop = ReplicatedStorage:WaitForChild("Computer"):WaitForChild("Bindable"):WaitForChild("Event"):WaitForChild("StartDesktop")
local TurnOffComputer = ReplicatedStorage:WaitForChild("Computer"):WaitForChild("Bindable"):WaitForChild("Event"):WaitForChild("TurnOffComputer")
local GetCurrentUserIcon = ReplicatedStorage:WaitForChild("Computer"):WaitForChild("Remote"):WaitForChild("Function"):WaitForChild("Customization"):WaitForChild("GetCurrentUserIcon")
local HandleTutorial = ReplicatedStorage:WaitForChild("Tutorial"):WaitForChild("Bindable"):WaitForChild("HandleTutorial")

-- Sounds --

local windowsXpLogon = SoundService:WaitForChild("Computer"):WaitForChild("WindowsXpLogon")
local windowsXpStart = SoundService:WaitForChild("Computer"):WaitForChild("WindowsXpStart")
local windowxXpShutdown = SoundService:WaitForChild("Computer"):WaitForChild("WindowsXpShutdown")
local oldMouseClick = SoundService:WaitForChild("Computer"):WaitForChild("OldMouseClick")
local oldComputerKeyboard = SoundService:WaitForChild("Computer"):WaitForChild("OldComputerKeyboard")

-- Functions --

local function showObject(object, show:boolean)
	if object and not object:isA("UICorner") then
		if show then
			object.Visible = true
		else
			object.Visible = false
		end
	end
end

local function showUserSelection(object:Frame, show:boolean)
	if object then
		if show then
			object.BackgroundTransparency = 0
		else
			object.BackgroundTransparency = 1
		end
	end
end

local function writePassword(object:TextLabel, type_duration:number, text:string)
	object.Text = text
	object.MaxVisibleGraphemes = 0
	
	local active = true
	
	-- To handle the typing sound
	task.spawn(function()
		while active do
			oldComputerKeyboard:Play()
			task.wait(0.3)
		end
	end)
	
	-- To create the animation of typing
	for i = 1, utf8.len(text) do
		object.MaxVisibleGraphemes = i
		task.wait(type_duration)
	end
	
	active = false
end

local function loadingAnimation(object:TextLabel, duration:number, times:IntValue, sound:Sound)
	sound:Play()
	
	object.Text = "Loading..."
	object.MaxVisibleGraphemes = 7
	
	-- Main animation
	for i = 1, times do
		object.MaxVisibleGraphemes = 8
		task.wait(duration)
		object.MaxVisibleGraphemes = 9
		task.wait(duration)
		object.MaxVisibleGraphemes = 10
		task.wait(duration)
	end
	
end

-- Main Script --

local player = Players.LocalPlayer
local playerGui = player.PlayerGui

StartLogin.Event:Connect(function()
	-- Get and clone users gui
	local usersGui = ReplicatedStorage:WaitForChild("Computer"):WaitForChild("UsersGui"):Clone()
	
	-- Get userfull buttons
	local turnOffButton = usersGui:WaitForChild("Background"):WaitForChild("Select"):WaitForChild("TurnOffButton")
	local playerSelectButton = usersGui:WaitForChild("Background"):WaitForChild("Select"):WaitForChild("PlayerUser"):WaitForChild("Button")
	
	-- Set playerSelectButton image
	local imageId = GetCurrentUserIcon:InvokeServer("Id")
	playerSelectButton.Image = imageId
	
	-- Get user selection frame
	local userSelectionFrame = usersGui:WaitForChild("Background"):WaitForChild("Select"):WaitForChild("PlayerSelect")
	
	-- Get login texts labels
	local order = usersGui:WaitForChild("Background"):WaitForChild("Login"):WaitForChild("Player"):WaitForChild("Order")
	local passwordText = usersGui:WaitForChild("Background"):WaitForChild("Login"):WaitForChild("Player"):WaitForChild("PasswordText")
	
	-- Get select texts labels
	local playerNameLabel = usersGui:WaitForChild("Background"):WaitForChild("Select"):WaitForChild("PlayerUser"):WaitForChild("Name")
	
	-- Get the enter image
	local enterImage = usersGui:WaitForChild("Background"):WaitForChild("Login"):WaitForChild("Player"):WaitForChild("EnterImage")
	
	-- Set login image
	local loginImage = usersGui:WaitForChild("Background"):WaitForChild("Login"):WaitForChild("Player"):WaitForChild("Image")
	loginImage.Image = imageId
	
	usersGui.Parent = playerGui
	
	-- Set playerNameLabel with player's name
	playerNameLabel.Text = player.Name
	
	-- To not bug
	local turningOff = false
	
	-- To handle when player clicks to turn off the commputer
	turnOffButton.MouseButton1Click:Connect(function()
		turningOff = true
		oldMouseClick:Play()
		windowxXpShutdown:Play()
		TurnOffComputer:Fire()
		usersGui:Destroy()
	end)
	
	-- Two events to handle roover animation
	playerSelectButton.MouseEnter:Connect(function()
		showUserSelection(userSelectionFrame, true)
	end)
	
	playerSelectButton.MouseLeave:Connect(function()
		showUserSelection(userSelectionFrame, false)
	end)
	
	-- When player clicks in the user icon
	playerSelectButton.MouseButton1Click:Connect(function()
		
		if turningOff then
			return
		end
		
		oldMouseClick:Play()
		
		-- Turn not visible the objects in select folder
		local select_folder = usersGui:WaitForChild("Background"):WaitForChild("Select")
		for index, object in pairs(select_folder:GetChildren()) do
			showObject(object, false)
		end
		
		-- Turn visible the objects in login folder
		local login_folder = usersGui:WaitForChild("Background"):WaitForChild("Login"):WaitForChild("Player")
		login_folder.Visible = true
		for index, object in pairs(login_folder:GetChildren()) do
			showObject(object, true)
		end
		
		-- To player be able to see the new interface
		task.wait(1)
		
		-- Write the password 
		writePassword(passwordText, 0.1, "********")
		
		-- Wait some time
		task.wait(1)
		
		-- Make them disapear
		passwordText.Visible = false
		enterImage.Visible = false
		
		-- Start loading animation
		loadingAnimation(order, 0.33, 2, windowsXpLogon)
		
		-- Handle tutorial phase 5
		HandleTutorial:Fire(5)
		
		usersGui:Destroy()
		
		StartDesktop:Fire()
		
		windowsXpStart:Play()
	end)
	
end)
