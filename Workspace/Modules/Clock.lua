local Clock = {}

function Clock.Start(textLabel:TextLabel)
	task.spawn(function()
		while textLabel and textLabel.Parent do
			local time = os.date("*t")

			textLabel.Text = string.format("%02d:%02d", time.hour, time.min)

			task.wait(60 - time.sec)
		end
	end)
end

return Clock
