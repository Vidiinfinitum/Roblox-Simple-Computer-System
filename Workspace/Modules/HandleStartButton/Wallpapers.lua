local Wallpapers = {}

function Wallpapers.StartFrame(wallpaperOptions:ScrollingFrame, wallpapersConnections ,wallpaperTemplate:Frame, oldMouseClick:Sound, background:ImageLabel, Functions, Remotes)
	
	-- Get the events
	local GetCurrentWallpaper = Remotes	.GetCurrentWallpaper
	local ChangeCurrentWallpaper = Remotes.ChangeCurrentWallpaper
	local GetAll = Remotes.GetAll
	
	-- Get the functions
	local startSelection = Functions.StartSelection
	local refreshOptions = Functions.refreshOptions
	local connect = Functions.connect
	local updateCanvas = Functions.updateCanvas
	
	-- Sees if the wallpaperOptions is already with musics
	local clear = true
	for index, object in pairs(wallpaperOptions:GetChildren()) do
		if object:IsA("Frame") then
			clear = false
			break
		end
	end

	local currentWallpaperName = GetCurrentWallpaper:InvokeServer("Name")
	local layout = wallpaperOptions.UIListLayout

	-- Handle the new/already icons
	if clear then
		-- Get music table data
		local Wallpapers = GetAll:InvokeServer("Wallpapers")
		-- Set the wallpapers in the wallpaper options
		for index, wallpaper in pairs(Wallpapers) do
			-- Set the current wallpaper and it's events
			if wallpaper.Name == currentWallpaperName then
				local newWallpaper = wallpaperTemplate:Clone()
				newWallpaper.Name = wallpaper.Name
				newWallpaper.Button.Image = wallpaper.Id
				newWallpaper.Text.Text = wallpaper.Name
				newWallpaper.Parent = wallpaperOptions
				newWallpaper.Visible = true
				startSelection(newWallpaper.SelectionFrame, true)
				newWallpaper.Interactable = false

				local wallpaperConnection1 = newWallpaper.Button.MouseButton1Click:Connect(function()

					oldMouseClick:Play()

					if newWallpaper.Name == "Default" then
						ChangeCurrentWallpaper:InvokeServer(newWallpaper.Name)
						background.BackgroundTransparency = 0
						background.ImageTransparency = 1

						refreshOptions(wallpaperOptions)
						newWallpaper.Button.Interactable = false
						startSelection(newWallpaper.SelectionFrame, true)
						newWallpaper.SelectionFrame.Selected.Value = true
					else
						ChangeCurrentWallpaper:InvokeServer(newWallpaper.Name)
						-- To set the new wallpaper to the background
						background.BackgroundTransparency = 1
						background.ImageTransparency = 0
						background.Image = newWallpaper.Button.Image

						refreshOptions(wallpaperOptions)
						newWallpaper.Button.Interactable = false
						startSelection(newWallpaper.SelectionFrame, true)
						newWallpaper.SelectionFrame.Selected.Value = true
					end

				end)
				connect(wallpapersConnections, wallpaperConnection1)

				local wallpaperConnection2 = newWallpaper.Button.MouseEnter:Connect(function()
					startSelection(newWallpaper.SelectionFrame, true)
				end)
				connect(wallpapersConnections, wallpaperConnection2)

				local wallpaperConnection3 = newWallpaper.Button.MouseLeave:Connect(function()
					if newWallpaper.SelectionFrame.Selected.Value then
						return
					else
						startSelection(newWallpaper.SelectionFrame, false)
					end
				end)
				connect(wallpapersConnections, wallpaperConnection3)

			else
				-- Set the others wallpapers
				local newWallpaper = wallpaperTemplate:Clone()
				newWallpaper.Name = wallpaper.Name
				newWallpaper.Button.Image = wallpaper.Id
				newWallpaper.Text.Text = wallpaper.Name
				newWallpaper.Parent = wallpaperOptions
				newWallpaper.Visible = true
				local wallpaperConnection1 = newWallpaper.Button.MouseButton1Click:Connect(function()

					oldMouseClick:Play()

					if newWallpaper.Name == "Default" then
						ChangeCurrentWallpaper:InvokeServer(newWallpaper.Name)
						background.BackgroundTransparency = 0
						background.ImageTransparency = 1

						refreshOptions(wallpaperOptions)
						newWallpaper.Button.Interactable = false
						startSelection(newWallpaper.SelectionFrame, true)
						newWallpaper.SelectionFrame.Selected.Value = true
					else
						ChangeCurrentWallpaper:InvokeServer(newWallpaper.Name)
						-- To set the new wallpaper to the background
						background.BackgroundTransparency = 1
						background.ImageTransparency = 0
						background.Image = newWallpaper.Button.Image

						refreshOptions(wallpaperOptions)
						newWallpaper.Button.Interactable = false
						startSelection(newWallpaper.SelectionFrame, true)
						newWallpaper.SelectionFrame.Selected.Value = true
					end

				end)
				connect(wallpapersConnections, wallpaperConnection1)

				local wallpaperConnection2 = newWallpaper.Button.MouseEnter:Connect(function()
					startSelection(newWallpaper.SelectionFrame, true)
				end)
				connect(wallpapersConnections, wallpaperConnection2)

				local wallpaperConnection3 = newWallpaper.Button.MouseLeave:Connect(function()
					if newWallpaper.SelectionFrame.Selected.Value then
						return
					else
						startSelection(newWallpaper.SelectionFrame, false)
					end
				end)
				connect(wallpapersConnections, wallpaperConnection3)
			end
		end
		updateCanvas(wallpaperOptions)
	else
		-- Get and set wallpapers events
		for index, wallpaper in pairs(wallpaperOptions:GetChildren()) do
			if wallpaper:IsA("Frame") then
				local button = wallpaper.Button
				local selectionFrame = wallpaper.SelectionFrame
				local selected = selectionFrame.Selected

				local wallpaperConnection1 = button.MouseButton1Click:Connect(function()

					oldMouseClick:Play()

					if wallpaper.Name == "Default" then
						ChangeCurrentWallpaper:InvokeServer(wallpaper.Name)
						background.BackgroundTransparency = 0
						background.ImageTransparency = 1

						refreshOptions(wallpaperOptions)
						button.Interactable = false
						startSelection(selectionFrame, true)
						selected.Value = true
					else
						ChangeCurrentWallpaper:InvokeServer(wallpaper.Name)
						-- To set the new wallpaper to the background
						background.BackgroundTransparency = 1
						background.ImageTransparency = 0
						background.Image = button.Image

						refreshOptions(wallpaperOptions)
						button.Interactable = false
						startSelection(selectionFrame, true)
						selected.Value = true
					end

				end)
				connect(wallpapersConnections, wallpaperConnection1)

				local wallpaperConnection2 = button.MouseEnter:Connect(function()
					startSelection(selectionFrame, true)
				end)
				connect(wallpapersConnections, wallpaperConnection2)

				local wallpaperConnection3 = button.MouseLeave:Connect(function()
					if selected.Value then
						return
					else
						startSelection(selectionFrame, false)
					end
				end)
				connect(wallpapersConnections, wallpaperConnection3)
			end
		end
	end
end

return Wallpapers
