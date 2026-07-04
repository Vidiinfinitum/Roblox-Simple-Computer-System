local UIFunctions = {}
	
function UIFunctions.startSelection(frame:Frame, bool:boolean)
	if frame then
		if bool then
			frame.BackgroundTransparency = 0
		else
			frame.BackgroundTransparency = 1
		end
	end
end
	
function UIFunctions.refreshOptions(frame:ScrollingFrame)
	for index, object in pairs(frame:GetChildren()) do
		if object:IsA("Frame") then
			local selectionFrame = object:WaitForChild("SelectionFrame")
			local selected = selectionFrame.Selected
			local button = object:WaitForChild("Button")

			selected.Value = false
			selectionFrame.BackgroundTransparency = 1
			button.Interactable = true
		end
	end
end

function UIFunctions.updateCanvas(scrollingFrame:ScrollingFrame)

	local layout = scrollingFrame:FindFirstChildOfClass("UIListLayout")

	if layout then
		task.defer(function()
			scrollingFrame.CanvasSize = UDim2.new(
				0,
				0,
				0,
				layout.AbsoluteContentSize.Y + 20
			)
		end)
	end
end
	
return UIFunctions
