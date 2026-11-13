-- NetworkRemotes.luau
-- Setup all RemoteEvents for Simulation Mikrotik communication

local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Create Remotes folder if it doesn't exist
local RemotesFolder = ReplicatedStorage:FindFirstChild("Remotes")
if not RemotesFolder then
	RemotesFolder = Instance.new("Folder")
	RemotesFolder.Name = "Remotes"
	RemotesFolder.Parent = ReplicatedStorage
end

-- Create MikrotikLab folder for our remotes
local MikrotikFolder = RemotesFolder:FindFirstChild("MikrotikLab")
if not MikrotikFolder then
	MikrotikFolder = Instance.new("Folder")
	MikrotikFolder.Name = "MikrotikLab"
	MikrotikFolder.Parent = RemotesFolder
end

-- Helper function to create or get RemoteEvent
local function getOrCreateRemote(name: string): RemoteEvent
	local remote = MikrotikFolder:FindFirstChild(name)
	if not remote then
		remote = Instance.new("RemoteEvent")
		remote.Name = name
		remote.Parent = MikrotikFolder
	end
	return remote
end

-- Remote Events for Device Management
local Remotes = {
	-- Device Placement
	PlaceDevice = getOrCreateRemote("PlaceDevice"),
	-- Fired: Client -> Server(deviceType, position)
	-- Listened: Server receives device placement request

	DevicePlaced = getOrCreateRemote("DevicePlaced"),
	-- Fired: Server -> All Clients(deviceInstance)
	-- Listened: Clients receive notification of new device

	-- Device Removal
	RemoveDevice = getOrCreateRemote("RemoveDevice"),
	-- Fired: Client -> Server(deviceID)
	-- Listened: Server receives device removal request

	DeviceRemoved = getOrCreateRemote("DeviceRemoved"),
	-- Fired: Server -> All Clients(deviceID)
	-- Listened: Clients receive notification of device removal

	-- Device Configuration
	UpdateDeviceConfig = getOrCreateRemote("UpdateDeviceConfig"),
	-- Fired: Client -> Server(deviceID, config)
	-- Listened: Server receives configuration update

	DeviceConfigUpdated = getOrCreateRemote("DeviceConfigUpdated"),
	-- Fired: Server -> All Clients(deviceID, config)
	-- Listened: Clients receive config update notification

	-- Network State Sync
	RequestNetworkState = getOrCreateRemote("RequestNetworkState"),
	-- Fired: Client -> Server()
	-- Listened: Server receives request for full network state

	NetworkState = getOrCreateRemote("NetworkState"),
	-- Fired: Server -> Client({devices})
	-- Listened: Client receives full network state

	-- Device Interaction
	GetDeviceInfo = getOrCreateRemote("GetDeviceInfo"),
	-- Fired: Client -> Server(deviceID)
	-- Listened: Server receives info request

	DeviceInfo = getOrCreateRemote("DeviceInfo"),
	-- Fired: Server -> Client(deviceInfo)
	-- Listened: Client receives device info
}

return Remotes
