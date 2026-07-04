-- Services --
local TweenService = game:GetService("TweenService")

local Functions = {}

function Functions.loadingBarAnimation(bar:Frame)
	-- Make sure that the bar is in (0,0,1,0)
	bar.Size = UDim2.new(0,0,1,0)
	
	-- Get the random instance
	local random = Random.new()
	
	-- Get the final size
	local finalSize = UDim2.new(1,0,1,0)
	
	-- Get the duration
	local duration = random:NextNumber(3, 5)
	
	-- Set the tween
	local loadingBarTween = TweenService:Create(bar, TweenInfo.new(duration, Enum.EasingStyle.Linear), {Size = finalSize})
	
	-- Plays the tween
	loadingBarTween:Play()
	
	-- Get the effect of loading delay
	task.spawn(function()
		while loadingBarTween.PlaybackState == Enum.PlaybackState.Playing do
			
			-- Time until the next freeze
			task.wait(random:NextNumber(1.5, 2))
			
			-- Freezes the tween
			if loadingBarTween.PlaybackState == Enum.PlaybackState.Playing then
				loadingBarTween:Pause()
				
				-- Time freezed
				task.wait(random:NextNumber(0.5, 1))
				
				-- unfreeze
				loadingBarTween:Play()
			end
			
		end
	end)
	
	return loadingBarTween
end

function Functions.loadingTextAnimation(loadingText:TextLabel, duration:number, times:IntValue)
	-- Set the text
	loadingText.Text = "Loading..."
	loadingText.MaxVisibleGraphemes = 7
	
	-- Main animation
	task.spawn(function()
		for i = 1, times do
			loadingText.MaxVisibleGraphemes = 8
			task.wait(duration)
			loadingText.MaxVisibleGraphemes = 9
			task.wait(duration)
			loadingText.MaxVisibleGraphemes = 10
			task.wait(duration)
		end
	end)
	
end

function Functions.getTableSize(tbl)
	local size = 0
	
	for index, object in pairs(tbl) do
		size += 1
	end
	
	return size
end

function Functions.getMemoriesGot(memoriesTable)
	
	local total = 0
	
	for index, memorie in pairs(memoriesTable) do
		if memorie then
			total += 1
		end
	end
	
	return total
end

function Functions.updateCanvas(scrollingFrame:ScrollingFrame, UiGrid:UIGridLayout)
	scrollingFrame.CanvasSize = UDim2.new(
		0,
		0,
		0,
		UiGrid.AbsoluteContentSize.Y
	)
end

return Functions
