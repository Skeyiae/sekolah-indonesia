-- DeviceTypes.luau
-- Device type definitions and properties for Simulation Mikrotik

local DeviceTypes = {}

-- Device Type Enum
DeviceTypes.Type = {
	PC = "PC",
	Switch = "Switch",
	Router = "Router",
	Firewall = "Firewall",
	AP = "AccessPoint",
	Server = "Server",
}

-- Device Properties (Size, Color, Display Name, Default Config)
DeviceTypes.Properties = {
	[DeviceTypes.Type.PC] = {
		Name = "PC",
		Size = Vector3.new(10, 2, 8),
		Color = Color3.fromRGB(128, 128, 128), -- Gray
		DefaultConfig = {
			IP = "192.168.1.100",
			Subnet = "255.255.255.0",
			Gateway = "192.168.1.1",
			Hostname = "PC-1",
		},
	},
	[DeviceTypes.Type.Switch] = {
		Name = "Switch",
		Size = Vector3.new(12, 2, 6),
		Color = Color3.fromRGB(105, 105, 105), -- Dark Gray
		DefaultConfig = {
			IP = "192.168.1.254",
			Subnet = "255.255.255.0",
			Gateway = "192.168.1.1",
			VLAN = 1,
		},
	},
	[DeviceTypes.Type.Router] = {
		Name = "Router",
		Size = Vector3.new(10, 4, 6),
		Color = Color3.fromRGB(0, 102, 204), -- Blue
		DefaultConfig = {
			IP = "192.168.1.1",
			Subnet = "255.255.255.0",
			Gateway = "0.0.0.0",
			Hostname = "Router",
		},
	},
	[DeviceTypes.Type.Firewall] = {
		Name = "Firewall",
		Size = Vector3.new(8, 3, 6),
		Color = Color3.fromRGB(204, 0, 0), -- Red
		DefaultConfig = {
			IP = "192.168.1.2",
			Subnet = "255.255.255.0",
			Gateway = "192.168.1.1",
			FilteringEnabled = true,
		},
	},
	[DeviceTypes.Type.AP] = {
		Name = "Access Point",
		Size = Vector3.new(6, 6, 8),
		Color = Color3.fromRGB(255, 204, 0), -- Yellow
		DefaultConfig = {
			IP = "192.168.1.50",
			Subnet = "255.255.255.0",
			Gateway = "192.168.1.1",
			SSID = "Network",
			Channel = 6,
		},
	},
	[DeviceTypes.Type.Server] = {
		Name = "Server",
		Size = Vector3.new(6, 6, 10),
		Color = Color3.fromRGB(0, 153, 0), -- Green
		DefaultConfig = {
			IP = "192.168.1.200",
			Subnet = "255.255.255.0",
			Gateway = "192.168.1.1",
			Service = "DNS",
			Hostname = "Server-1",
		},
	},
}

-- Device Instance Structure
DeviceTypes.Instance = {
	ID = "", -- Unique device ID
	Type = "", -- Device type (PC, Switch, etc)
	Owner = nil, -- Player who placed it
	Position = Vector3.new(0, 0, 0),
	Rotation = 0,
	Config = {}, -- Configuration (IP, settings, etc)
	Model = nil, -- Reference to 3D model Part
}

-- Helper: Get device properties by type
function DeviceTypes:GetProperties(deviceType: string): table?
	return self.Properties[deviceType]
end

-- Helper: Check if type is valid
function DeviceTypes:IsValidType(deviceType: string): boolean
	return self.Properties[deviceType] ~= nil
end

-- Helper: Get all device types
function DeviceTypes:GetAllTypes(): {string}
	local types = {}
	for typeKey, _ in pairs(self.Type) do
		table.insert(types, self.Type[typeKey])
	end
	return types
end

-- Helper: Create new device instance
function DeviceTypes:CreateInstance(deviceType: string, position: Vector3, owner: any): table
	if not self:IsValidType(deviceType) then
		error("Invalid device type: " .. deviceType)
	end

	local properties = self:GetProperties(deviceType)
	
	local instance = {
		ID = game:GetService("HttpService"):GenerateGUID(false), -- Unique ID
		Type = deviceType,
		Owner = owner,
		Position = position,
		Rotation = 0,
		Config = table.clone(properties.DefaultConfig), -- Deep copy of default config
		Model = nil,
	}

	return instance
end

-- Helper: Validate device configuration
function DeviceTypes:ValidateConfig(deviceType: string, config: table): (boolean, string?)
	if not self:IsValidType(deviceType) then
		return false, "Invalid device type"
	end

	-- Check required fields
	if not config.IP then
		return false, "IP address required"
	end

	-- Validate IP address format (simple check)
	if not config.IP:match("^%d+%.%d+%.%d+%.%d+$") then
		return false, "Invalid IP address format"
	end

	return true, nil
end

return DeviceTypes
