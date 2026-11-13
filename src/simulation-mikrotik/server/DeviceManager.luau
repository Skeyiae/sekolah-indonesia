-- DeviceManager.luau
-- Manage device creation, deletion, and server-side state

local DeviceTypes = require(script.Parent.Parent.shared.DeviceTypes)

local DeviceManager = {}
DeviceManager.devices = {} -- {deviceID: deviceInstance}
DeviceManager.playerDevices = {} -- {playerID: {deviceID1, deviceID2, ...}}

-- Helper: Get model size for a device type
local function GetModelSize(deviceType: string): Vector3
	local props = DeviceTypes:GetProperties(deviceType)
	return props.Size
end

-- Helper: Get model color for a device type
local function GetModelColor(deviceType: string): Color3
	local props = DeviceTypes:GetProperties(deviceType)
	return props.Color
end

-- Helper: Create a Part model for a device
local function CreateDeviceModel(deviceType: string, position: Vector3): Part
	local size = GetModelSize(deviceType)
	local color = GetModelColor(deviceType)

	-- Create main body
	local model = Instance.new("Part")
	model.Name = DeviceTypes:GetProperties(deviceType).Name
	model.Shape = Enum.PartType.Block
	model.Size = size
	model.Color = color
	model.CanCollide = true
	model.Anchored = true
	model.Position = position
	model.Material = Enum.Material.Plastic
	model.TopSurface = Enum.SurfaceType.Smooth
	model.BottomSurface = Enum.SurfaceType.Smooth

	-- Add a clickable label
	local label = Instance.new("SurfaceGui")
	label.Face = Enum.NormalId.Top
	label.Parent = model

	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.fromScale(1, 1)
	textLabel.BackgroundTransparency = 0.3
	textLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	textLabel.Text = DeviceTypes:GetProperties(deviceType).Name
	textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	textLabel.TextSize = 14
	textLabel.Font = Enum.Font.GothamBold
	textLabel.Parent = label

	return model
end

-- Place a device in the world
function DeviceManager:PlaceDevice(deviceType: string, position: Vector3, player: Player): (boolean, string, table?)
	-- Validate device type
	if not DeviceTypes:IsValidType(deviceType) then
		return false, "Invalid device type: " .. deviceType
	end

	-- Create device instance
	local deviceInstance = DeviceTypes:CreateInstance(deviceType, position, player)

	-- Create 3D model
	local model = CreateDeviceModel(deviceType, position)
	model.Parent = workspace

	deviceInstance.Model = model

	-- Store device
	self.devices[deviceInstance.ID] = deviceInstance

	-- Track player devices
	if not self.playerDevices[player.UserId] then
		self.playerDevices[player.UserId] = {}
	end
	table.insert(self.playerDevices[player.UserId], deviceInstance.ID)

	print(
		"[DeviceManager] Placed",
		deviceType,
		"for",
		player.Name,
		"at",
		position,
		"(ID:",
		deviceInstance.ID,
		")"
	)

	return true, "Device placed successfully", deviceInstance
end

-- Remove a device from the world
function DeviceManager:RemoveDevice(deviceID: string, player: Player?): (boolean, string)
	local device = self.devices[deviceID]

	if not device then
		return false, "Device not found: " .. deviceID
	end

	-- Check ownership (if player provided)
	if player and device.Owner ~= player then
		return false, "You don't own this device"
	end

	-- Remove model from world
	if device.Model then
		device.Model:Destroy()
	end

	-- Remove from tracking
	if self.playerDevices[device.Owner.UserId] then
		local index = table.find(self.playerDevices[device.Owner.UserId], deviceID)
		if index then
			table.remove(self.playerDevices[device.Owner.UserId], index)
		end
	end

	-- Remove device
	self.devices[deviceID] = nil

	print("[DeviceManager] Removed device", deviceID, "for", device.Owner.Name)

	return true, "Device removed successfully"
end

-- Update device configuration
function DeviceManager:UpdateConfig(deviceID: string, config: table, player: Player?): (boolean, string)
	local device = self.devices[deviceID]

	if not device then
		return false, "Device not found: " .. deviceID
	end

	-- Check ownership
	if player and device.Owner ~= player then
		return false, "You don't own this device"
	end

	-- Validate config
	local valid, errMsg = DeviceTypes:ValidateConfig(device.Type, config)
	if not valid then
		return false, errMsg or "Invalid configuration"
	end

	-- Update config
	device.Config = config

	print("[DeviceManager] Updated config for device", deviceID, "IP:", config.IP)

	return true, "Configuration updated successfully"
end

-- Get all devices for a player
function DeviceManager:GetPlayerDevices(player: Player): {table}
	local playerDeviceIDs = self.playerDevices[player.UserId] or {}
	local devices = {}

	for _, deviceID in ipairs(playerDeviceIDs) do
		if self.devices[deviceID] then
			table.insert(devices, self.devices[deviceID])
		end
	end

	return devices
end

-- Get a specific device
function DeviceManager:GetDevice(deviceID: string): table?
	return self.devices[deviceID]
end

-- Get all devices (for broadcasting)
function DeviceManager:GetAllDevices(): table
	return self.devices
end

-- Get device count
function DeviceManager:GetDeviceCount(): number
	return #(table.keys(self.devices))
end

-- Clear all devices (for testing)
function DeviceManager:ClearAllDevices()
	for deviceID, device in pairs(self.devices) do
		if device.Model then
			device.Model:Destroy()
		end
	end
	self.devices = {}
	self.playerDevices = {}
	print("[DeviceManager] All devices cleared")
end

-- Handle player leaving (cleanup devices)
function DeviceManager:OnPlayerRemoving(player: Player)
	local playerDeviceIDs = self.playerDevices[player.UserId] or {}

	for _, deviceID in ipairs(playerDeviceIDs) do
		self:RemoveDevice(deviceID)
	end

	self.playerDevices[player.UserId] = nil

	print("[DeviceManager] Cleaned up devices for", player.Name)
end

return DeviceManager
