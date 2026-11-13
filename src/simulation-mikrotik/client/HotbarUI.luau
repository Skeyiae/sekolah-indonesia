-- HotbarUI.luau
-- Bottom screen hotbar UI showing available devices

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local DeviceTypes = require(ReplicatedStorage.Shared.DeviceTypes)

local HotbarUI = {}
HotbarUI.screenGui = nil
HotbarUI.buttons = {}
HotbarUI.onDeviceSelected = nil -- Callback when device button clicked

-- Device order in hotbar
local DEVICE_ORDER = {
	DeviceTypes.Type.PC,
	DeviceTypes.Type.Switch,
	DeviceTypes.Type.Router,
	DeviceTypes.Type.Firewall,
	DeviceTypes.Type.AP,
	DeviceTypes.Type.Server,
}

-- Create hotbar UI
function HotbarUI:Create(onDeviceSelectedCallback)
	local player = Players.LocalPlayer
	local playerGui = player:WaitForChild("PlayerGui")

	self.onDeviceSelected = onDeviceSelectedCallback

	-- Create ScreenGui
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "HotbarUI"
	screenGui.ResetOnSpawn = false
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.DisplayOrder = 100
	screenGui.Parent = playerGui

	self.screenGui = screenGui

	-- Create hotbar frame (at bottom)
	local hotbarFrame = Instance.new("Frame")
	hotbarFrame.Name = "HotbarFrame"
	hotbarFrame.Size = UDim2.new(1, 0, 0, 80)
	hotbarFrame.Position = UDim2.new(0, 0, 1, -80)
	hotbarFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	hotbarFrame.BorderSizePixel = 0
	hotbarFrame.Parent = screenGui

	-- Add border at top
	local topBorder = Instance.new("Frame")
	topBorder.Size = UDim2.new(1, 0, 0, 2)
	topBorder.Position = UDim2.new(0, 0, 0, 0)
	topBorder.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
	topBorder.BorderSizePixel = 0
	topBorder.Parent = hotbarFrame

	-- Create horizontal layout for buttons
	local layout = Instance.new("UIListLayout")
	layout.FillDirection = Enum.FillDirection.Horizontal
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	layout.VerticalAlignment = Enum.VerticalAlignment.Center
	layout.Padding = UDim.new(0, 10)
	layout.Parent = hotbarFrame

	-- Add padding
	local padding = Instance.new("UIPadding")
	padding.PaddingLeft = UDim.new(0, 10)
	padding.PaddingRight = UDim.new(0, 10)
	padding.PaddingTop = UDim.new(0, 10)
	padding.PaddingBottom = UDim.new(0, 10)
	padding.Parent = hotbarFrame

	-- Create buttons for each device type
	for _, deviceType in ipairs(DEVICE_ORDER) do
		local props = DeviceTypes:GetProperties(deviceType)

		-- Button
		local button = Instance.new("TextButton")
		button.Name = deviceType .. "Button"
		button.Size = UDim2.new(0, 70, 0, 60)
		button.BackgroundColor3 = props.Color
		button.Text = props.Name
		button.TextColor3 = Color3.fromRGB(255, 255, 255)
		button.TextSize = 12
		button.Font = Enum.Font.GothamBold
		button.AutoButtonColor = true
		button.Parent = hotbarFrame

		-- Round corners
		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 8)
		corner.Parent = button

		-- Hover effects
		button.MouseEnter:Connect(function()
			button.BackgroundTransparency = 0.2
		end)

		button.MouseLeave:Connect(function()
			button.BackgroundTransparency = 0
		end)

		-- Click handler
		button.MouseButton1Click:Connect(function()
			if self.onDeviceSelected then
				self.onDeviceSelected(deviceType)
			end
		end)

		self.buttons[deviceType] = button
	end

	-- Add label
	local label = Instance.new("TextLabel")
	label.Name = "HotbarLabel"
	label.Size = UDim2.new(0, 150, 0, 20)
	label.Position = UDim2.new(0, 10, 0, 10)
	label.BackgroundTransparency = 1
	label.Text = "🛠️ Devices"
	label.TextColor3 = Color3.fromRGB(200, 200, 200)
	label.TextSize = 14
	label.Font = Enum.Font.GothamBold
	label.Parent = hotbarFrame

	print("[HotbarUI] Created")
end

-- Show/hide hotbar
function HotbarUI:SetVisible(visible: boolean)
	if self.screenGui then
		self.screenGui.Enabled = visible
	end
end

-- Highlight button (visual feedback)
function HotbarUI:HighlightButton(deviceType: string)
	for type, button in pairs(self.buttons) do
		if type == deviceType then
			button.BackgroundTransparency = 0.5
			button.BorderSizePixel = 3
			button.BorderColor3 = Color3.fromRGB(255, 255, 255)
		else
			button.BackgroundTransparency = 0
			button.BorderSizePixel = 0
		end
	end
end

-- Clear highlight
function HotbarUI:ClearHighlight()
	for _, button in pairs(self.buttons) do
		button.BackgroundTransparency = 0
		button.BorderSizePixel = 0
	end
end

return HotbarUI
