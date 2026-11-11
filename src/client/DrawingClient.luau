-- DrawingClient.luau
-- Handles smooth mouse drawing on canvas with 2D camera mode

local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Remotes = require(ReplicatedStorage.Shared.RemoteEvents)

local DrawingClient = {}
DrawingClient.CurrentCanvas = nil
DrawingClient.IsDrawing = false
DrawingClient.CurrentColor = Color3.fromRGB(0, 0, 0) -- Black
DrawingClient.BrushSize = 10
DrawingClient.LastPosition = nil
DrawingClient.CameraConnection = nil
DrawingClient.OriginalCamera = nil
DrawingClient.DrawingScreenGui = nil

-- Start drawing on a canvas (with 2D camera mode)
function DrawingClient:StartDrawing(canvasId: string, canvasPart: BasePart)
	self.CurrentCanvas = {
		Id = canvasId,
		Part = canvasPart,
	}
	
	-- Enter 2D camera mode
	self:EnterCameraMode(canvasPart)
	
	-- Create fullscreen drawing GUI
	self:CreateDrawingScreen()
	
	-- Connect input events
	self:ConnectInputEvents()
	
	print("[DrawingClient] Started drawing on canvas:", canvasId)
end

-- Enter 2D camera mode focused on canvas
function DrawingClient:EnterCameraMode(canvasPart: BasePart)
	local player = Players.LocalPlayer
	local camera = workspace.CurrentCamera
	
	-- Save original camera settings
	self.OriginalCamera = {
		CameraType = camera.CameraType,
		CameraSubject = camera.CameraSubject,
		CFrame = camera.CFrame,
	}
	
	-- Set camera to scriptable
	camera.CameraType = Enum.CameraType.Scriptable
	
	-- Position camera in front of canvas
	local canvasCFrame = canvasPart.CFrame
	local canvasSize = canvasPart.Size
	
	-- Calculate distance to fit canvas in view
	local fov = math.rad(camera.FieldOfView)
	local aspectRatio = camera.ViewportSize.X / camera.ViewportSize.Y
	local maxDimension = math.max(canvasSize.X, canvasSize.Y)
	local distance = (maxDimension / 2) / math.tan(fov / 2) + 5
	
	-- Position camera directly in front
	camera.CFrame = canvasCFrame * CFrame.new(0, 0, distance)
	
	-- Lock camera in place
	self.CameraConnection = RunService.RenderStepped:Connect(function()
		if self.CurrentCanvas then
			camera.CFrame = canvasCFrame * CFrame.new(0, 0, distance)
		end
	end)
	
	print("[DrawingClient] Entered 2D camera mode")
end

-- Exit camera mode and restore original camera
function DrawingClient:ExitCameraMode()
	local camera = workspace.CurrentCamera
	
	-- Disconnect camera lock
	if self.CameraConnection then
		self.CameraConnection:Disconnect()
		self.CameraConnection = nil
	end
	
	-- Restore original camera
	if self.OriginalCamera then
		camera.CameraType = self.OriginalCamera.CameraType
		camera.CameraSubject = self.OriginalCamera.CameraSubject
	end
	
	print("[DrawingClient] Exited 2D camera mode")
end

-- Create fullscreen drawing GUI
function DrawingClient:CreateDrawingScreen()
	local player = Players.LocalPlayer
	local playerGui = player:WaitForChild("PlayerGui")
	
	-- Remove old GUI if exists
	local oldGui = playerGui:FindFirstChild("DrawingScreen")
	if oldGui then
		oldGui:Destroy()
	end
	
	-- Create new ScreenGui
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "DrawingScreen"
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.DisplayOrder = 5
	screenGui.Parent = playerGui
	
	-- Drawing Frame (white background)
	local drawingFrame = Instance.new("Frame")
	drawingFrame.Name = "DrawingFrame"
	drawingFrame.Size = UDim2.fromScale(1, 1)
	drawingFrame.Position = UDim2.fromScale(0, 0)
	drawingFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	drawingFrame.BorderSizePixel = 0
	drawingFrame.ZIndex = 1
	drawingFrame.Parent = screenGui
	
	-- Exit button
	local exitButton = Instance.new("TextButton")
	exitButton.Name = "ExitButton"
	exitButton.Size = UDim2.new(0, 120, 0, 40)
	exitButton.Position = UDim2.new(0, 20, 0, 20)
	exitButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
	exitButton.Text = "Exit Canvas"
	exitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	exitButton.TextSize = 16
	exitButton.Font = Enum.Font.GothamBold
	exitButton.ZIndex = 10
	exitButton.Parent = screenGui
	
	local exitCorner = Instance.new("UICorner")
	exitCorner.CornerRadius = UDim.new(0, 8)
	exitCorner.Parent = exitButton
	
	exitButton.MouseButton1Click:Connect(function()
		self:ExitDrawingMode()
	end)
	
	self.DrawingScreenGui = screenGui
	self.DrawingFrame = drawingFrame
end

-- Exit drawing mode
function DrawingClient:ExitDrawingMode()
	if self.CurrentCanvas then
		-- Notify server to unclaim
		Remotes.UnclaimCanvas:FireServer(self.CurrentCanvas.Id)
	end
end

-- Stop drawing and cleanup
function DrawingClient:StopDrawing()
	-- Exit camera mode
	self:ExitCameraMode()
	
	-- Remove drawing screen
	if self.DrawingScreenGui then
		self.DrawingScreenGui:Destroy()
		self.DrawingScreenGui = nil
	end
	
	self.CurrentCanvas = nil
	self.IsDrawing = false
	self.LastPosition = nil
	self.DrawingFrame = nil
	
	print("[DrawingClient] Stopped drawing")
end

-- Connect mouse/touch input (simplified for 2D)
function DrawingClient:ConnectInputEvents()
	local mouse = Players.LocalPlayer:GetMouse()
	
	-- Mouse down - start drawing
	mouse.Button1Down:Connect(function()
		if not self.CurrentCanvas or not self.DrawingFrame then return end
		
		local position = self:GetCanvasPosition2D(mouse)
		if position then
			self.IsDrawing = true
			self.LastPosition = position
			
			-- Draw locally
			self:DrawPoint(position, self.CurrentColor, self.BrushSize)
			
			-- Send to server
			Remotes.StartDrawing:FireServer(
				self.CurrentCanvas.Id,
				position,
				self.CurrentColor,
				self.BrushSize
			)
		end
	end)
	
	-- Mouse up - stop drawing
	mouse.Button1Up:Connect(function()
		if self.IsDrawing and self.CurrentCanvas then
			self.IsDrawing = false
			self.LastPosition = nil
			
			-- Send to server
			Remotes.EndDrawing:FireServer(self.CurrentCanvas.Id)
		end
	end)
	
	-- Mouse move - draw stroke
	mouse.Move:Connect(function()
		if not self.IsDrawing or not self.CurrentCanvas or not self.DrawingFrame then return end
		
		local position = self:GetCanvasPosition2D(mouse)
		if position and self.LastPosition then
			-- Smooth line between last position and current
			self:DrawLine(self.LastPosition, position, self.CurrentColor, self.BrushSize)
			
			-- Send to server
			Remotes.DrawStroke:FireServer(
				self.CurrentCanvas.Id,
				position,
				self.CurrentColor,
				self.BrushSize
			)
			
			self.LastPosition = position
		end
	end)
end

-- Get position on canvas from mouse (2D screen coordinates)
function DrawingClient:GetCanvasPosition2D(mouse): Vector2?
	if not self.DrawingFrame then return nil end
	
	-- Get mouse position relative to drawing frame
	local framePos = self.DrawingFrame.AbsolutePosition
	local frameSize = self.DrawingFrame.AbsoluteSize
	
	local relativeX = (mouse.X - framePos.X) / frameSize.X
	local relativeY = (mouse.Y - framePos.Y) / frameSize.Y
	
	-- Clamp to 0-1
	relativeX = math.clamp(relativeX, 0, 1)
	relativeY = math.clamp(relativeY, 0, 1)
	
	return Vector2.new(relativeX, relativeY)
end

-- Draw a single point
function DrawingClient:DrawPoint(position: Vector2, color: Color3, size: number)
	if not self.DrawingFrame then return end
	
	local frame = Instance.new("Frame")
	frame.Size = UDim2.fromOffset(size, size)
	frame.Position = UDim2.fromScale(position.X, position.Y)
	frame.AnchorPoint = Vector2.new(0.5, 0.5)
	frame.BackgroundColor3 = color
	frame.BorderSizePixel = 0
	frame.ZIndex = 2
	frame.Parent = self.DrawingFrame
	
	-- Make it circular
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(1, 0)
	corner.Parent = frame
end

-- Draw smooth line between two points
function DrawingClient:DrawLine(startPos: Vector2, endPos: Vector2, color: Color3, size: number)
	-- Interpolate points for smooth line
	local distance = (endPos - startPos).Magnitude
	local steps = math.max(math.floor(distance * 100), 1) -- More steps = smoother
	
	for i = 0, steps do
		local alpha = i / steps
		local interpPos = startPos:Lerp(endPos, alpha)
		self:DrawPoint(interpPos, color, size)
	end
end

-- Clear canvas
function DrawingClient:ClearCanvas()
	if not self.DrawingFrame then return end
	
	self.DrawingFrame:ClearAllChildren()
	
	if self.CurrentCanvas then
		Remotes.ClearCanvas:FireServer(self.CurrentCanvas.Id)
	end
	
	print("[DrawingClient] Cleared canvas")
end

-- Change draw color
function DrawingClient:SetColor(color: Color3)
	self.CurrentColor = color
	print("[DrawingClient] Color changed to:", color)
end

-- Change brush size
function DrawingClient:SetBrushSize(size: number)
	self.BrushSize = math.clamp(size, 5, 50) -- Increased range
	print("[DrawingClient] Brush size changed to:", self.BrushSize)
end

-- Handle remote drawing from other players
function DrawingClient:SetupRemoteDrawing()
	Remotes.StartDrawing.OnClientEvent:Connect(function(canvasId, position, color, size)
		-- Draw on SurfaceGui for spectators
		self:DrawOnSurfaceGui(canvasId, position, color, size)
	end)
	
	Remotes.DrawStroke.OnClientEvent:Connect(function(canvasId, position, color, size)
		-- Draw on SurfaceGui for spectators
		self:DrawOnSurfaceGui(canvasId, position, color, size)
	end)
	
	Remotes.ClearCanvas.OnClientEvent:Connect(function(canvasId)
		-- Clear SurfaceGui for spectators
		self:ClearSurfaceGui(canvasId)
	end)
end

-- Draw on SurfaceGui (for other players viewing from outside)
function DrawingClient:DrawOnSurfaceGui(canvasId: string, position: Vector2, color: Color3, size: number)
	local canvasFolder = workspace:FindFirstChild("Canvases")
	if not canvasFolder then return end
	
	local canvasPart = canvasFolder:FindFirstChild(canvasId)
	if not canvasPart then return end
	
	local surfaceGui = canvasPart:FindFirstChild("DrawingSurface")
	if not surfaceGui then return end
	
	local drawingFrame = surfaceGui:FindFirstChild("DrawingFrame")
	if not drawingFrame then return end
	
	self:DrawPointOnFrame(drawingFrame, position, color, size)
end

-- Clear SurfaceGui
function DrawingClient:ClearSurfaceGui(canvasId: string)
	local canvasFolder = workspace:FindFirstChild("Canvases")
	if not canvasFolder then return end
	
	local canvasPart = canvasFolder:FindFirstChild(canvasId)
	if not canvasPart then return end
	
	local surfaceGui = canvasPart:FindFirstChild("DrawingSurface")
	if not surfaceGui then return end
	
	local drawingFrame = surfaceGui:FindFirstChild("DrawingFrame")
	if drawingFrame then
		drawingFrame:ClearAllChildren()
	end
end

-- Helper to draw on specific frame
function DrawingClient:DrawPointOnFrame(frame: Frame, position: Vector2, color: Color3, size: number)
	local point = Instance.new("Frame")
	point.Size = UDim2.fromOffset(size, size)
	point.Position = UDim2.fromScale(position.X, position.Y)
	point.AnchorPoint = Vector2.new(0.5, 0.5)
	point.BackgroundColor3 = color
	point.BorderSizePixel = 0
	point.ZIndex = 2
	point.Parent = frame
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(1, 0)
	corner.Parent = point
end

return DrawingClient
