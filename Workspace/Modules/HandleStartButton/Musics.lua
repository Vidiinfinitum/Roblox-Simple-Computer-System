local Musics = {}

function Musics.StartFrame(musicOptions:ScrollingFrame, musicTemplate:Frame, currentHouseMusic:Sound, musicsConnections, oldMouseClick:Sound, Functions, Remotes)
	
	-- Get remote events
	local GetCurrentHouseMusic = Remotes.GetCurrentHouseMusic
	local ChangeCurrentHouseMusic = Remotes.ChangeCurrentHouseMusic
	local GetAll = Remotes.GetAll
	
	-- Get functions
	local startSelection = Functions.StartSelection
	local refreshOptions = Functions.refreshOptions
	local connect = Functions.connect
	local updateCanvas = Functions.updateCanvas
	
	
	-- Sees if the musicOptions is already with musics
	local clear = true
	for index, object in pairs(musicOptions:GetChildren()) do
		if object:IsA("Frame") then
			clear = false
			break
		end
	end

	local currentHouseMusicName = GetCurrentHouseMusic:InvokeServer("Name")
	local layout = musicOptions.UIListLayout

	-- Handle the new/already icons
	if clear then
		-- Get music table data
		local Musics = GetAll:InvokeServer("Musics")
		-- Set the musics in the musics options
		for index, music in pairs(Musics) do
			-- Set the current music and it's events
			if music.Name == currentHouseMusicName then
				local newMusic = musicTemplate:Clone()
				newMusic.Name = music.Name
				newMusic.Text.Text = music.Name
				newMusic.Id.Value = music.Id
				newMusic.Parent = musicOptions
				newMusic.Visible = true
				startSelection(newMusic.SelectionFrame, true)
				newMusic.Button.Interactable = false
				local musicConnection1 = newMusic.Button.MouseButton1Click:Connect(function()
					oldMouseClick:Play()
					currentHouseMusic:Stop()
					currentHouseMusic.SoundId = newMusic.Id.Value
					currentHouseMusic:Play()
					ChangeCurrentHouseMusic:InvokeServer(newMusic.Name)
					refreshOptions(musicOptions)
					newMusic.Button.Interactable = false
					startSelection(newMusic.SelectionFrame, true)
					newMusic.SelectionFrame.Selected.Value = true
				end)
				connect(musicsConnections, musicConnection1)

				local musicConnection2 = newMusic.Button.MouseEnter:Connect(function()
					startSelection(newMusic.SelectionFrame, true)
				end)
				connect(musicsConnections, musicConnection2)

				local musicConnection3 = newMusic.Button.MouseLeave:Connect(function()
					if newMusic.SelectionFrame.Selected.Value then
						return
					else
						startSelection(newMusic.SelectionFrame, false)
					end
				end)
				connect(musicsConnections, musicConnection3)

			else
				-- Set the others musics
				local newMusic = musicTemplate:Clone()
				newMusic.Name = music.Name
				newMusic.Text.Text = music.Name
				newMusic.Id.Value = music.Id
				newMusic.Parent = musicOptions
				newMusic.Visible = true
				local musicConnection1 = newMusic.Button.MouseButton1Click:Connect(function()
					oldMouseClick:Play()
					currentHouseMusic:Stop()
					currentHouseMusic.SoundId = newMusic.Id.Value
					currentHouseMusic:Play()
					ChangeCurrentHouseMusic:InvokeServer(newMusic.Name)
					refreshOptions(musicOptions)
					newMusic.Button.Interactable = false
					startSelection(newMusic.SelectionFrame, true)
					newMusic.SelectionFrame.Selected.Value = true
				end)
				connect(musicsConnections, musicConnection1)

				local musicConnection2 = newMusic.Button.MouseEnter:Connect(function()
					startSelection(newMusic.SelectionFrame, true)
				end)
				connect(musicsConnections, musicConnection2)

				local musicConnection3 = newMusic.Button.MouseLeave:Connect(function()
					if newMusic.SelectionFrame.Selected.Value then
						return
					else
						startSelection(newMusic.SelectionFrame, false)
					end
				end)
				connect(musicsConnections, musicConnection3)
			end
		end
		updateCanvas(musicOptions)
	else
		-- Get and set musics events
		for index, music in pairs(musicOptions:GetChildren()) do
			if music:IsA("Frame") then
				local button = music.Button
				local selectionFrame = music.SelectionFrame
				local selected = selectionFrame.Selected
				local id = music.Id

				local musicConnection1 = button.MouseButton1Click:Connect(function()
					oldMouseClick:Play()
					currentHouseMusic:Stop()
					currentHouseMusic.SoundId = id.Value
					currentHouseMusic:Play()
					ChangeCurrentHouseMusic:InvokeServer(music.Name)
					refreshOptions(musicOptions)
					button.Interactable = false
					startSelection(selectionFrame, true)
					selected.Value = true
				end)
				connect(musicsConnections, musicConnection1)

				local musicConnection2 = button.MouseEnter:Connect(function()
					startSelection(selectionFrame, true)
				end)
				connect(musicsConnections, musicConnection2)

				local musicConnection3 = button.MouseLeave:Connect(function()
					if selected.Value then
						return
					else
						startSelection(selectionFrame, false)
					end
				end)
				connect(musicsConnections, musicConnection3)
			end
		end
	end
end

return Musics
