-- Server Entry Point
print("[Server] Starting Drawing Canvas System...")

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CanvasService = require(script.CanvasService)
local DrawingService = require(script.DrawingService)
local Remotes = require(ReplicatedStorage.Shared.RemoteEvents)

-- Initialize services
CanvasService:Initialize()
DrawingService:Initialize()

-- Setup RemoteFunction for claiming
Remotes.ClaimCanvas.OnServerInvoke = function(player, canvasId)
	return CanvasService:ClaimCanvas(player, canvasId)
end

-- Setup RemoteEvent for unclaiming
Remotes.UnclaimCanvas.OnServerEvent:Connect(function(player, canvasId)
	CanvasService:UnclaimCanvas(player, canvasId)
end)

-- Handle player leaving
Players.PlayerRemoving:Connect(function(player)
	CanvasService:OnPlayerRemoving(player)
end)

print("[Server] Drawing Canvas System ready!")