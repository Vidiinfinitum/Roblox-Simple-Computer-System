local UserIcons = {}

function UserIcons.StartFrame(userIconOptions:ScrollingFrame, userTemplate:Frame, userIconsConnections, userButton:ImageButton, oldMouseClick:Sound, Functions, Remotes)
	
	-- Get the Events
	local GetCurrentUserIcon = Remotes.GetCurrentUserIcon
	local ChangeCurrentUserIcon = Remotes.ChangeCurrentUserIcon
	local GetAll = Remotes.GetAll
	
	
	-- Get the functions
	local startSelection = Functions.startSelection
	local refreshOptions = Functions.refreshOptions
	local connect = Functions.connect
	local updateCanvas = Functions.updateCanvas
	
	
	
	-- Sees if the iconOptions is already with icons
	local clear = true
	for index, object in pairs(userIconOptions:GetChildren()) do
		if object:IsA("Frame") then
			clear = false
			break
		end
	end

	local currentUserIconName = GetCurrentUserIcon:InvokeServer("Name")
	-- Handle the new/already icons
	if clear then
		-- Get icons table data
		local Icons = GetAll:InvokeServer("UserIcons")

		-- Set the icons in the user icon options
		for index, icon in pairs(Icons) do
			-- Set the current user icon and it's events
			if icon.Name == currentUserIconName then
				local newIcon = userTemplate:Clone()
				newIcon.Button.Image = icon.Id
				newIcon.Name = icon.Name
				newIcon.Text.Text = icon.Name
				newIcon.Parent = userIconOptions
				newIcon.Visible = true
				startSelection(newIcon.SelectionFrame, true)
				newIcon.Button.Interactable = false
				local iconConnection1 = newIcon.Button.MouseButton1Click:Connect(function()
					oldMouseClick:Play()
					ChangeCurrentUserIcon:InvokeServer(newIcon.Name)
					refreshOptions(userIconOptions)
					newIcon.Button.Interactable = false
					startSelection(newIcon.SelectionFrame, true)
					newIcon.SelectionFrame.Selected.Value = true
					userButton.Image = newIcon.Button.Image
				end)
				connect(userIconsConnections, iconConnection1)

				local iconConnection2 = newIcon.Button.MouseEnter:Connect(function()
					startSelection(newIcon.SelectionFrame, true)
				end)
				connect(userIconsConnections, iconConnection2)

				local iconConnection3 = newIcon.Button.MouseLeave:Connect(function()
					if newIcon.SelectionFrame.Selected.Value then
						return
					else
						startSelection(newIcon.SelectionFrame, false)
					end
				end)
				connect(userIconsConnections, iconConnection3)

			else
				-- Set the others user icons
				local newIcon = userTemplate:Clone()
				newIcon.Button.Image = icon.Id
				newIcon.Name = icon.Name
				newIcon.Text.Text = icon.Name
				newIcon.Parent = userIconOptions

				newIcon.Visible = true
				local iconConnection1 = newIcon.Button.MouseButton1Click:Connect(function()
					oldMouseClick:Play()
					ChangeCurrentUserIcon:InvokeServer(newIcon.Name)
					refreshOptions(userIconOptions)
					newIcon.Button.Interactable = false
					startSelection(newIcon.SelectionFrame, true)
					newIcon.SelectionFrame.Selected.Value = true
					userButton.Image = newIcon.Button.Image

				end)
				connect(userIconsConnections, iconConnection1)

				local iconConnection2 = newIcon.Button.MouseEnter:Connect(function()
					startSelection(newIcon.SelectionFrame, true)
				end)
				connect(userIconsConnections, iconConnection2)

				local iconConnection3 = newIcon.Button.MouseLeave:Connect(function()
					if newIcon.SelectionFrame.Selected.Value then
						return
					else
						startSelection(newIcon.SelectionFrame, false)
					end
				end)
				connect(userIconsConnections, iconConnection3)
			end
		end
		updateCanvas(userIconOptions)
	else
		-- Get and set icons events
		for index, icon in pairs(userIconOptions:GetChildren()) do
			if icon:IsA("Frame") then
				local button = icon.Button
				local selectionFrame = icon.SelectionFrame
				local selected = selectionFrame.Selected

				local iconConnection1 = button.MouseButton1Click:Connect(function()
					oldMouseClick:Play()
					ChangeCurrentUserIcon:InvokeServer(icon.Name)
					refreshOptions(userIconOptions)
					button.Interactable = false
					startSelection(selectionFrame, true)
					selected.Value = true
					userButton.Image = button.Image
				end)
				connect(userIconsConnections, iconConnection1)

				local iconConnection2 = button.MouseEnter:Connect(function()
					startSelection(selectionFrame, true)
				end)
				connect(userIconsConnections, iconConnection2)

				local iconConnection3 = button.MouseLeave:Connect(function()
					if selected.Value then
						return
					else
						startSelection(selectionFrame, false)
					end
				end)
				connect(userIconsConnections, iconConnection3)
			end
		end
	end
end

return UserIcons
