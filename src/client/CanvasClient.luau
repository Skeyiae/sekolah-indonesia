-- CanvasClient.luau
-- Handles canvas claiming and UI

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes = require(ReplicatedStorage.Shared.RemoteEvents)
local DrawingClient = require(script.Parent.DrawingClient)

local CanvasClient = {}
CanvasClient.OwnedCanvas = nil

function CanvasClient:Initialize()
	print("[CanvasClient] Initializing...")
	
	-- Setup UI
	self:CreateUI()
	
	-- Listen for canvas claim updates
	Remotes.CanvasClaimed.OnClientEvent:Connect(function(canvasId, owner)
		self:OnCanvasClaimed(canvasId, owner)
	end)
	
	-- Setup remote drawing
	DrawingClient:SetupRemoteDrawing()
end

-- Create drawing UI
function CanvasClient:CreateUI()
	local player = Players.LocalPlayer
	local playerGui = player:WaitForChild("PlayerGui")
	
	-- Create ScreenGui
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "DrawingUI"
	screenGui.ResetOnSpawn = false
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.Parent = playerGui
	
	-- Main Frame
	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "MainFrame"
	mainFrame.Size = UDim2.new(0, 300, 0, 220)
	mainFrame.Position = UDim2.new(1, -320, 0, 20)
	mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	mainFrame.BorderSizePixel = 0
	mainFrame.Visible = false
	mainFrame.Parent = screenGui
	
	-- Corner
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = mainFrame
	
	-- Title
	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.Size = UDim2.new(1, -20, 0, 30)
	title.Position = UDim2.new(0, 10, 0, 10)
	title.BackgroundTransparency = 1
	title.Text = "Drawing Tools"
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.TextSize = 18
	title.Font = Enum.Font.GothamBold
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = mainFrame
	
	-- Color Palette
	local colorLabel = Instance.new("TextLabel")
	colorLabel.Size = UDim2.new(1, -20, 0, 20)
	colorLabel.Position = UDim2.new(0, 10, 0, 50)
	colorLabel.BackgroundTransparency = 1
	colorLabel.Text = "Color:"
	colorLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
	colorLabel.TextSize = 14
	colorLabel.Font = Enum.Font.Gotham
	colorLabel.TextXAlignment = Enum.TextXAlignment.Left
	colorLabel.Parent = mainFrame
	
	-- Color buttons
	local colors = {
		Color3.fromRGB(0, 0, 0),       -- Black
		Color3.fromRGB(255, 0, 0),     -- Red
		Color3.fromRGB(0, 255, 0),     -- Green
		Color3.fromRGB(0, 0, 255),     -- Blue
		Color3.fromRGB(255, 255, 0),   -- Yellow
		Color3.fromRGB(255, 128, 0),   -- Orange
		Color3.fromRGB(128, 0, 255),   -- Purple
		Color3.fromRGB(255, 255, 255), -- White
	}
	
	for i, color in ipairs(colors) do
		local colorButton = Instance.new("TextButton")
		colorButton.Size = UDim2.new(0, 30, 0, 30)
		colorButton.Position = UDim2.new(0, 10 + (i-1) * 35, 0, 75)
		colorButton.BackgroundColor3 = color
		colorButton.BorderSizePixel = 2
		colorButton.BorderColor3 = Color3.fromRGB(255, 255, 255)
		colorButton.Text = ""
		colorButton.Parent = mainFrame
		
		local buttonCorner = Instance.new("UICorner")
		buttonCorner.CornerRadius = UDim.new(0, 4)
		buttonCorner.Parent = colorButton
		
		colorButton.MouseButton1Click:Connect(function()
			DrawingClient:SetColor(color)
			-- Highlight selected color
			for _, btn in ipairs(mainFrame:GetChildren()) do
				if btn:IsA("TextButton") and btn.BackgroundColor3 == color then
					btn.BorderSizePixel = 3
				elseif btn:IsA("TextButton") then
					btn.BorderSizePixel = 1
				end
			end
		end)
	end
	
	-- Brush Size Slider
	local sizeLabel = Instance.new("TextLabel")
	sizeLabel.Name = "SizeLabel"
	sizeLabel.Size = UDim2.new(1, -20, 0, 20)
	sizeLabel.Position = UDim2.new(0, 10, 0, 115)
	sizeLabel.BackgroundTransparency = 1
	sizeLabel.Text = "Brush Size: 10"
	sizeLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
	sizeLabel.TextSize = 14
	sizeLabel.Font = Enum.Font.Gotham
	sizeLabel.TextXAlignment = Enum.TextXAlignment.Left
	sizeLabel.Parent = mainFrame
	
	-- Slider Background
	local sizeSliderBg = Instance.new("Frame")
	sizeSliderBg.Name = "SliderBg"
	sizeSliderBg.Size = UDim2.new(1, -20, 0, 20)
	sizeSliderBg.Position = UDim2.new(0, 10, 0, 140)
	sizeSliderBg.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	sizeSliderBg.BorderSizePixel = 0
	sizeSliderBg.Parent = mainFrame
	
	local sliderBgCorner = Instance.new("UICorner")
	sliderBgCorner.CornerRadius = UDim.new(0, 10)
	sliderBgCorner.Parent = sizeSliderBg
	
	-- Slider Fill
	local sizeSliderFill = Instance.new("Frame")
	sizeSliderFill.Name = "SliderFill"
	sizeSliderFill.Size = UDim2.new(0.11, 0, 1, 0) -- 10/50 = 0.2 for default size 10
	sizeSliderFill.Position = UDim2.new(0, 0, 0, 0)
	sizeSliderFill.BackgroundColor3 = Color3.fromRGB(80, 200, 255)
	sizeSliderFill.BorderSizePixel = 0
	sizeSliderFill.Parent = sizeSliderBg
	
	local sliderFillCorner = Instance.new("UICorner")
	sliderFillCorner.CornerRadius = UDim.new(0, 10)
	sliderFillCorner.Parent = sizeSliderFill
	
	-- Slider Button (draggable)
	local sliderButton = Instance.new("TextButton")
	sliderButton.Name = "SliderButton"
	sliderButton.Size = UDim2.new(0, 20, 0, 30)
	sliderButton.Position = UDim2.new(0.11, -10, 0.5, -15)
	sliderButton.AnchorPoint = Vector2.new(0, 0.5)
	sliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	sliderButton.Text = ""
	sliderButton.AutoButtonColor = false
	sliderButton.Parent = sizeSliderBg
	
	local sliderButtonCorner = Instance.new("UICorner")
	sliderButtonCorner.CornerRadius = UDim.new(0, 10)
	sliderButtonCorner.Parent = sliderButton
	
	-- Slider functionality
	local UserInputService = game:GetService("UserInputService")
	local dragging = false
	
	sliderButton.MouseButton1Down:Connect(function()
		dragging = true
	end)
	
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)
	
	UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local mousePos = UserInputService:GetMouseLocation()
			local sliderPos = sizeSliderBg.AbsolutePosition.X
			local sliderSize = sizeSliderBg.AbsoluteSize.X
			
			-- Calculate relative position (0-1)
			local relativePos = (mousePos.X - sliderPos) / sliderSize
			relativePos = math.clamp(relativePos, 0, 1)
			
			-- Update slider visual
			sizeSliderFill.Size = UDim2.new(relativePos, 0, 1, 0)
			sliderButton.Position = UDim2.new(relativePos, -10, 0.5, -15)
			
			-- Calculate brush size (5-50 range)
			local brushSize = math.floor(5 + (relativePos * 45))
			DrawingClient:SetBrushSize(brushSize)
			sizeLabel.Text = "Brush Size: " .. brushSize
		end
	end)
	
	-- Click on slider background to jump
	sizeSliderBg.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			local mousePos = UserInputService:GetMouseLocation()
			local sliderPos = sizeSliderBg.AbsolutePosition.X
			local sliderSize = sizeSliderBg.AbsoluteSize.X
			
			local relativePos = (mousePos.X - sliderPos) / sliderSize
			relativePos = math.clamp(relativePos, 0, 1)
			
			sizeSliderFill.Size = UDim2.new(relativePos, 0, 1, 0)
			sliderButton.Position = UDim2.new(relativePos, -10, 0.5, -15)
			
			local brushSize = math.floor(5 + (relativePos * 45))
			DrawingClient:SetBrushSize(brushSize)
			sizeLabel.Text = "Brush Size: " .. brushSize
			
			dragging = true
		end
	end)
	
	-- Clear Button
	local clearButton = Instance.new("TextButton")
	clearButton.Name = "ClearButton"
	clearButton.Size = UDim2.new(1, -20, 0, 35)
	clearButton.Position = UDim2.new(0, 10, 1, -45)
	clearButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
	clearButton.Text = "Clear Canvas"
	clearButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	clearButton.TextSize = 14
	clearButton.Font = Enum.Font.GothamBold
	clearButton.Parent = mainFrame
	
	local clearCorner = Instance.new("UICorner")
	clearCorner.CornerRadius = UDim.new(0, 6)
	clearCorner.Parent = clearButton
	
	clearButton.MouseButton1Click:Connect(function()
		if self.OwnedCanvas then
			DrawingClient:ClearCanvas()
		end
	end)
	
	self.UI = {
		ScreenGui = screenGui,
		MainFrame = mainFrame,
		SizeLabel = sizeLabel,
	}
end

-- Show/hide UI
function CanvasClient:ShowUI(show: boolean)
	if self.UI and self.UI.MainFrame then
		self.UI.MainFrame.Visible = show
	end
end

-- Handle canvas claimed
function CanvasClient:OnCanvasClaimed(canvasId: string, owner: Player?)
	local player = Players.LocalPlayer
	
	if owner == player then
		-- Player claimed a canvas
		self.OwnedCanvas = canvasId
		self:ShowUI(true)
		
		-- Find the canvas and start drawing
		local canvasFolder = workspace:FindFirstChild("Canvases")
		if canvasFolder then
			local canvasPart = canvasFolder:FindFirstChild(canvasId)
			if canvasPart then
				-- Pass the part itself, not surfaceGui
				DrawingClient:StartDrawing(canvasId, canvasPart)
			end
		end
		
		print("[CanvasClient] You claimed canvas:", canvasId)
	elseif self.OwnedCanvas == canvasId then
		-- Canvas was unclaimed
		self.OwnedCanvas = nil
		self:ShowUI(false)
		DrawingClient:StopDrawing()
		
		print("[CanvasClient] Canvas unclaimed")
	end
end

return CanvasClient
