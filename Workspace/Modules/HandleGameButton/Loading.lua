local Functions = require(game.ReplicatedStorage.Computer.Modules.Workspace.Game.Functions)

local Loading = {}

function Loading.StartLoading(loadingFrame:Frame, Sounds)
	
	-- Get sounds
	local loadingConfirmation:Sound = Sounds.loadingConfirmation
	loadingConfirmation.Volume = 0.1
	
	-- Get the functions
	local loadingBarAnimation = Functions.loadingBarAnimation
	local loadingTextAnimation = Functions.loadingTextAnimation
	
	-- Get the loading bar 
	local loadingBar = loadingFrame.LoadingBar
	local bar = loadingBar.Bar
	
	-- Get loading text
	local loadingText = loadingFrame.LoadingText
	
	-- Main Script --
	
	-- Show the loadingFrame
	loadingFrame.Visible = true
	
	-- Start the animations
	loadingTextAnimation(loadingText, 0.5, 20)
	local loading = loadingBarAnimation(bar)
	
	-- Waits the loading ends
	loading.Completed:Wait()
	loadingConfirmation:Play()
	
	-- Turn invisible the loading frame
	loadingFrame.Visible = false
end

return Loading
