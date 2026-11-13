-- Quiz Client
print("[Quiz Client] Starting...")

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Wait for modules
repeat task.wait() until ReplicatedStorage:FindFirstChild("Shared")
repeat task.wait() until ReplicatedStorage:FindFirstChild("Remotes")

local PlaceConfig = require(ReplicatedStorage.Shared.PlaceConfig)
local ReturnToLobby = ReplicatedStorage.Remotes:WaitForChild("ReturnToLobby")

-- Create Quiz UI (Placeholder)
local function createQuizUI()
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "QuizUI"
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.Parent = playerGui
	
	-- Title
	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(0, 400, 0, 60)
	title.Position = UDim2.new(0.5, -200, 0, 50)
	title.BackgroundTransparency = 1
	title.Text = "📝 Quiz Arena"
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.TextSize = 36
	title.Font = Enum.Font.GothamBold
	title.TextStrokeTransparency = 0.5
	title.Parent = screenGui
	
	-- Placeholder text
	local placeholder = Instance.new("TextLabel")
	placeholder.Size = UDim2.new(0, 600, 0, 200)
	placeholder.Position = UDim2.new(0.5, -300, 0.5, -100)
	placeholder.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	placeholder.Text = "Quiz system will be implemented here!\n\n(Multiple choice questions, timer, leaderboard, etc.)"
	placeholder.TextColor3 = Color3.fromRGB(255, 255, 255)
	placeholder.TextSize = 20
	placeholder.Font = Enum.Font.Gotham
	placeholder.TextWrapped = true
	placeholder.Parent = screenGui
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = placeholder
	
	-- Return button
	local returnButton = Instance.new("TextButton")
	returnButton.Size = UDim2.new(0, 200, 0, 50)
	returnButton.Position = UDim2.new(0.5, -100, 1, -80)
	returnButton.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
	returnButton.Text = "Return to Lobby"
	returnButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	returnButton.TextSize = 18
	returnButton.Font = Enum.Font.GothamBold
	returnButton.Parent = screenGui
	
	local returnCorner = Instance.new("UICorner")
	returnCorner.CornerRadius = UDim.new(0, 10)
	returnCorner.Parent = returnButton
	
	returnButton.MouseButton1Click:Connect(function()
		returnButton.Text = "Returning..."
		returnButton.Active = false
		ReturnToLobby:FireServer()
	end)
end

createQuizUI()

print("[Quiz Client] Ready!")
