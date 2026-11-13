-- DeviceRaycast.luau
-- Handle clicking on placed devices for interaction

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local DeviceRaycast = {}
DeviceRaycast.onDeviceClicked = nil -- Callback when device clicked
DeviceRaycast.deviceModels = {} -- Track which parts are devices {part: deviceID}

-- Register a device model
function DeviceRaycast:RegisterDevice(part: Part, deviceID: string)
	self.deviceModels[part] = deviceID
	print("[DeviceRaycast] Registered device:", deviceID)
end

-- Unregister a device model
function DeviceRaycast:UnregisterDevice(part: Part)
	self.deviceModels[part] = nil
end

-- Setup input handlers
function DeviceRaycast:SetupInputHandlers()
	local mouse = Players.LocalPlayer:GetMouse()

	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then
			return
		end

		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			-- Try to click a device
			local target = mouse.Target

			if target and self.deviceModels[target] then
				local deviceID = self.deviceModels[target]
				if self.onDeviceClicked then
					self.onDeviceClicked(deviceID)
				end
			end
		end
	end)
end

-- Initialize
function DeviceRaycast:Init()
	self:SetupInputHandlers()
	print("[DeviceRaycast] Initialized")
end

return DeviceRaycast
