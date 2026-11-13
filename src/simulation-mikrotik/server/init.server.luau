-- init.server.luau
-- Server entry point for Simulation Mikrotik

print("[Simulation Mikrotik] Server starting...")

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Wait for shared modules
repeat
	task.wait()
until ReplicatedStorage:FindFirstChild("Shared")

local DeviceManager = require(script.DeviceManager)
local Remotes = require(ReplicatedStorage.Shared.NetworkRemotes)

print("[Simulation Mikrotik] Modules loaded")

-- Setup remote event handlers
Remotes.PlaceDevice.OnServerEvent:Connect(function(player, deviceType, position)
	print("[Server] Device placement request from", player.Name, "-", deviceType)

	local success, message, deviceInstance = DeviceManager:PlaceDevice(deviceType, position, player)

	if success then
		-- Broadcast to all clients that device was placed
		Remotes.DevicePlaced:FireAllClients(deviceInstance)
		print("[Server]", message)
	else
		-- Send error to requesting player
		print("[Server] Placement failed:", message)
	end
end)

Remotes.RemoveDevice.OnServerEvent:Connect(function(player, deviceID)
	print("[Server] Device removal request from", player.Name, "- ID:", deviceID)

	local success, message = DeviceManager:RemoveDevice(deviceID, player)

	if success then
		-- Broadcast to all clients that device was removed
		Remotes.DeviceRemoved:FireAllClients(deviceID)
		print("[Server]", message)
	else
		-- Send error
		print("[Server] Removal failed:", message)
	end
end)

Remotes.UpdateDeviceConfig.OnServerEvent:Connect(function(player, deviceID, config)
	print("[Server] Config update request from", player.Name, "- ID:", deviceID)

	local success, message = DeviceManager:UpdateConfig(deviceID, config, player)

	if success then
		-- Broadcast to all clients
		Remotes.DeviceConfigUpdated:FireAllClients(deviceID, config)
		print("[Server]", message)
	else
		print("[Server] Config update failed:", message)
	end
end)

Remotes.RequestNetworkState.OnServerEvent:Connect(function(player)
	print("[Server] Network state request from", player.Name)

	local allDevices = DeviceManager:GetAllDevices()

	-- Convert to serializable format
	local deviceList = {}
	for deviceID, device in pairs(allDevices) do
		table.insert(deviceList, {
			ID = device.ID,
			Type = device.Type,
			Position = device.Position,
			Config = device.Config,
		})
	end

	-- Send to requesting player only
	Remotes.NetworkState:FireClient(player, deviceList)
end)

-- Handle player leaving
Players.PlayerRemoving:Connect(function(player)
	print("[Server] Player leaving:", player.Name)
	DeviceManager:OnPlayerRemoving(player)
end)

-- Welcome message
Players.PlayerAdded:Connect(function(player)
	task.wait(1)
	print("[Server] Welcome", player.Name, "to Simulation Mikrotik!")
end)

print("[Simulation Mikrotik] Server ready!")
