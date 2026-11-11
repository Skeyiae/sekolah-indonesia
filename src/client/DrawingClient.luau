-- DrawingClient.luau
-- Handles smooth mouse drawing on canvas

local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Remotes = require(ReplicatedStorage.Shared.RemoteEvents)

local DrawingClient = {}
DrawingClient.CurrentCanvas = nil
DrawingClient.IsDrawing = false
DrawingClient.CurrentColor = Color3.fromRGB(0, 0, 0) -- Black
DrawingClient.BrushSize = 3
DrawingClient.LastPosition = nil

-- Start drawing on a canvas
function DrawingClient:StartDrawing(canvasId: string, surfaceGui: SurfaceGui)
	self.CurrentCanvas = {
		Id = canvasId,
		SurfaceGui = surfaceGui,
		DrawingFrame = surfaceGui:FindFirstChild("DrawingFrame"),
	}
	
	if not self.CurrentCanvas.DrawingFrame then
		warn("[DrawingClient] No DrawingFrame found!")
		return
	end
	
	self.IsDrawing = false
	self.LastPosition = nil
	
	-- Connect input events
	self:ConnectInputEvents()
	
	print("[DrawingClient] Started drawing on canvas:", canvasId)
end

-- Stop drawing
function DrawingClient:StopDrawing()
	self.CurrentCanvas = nil
	self.IsDrawing = false
	self.LastPosition = nil
	print("[DrawingClient] Stopped drawing")
end

-- Connect mouse/touch input
function DrawingClient:ConnectInputEvents()
	local mouse = Players.LocalPlayer:GetMouse()
	
	-- Mouse down - start drawing
	mouse.Button1Down:Connect(function()
		if not self.CurrentCanvas then return end
		
		local position = self:GetCanvasPosition(mouse)
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
		if not self.IsDrawing or not self.CurrentCanvas then return end
		
		local position = self:GetCanvasPosition(mouse)
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

-- Get position on canvas from mouse
function DrawingClient:GetCanvasPosition(mouse): Vector2?
	if not self.CurrentCanvas then return nil end
	
	local surfaceGui = self.CurrentCanvas.SurfaceGui
	local drawingFrame = self.CurrentCanvas.DrawingFrame
	
	-- Check if mouse is over the canvas
	local target = mouse.Target
	if not target or target ~= surfaceGui.Parent then
		return nil
	end
	
	-- Get mouse position relative to canvas
	local guiPosition = drawingFrame.AbsolutePosition
	local guiSize = drawingFrame.AbsoluteSize
	
	local relativeX = (mouse.X - guiPosition.X) / guiSize.X
	local relativeY = (mouse.Y - guiPosition.Y) / guiSize.Y
	
	-- Clamp to 0-1
	relativeX = math.clamp(relativeX, 0, 1)
	relativeY = math.clamp(relativeY, 0, 1)
	
	return Vector2.new(relativeX, relativeY)
end

-- Draw a single point
function DrawingClient:DrawPoint(position: Vector2, color: Color3, size: number)
	if not self.CurrentCanvas then return end
	
	local frame = Instance.new("Frame")
	frame.Size = UDim2.fromOffset(size, size)
	frame.Position = UDim2.fromScale(position.X, position.Y)
	frame.AnchorPoint = Vector2.new(0.5, 0.5)
	frame.BackgroundColor3 = color
	frame.BorderSizePixel = 0
	frame.ZIndex = 2
	frame.Parent = self.CurrentCanvas.DrawingFrame
	
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
	if not self.CurrentCanvas then return end
	
	self.CurrentCanvas.DrawingFrame:ClearAllChildren()
	Remotes.ClearCanvas:FireServer(self.CurrentCanvas.Id)
	
	print("[DrawingClient] Cleared canvas")
end

-- Change draw color
function DrawingClient:SetColor(color: Color3)
	self.CurrentColor = color
	print("[DrawingClient] Color changed to:", color)
end

-- Change brush size
function DrawingClient:SetBrushSize(size: number)
	self.BrushSize = math.clamp(size, 1, 20)
	print("[DrawingClient] Brush size changed to:", self.BrushSize)
end

-- Handle remote drawing from other players
function DrawingClient:SetupRemoteDrawing()
	Remotes.StartDrawing.OnClientEvent:Connect(function(canvasId, position, color, size)
		-- Find the canvas
		local canvasFolder = workspace:FindFirstChild("Canvases")
		if not canvasFolder then return end
		
		local canvasPart = canvasFolder:FindFirstChild(canvasId)
		if not canvasPart then return end
		
		local surfaceGui = canvasPart:FindFirstChild("DrawingSurface")
		if not surfaceGui then return end
		
		local drawingFrame = surfaceGui:FindFirstChild("DrawingFrame")
		if not drawingFrame then return end
		
		-- Draw the point
		self:DrawPointOnFrame(drawingFrame, position, color, size)
	end)
	
	Remotes.DrawStroke.OnClientEvent:Connect(function(canvasId, position, color, size)
		local canvasFolder = workspace:FindFirstChild("Canvases")
		if not canvasFolder then return end
		
		local canvasPart = canvasFolder:FindFirstChild(canvasId)
		if not canvasPart then return end
		
		local surfaceGui = canvasPart:FindFirstChild("DrawingSurface")
		if not surfaceGui then return end
		
		local drawingFrame = surfaceGui:FindFirstChild("DrawingFrame")
		if not drawingFrame then return end
		
		self:DrawPointOnFrame(drawingFrame, position, color, size)
	end)
	
	Remotes.ClearCanvas.OnClientEvent:Connect(function(canvasId)
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
	end)
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
