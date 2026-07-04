local ConnectionsFunctions = {}

function ConnectionsFunctions.connect(connectionTable, connection)
	table.insert(connectionTable, connection)
end

function ConnectionsFunctions.clearConnections(connections)
	for index, connection in pairs(connections) do
		connection:Disconnect()
	end
end

return ConnectionsFunctions
