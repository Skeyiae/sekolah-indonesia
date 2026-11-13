-- Lobby Client
print("[Lobby Client] Starting...")

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Wait for Shared modules
repeat task.wait() until ReplicatedStorage:FindFirstChild("Shared")
repeat task.wait() until ReplicatedStorage:FindFirstChild("Remotes")

local PlaceConfig = require(ReplicatedStorage.Shared.PlaceConfig)
local TeleportRequest = ReplicatedStorage.Remotes:WaitForChild("TeleportRequest")

-- Create Lobby UI
local function createLobbyUI()
	-- Create ScreenGui
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "LobbyUI"
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.ResetOnSpawn = false
	screenGui.Parent = playerGui
	
	-- Title
	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.Size = UDim2.new(0, 600, 0, 80)
	title.Position = UDim2.new(0.5, -300, 0, 30)
	title.BackgroundTransparency = 1
	title.Text = "🏫 Sekolah Indonesia"
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.TextSize = 48
	title.Font = Enum.Font.GothamBold
	title.TextStrokeTransparency = 0.5
	title.Parent = screenGui
	
	-- Subtitle
	local subtitle = Instance.new("TextLabel")
	subtitle.Name = "Subtitle"
	subtitle.Size = UDim2.new(0, 600, 0, 30)
	subtitle.Position = UDim2.new(0.5, -300, 0, 110)
	subtitle.BackgroundTransparency = 1
	subtitle.Text = "Pilih aktivitas yang ingin kamu ikuti"
	subtitle.TextColor3 = Color3.fromRGB(200, 200, 200)
	subtitle.TextSize = 20
	subtitle.Font = Enum.Font.Gotham
	subtitle.Parent = screenGui
	
	-- Container for buttons
	local container = Instance.new("Frame")
	container.Name = "Container"
	container.Size = UDim2.new(0, 900, 0, 300)
	container.Position = UDim2.new(0.5, -450, 0.5, -100)
	container.BackgroundTransparency = 1
	container.Parent = screenGui
	
	local layout = Instance.new("UIGridLayout")
	layout.CellSize = UDim2.new(0, 280, 0, 280)
	layout.CellPadding = UDim2.new(0, 20, 0, 20)
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = container
	
	-- Portal buttons data
	local portals = {
		{
			Name = "Quiz Arena",
			Icon = "📝",
			Description = "Test your knowledge!",
			Destination = "Quiz",
			Color = Color3.fromRGB(52, 152, 219),
			Order = 1
		},
		{
			Name = "Drawing Studio",
			Icon = "🎨",
			Description = "Create amazing art!",
			Destination = "Drawing",
			Color = Color3.fromRGB(155, 89, 182),
			Order = 2
		},
		{
			Name = "WinBox Lab",
			Icon = "🌐",
			Description = "Learn networking!",
			Destination = "WinBox",
			Color = Color3.fromRGB(46, 204, 113),
			Order = 3
		}
	}
	
	-- Create portal buttons
	for _, portalData in ipairs(portals) do
		local button = Instance.new("TextButton")
		button.Name = portalData.Name
		button.LayoutOrder = portalData.Order
		button.BackgroundColor3 = portalData.Color
		button.Text = ""
		button.AutoButtonColor = false
		button.Parent = container
		
		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 16)
		corner.Parent = button
		
		-- Icon
		local icon = Instance.new("TextLabel")
		icon.Size = UDim2.new(1, 0, 0, 80)
		icon.Position = UDim2.new(0, 0, 0, 40)
		icon.BackgroundTransparency = 1
		icon.Text = portalData.Icon
		icon.TextSize = 60
		icon.Font = Enum.Font.Gotham
		icon.Parent = button
		
		-- Name
		local nameLabel = Instance.new("TextLabel")
		nameLabel.Size = UDim2.new(1, -20, 0, 40)
		nameLabel.Position = UDim2.new(0, 10, 0, 130)
		nameLabel.BackgroundTransparency = 1
		nameLabel.Text = portalData.Name
		nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		nameLabel.TextSize = 24
		nameLabel.Font = Enum.Font.GothamBold
		nameLabel.Parent = button
		
		-- Description
		local desc = Instance.new("TextLabel")
		desc.Size = UDim2.new(1, -20, 0, 60)
		desc.Position = UDim2.new(0, 10, 0, 175)
		desc.BackgroundTransparency = 1
		desc.Text = portalData.Description
		desc.TextColor3 = Color3.fromRGB(230, 230, 230)
		desc.TextSize = 16
		desc.Font = Enum.Font.Gotham
		desc.TextWrapped = true
		desc.Parent = button
		
		-- Hover effect
		button.MouseEnter:Connect(function()
			button.BackgroundColor3 = Color3.fromHSV(
				select(1, Color3.toHSV(portalData.Color)),
				select(2, Color3.toHSV(portalData.Color)),
				math.min(select(3, Color3.toHSV(portalData.Color)) * 1.2, 1)
			)
			button.Size = UDim2.fromScale(1.05, 1.05)
		end)
		
		button.MouseLeave:Connect(function()
			button.BackgroundColor3 = portalData.Color
			button.Size = UDim2.fromScale(1, 1)
		end)
		
		-- Click to teleport
		button.MouseButton1Click:Connect(function()
			print("[Lobby Client] Teleporting to:", portalData.Destination)
			
			-- Disable button
			button.Active = false
			nameLabel.Text = "Loading..."
			
			-- Request teleport
			TeleportRequest:FireServer(portalData.Destination)
		end)
	end
	
	print("[Lobby Client] UI Created!")
end

-- Initialize
createLobbyUI()

print("[Lobby Client] Ready!")
