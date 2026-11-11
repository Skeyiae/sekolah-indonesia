-- RemoteEvents.luau
-- Central place for all remote events

local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Create RemoteEvents folder if it doesn't exist
local RemotesFolder = ReplicatedStorage:FindFirstChild("Remotes")
if not RemotesFolder then
	RemotesFolder = Instance.new("Folder")
	RemotesFolder.Name = "Remotes"
	RemotesFolder.Parent = ReplicatedStorage
end

-- Helper function to create or get RemoteEvent
local function getOrCreateRemote(name: string, className: string): RemoteEvent | RemoteFunction
	local remote = RemotesFolder:FindFirstChild(name)
	if not remote then
		remote = Instance.new(className)
		remote.Name = name
		remote.Parent = RemotesFolder
	end
	return remote
end

-- Remote Events
local Remotes = {
	-- Canvas Management
	ClaimCanvas = getOrCreateRemote("ClaimCanvas", "RemoteFunction"),
	UnclaimCanvas = getOrCreateRemote("UnclaimCanvas", "RemoteEvent"),
	CanvasClaimed = getOrCreateRemote("CanvasClaimed", "RemoteEvent"),
	
	-- Drawing
	StartDrawing = getOrCreateRemote("StartDrawing", "RemoteEvent"),
	DrawStroke = getOrCreateRemote("DrawStroke", "RemoteEvent"),
	EndDrawing = getOrCreateRemote("EndDrawing", "RemoteEvent"),
	ClearCanvas = getOrCreateRemote("ClearCanvas", "RemoteEvent"),
	
	-- Color/Size selection
	ChangeDrawColor = getOrCreateRemote("ChangeDrawColor", "RemoteEvent"),
	ChangeBrushSize = getOrCreateRemote("ChangeBrushSize", "RemoteEvent"),
}

return Remotes
