-- init.client.luau
-- Client entry point for Simulation Mikrotik

print("[Simulation Mikrotik] Client starting...")

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Wait for shared modules
repeat
	task.wait()
until ReplicatedStorage:FindFirstChild("Shared")

local HotbarUI = require(script.HotbarUI)
local PlacementSystem = require(script.PlacementSystem)
local DeviceRaycast = require(script.DeviceRaycast)
local Remotes = require(ReplicatedStorage.Shared.NetworkRemotes)

print("[Simulation Mikrotik] Modules loaded")

-- Initialize systems
PlacementSystem:Init()
DeviceRaycast:Init()

-- Create hotbar with device selection callback
HotbarUI:Create(function(deviceType)
	print("[Client] Selected device:", deviceType)
	PlacementSystem:StartPlacement(deviceType)
	HotbarUI:HighlightButton(deviceType)
end)

-- Handle device placement success
Remotes.DevicePlaced.OnClientEvent:Connect(function(deviceInstance)
	print("[Client] Device placed:", deviceInstance.Type)

	-- Register with raycast system
	if deviceInstance.Model then
		DeviceRaycast:RegisterDevice(deviceInstance.Model, deviceInstance.ID)
	end

	-- Clear hotbar highlight
	HotbarUI:ClearHighlight()
end)

-- Handle device removal
Remotes.DeviceRemoved.OnClientEvent:Connect(function(deviceID)
	print("[Client] Device removed:", deviceID)
end)

-- Handle device config updates
Remotes.DeviceConfigUpdated.OnClientEvent:Connect(function(deviceID, config)
	print("[Client] Device config updated:", deviceID, "IP:", config.IP)
end)

-- Handle device interaction
DeviceRaycast.onDeviceClicked = function(deviceID)
	print("[Client] Clicked device:", deviceID)
	-- TODO: Show context menu (Phase 2)
end

-- Request network state on join
task.wait(1)
Remotes.RequestNetworkState:FireServer()

-- Handle network state sync
Remotes.NetworkState.OnClientEvent:Connect(function(deviceList)
	print("[Client] Received network state with", #deviceList, "devices")

	for _, deviceData in ipairs(deviceList) do
		print(
			"  - ",
			deviceData.Type,
			"at",
			deviceData.Position,
			"IP:",
			deviceData.Config.IP
		)
	end
end)

print("[Simulation Mikrotik] Client ready!")
