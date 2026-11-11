-- Client Entry Point
print("[Client] Starting Drawing Canvas System...")

local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Wait for Shared modules to load
repeat task.wait() until ReplicatedStorage:FindFirstChild("Shared")

local CanvasClient = require(script.CanvasClient)

-- Initialize client
CanvasClient:Initialize()

print("[Client] Drawing Canvas System ready!")