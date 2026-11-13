-- Lobby Server
print("[Lobby Server] Starting...")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local TeleportManager = require(ReplicatedStorage.Shared.TeleportManager)
local PlaceConfig = require(ReplicatedStorage.Shared.PlaceConfig)

-- Create RemoteEvent for teleport requests
local RemotesFolder = ReplicatedStorage:FindFirstChild("Remotes") or Instance.new("Folder")
RemotesFolder.Name = "Remotes"
RemotesFolder.Parent = ReplicatedStorage

local TeleportRequest = RemotesFolder:FindFirstChild("TeleportRequest") or Instance.new("RemoteEvent")
TeleportRequest.Name = "TeleportRequest"
TeleportRequest.Parent = RemotesFolder

-- Handle teleport requests from clients
TeleportRequest.OnServerEvent:Connect(function(player, destination: string, data: any?)
	print("[Lobby Server]", player.Name, "wants to teleport to:", destination)
	
	if destination == "Quiz" then
		TeleportManager:ToQuiz(player, data)
	elseif destination == "Drawing" then
		TeleportManager:ToDrawing(player)
	elseif destination == "WinBox" then
		TeleportManager:ToWinBox(player)
	else
		warn("[Lobby Server] Unknown destination:", destination)
	end
end)

-- Welcome message
Players.PlayerAdded:Connect(function(player)
	task.wait(1)
	print("[Lobby Server] Welcome", player.Name, "to", PlaceConfig:GetCurrentPlaceName())
	
	-- Check if player has teleport data
	local teleportData = TeleportManager:GetTeleportData(player)
	if teleportData then
		print("[Lobby Server]", player.Name, "returned from:", teleportData.from)
	end
end)

print("[Lobby Server] Ready!")
