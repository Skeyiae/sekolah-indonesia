-- Quiz Server
print("[Quiz Server] Starting...")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local TeleportManager = require(ReplicatedStorage.Shared.TeleportManager)
local PlaceConfig = require(ReplicatedStorage.Shared.PlaceConfig)

-- Create RemoteEvent for returning to lobby
local RemotesFolder = ReplicatedStorage:FindFirstChild("Remotes") or Instance.new("Folder")
RemotesFolder.Name = "Remotes"
RemotesFolder.Parent = ReplicatedStorage

local ReturnToLobby = RemotesFolder:FindFirstChild("ReturnToLobby") or Instance.new("RemoteEvent")
ReturnToLobby.Name = "ReturnToLobby"
ReturnToLobby.Parent = RemotesFolder

-- Handle return to lobby
ReturnToLobby.OnServerEvent:Connect(function(player)
	print("[Quiz Server]", player.Name, "returning to lobby")
	TeleportManager:ToLobby(player)
end)

-- Welcome message
Players.PlayerAdded:Connect(function(player)
	task.wait(1)
	print("[Quiz Server] Welcome", player.Name, "to Quiz Arena!")
	
	-- Get teleport data if any
	local teleportData = TeleportManager:GetTeleportData(player)
	if teleportData then
		print("[Quiz Server] Quiz data:", teleportData)
	end
end)

print("[Quiz Server] Ready!")
