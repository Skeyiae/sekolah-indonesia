-- CanvasService.luau
-- Handles canvas ownership and claiming

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes = require(ReplicatedStorage.Shared.RemoteEvents)
local Types = require(ReplicatedStorage.Shared.Types)

local CanvasService = {}
CanvasService.Canvases = {} :: {[string]: Types.CanvasData}

-- Initialize canvases in the workspace
function CanvasService:Initialize()
	print("[CanvasService] Initializing canvases...")
	
	-- Find all parts tagged as Canvas or in a specific folder
	local canvasFolder = workspace:FindFirstChild("Canvases")
	if not canvasFolder then
		warn("[CanvasService] No 'Canvases' folder found in workspace!")
		return
	end
	
	for _, part in ipairs(canvasFolder:GetChildren()) do
		if part:IsA("BasePart") then
			self:RegisterCanvas(part)
		end
	end
	
	print("[CanvasService] Initialized", #self.Canvases, "canvases")
end

-- Register a canvas part
function CanvasService:RegisterCanvas(part: BasePart)
	local canvasId = part.Name
	
	-- Create SurfaceGui for drawing
	local surfaceGui = part:FindFirstChild("DrawingSurface")
	if not surfaceGui then
		surfaceGui = Instance.new("SurfaceGui")
		surfaceGui.Name = "DrawingSurface"
		surfaceGui.Face = Enum.NormalId.Front
		surfaceGui.CanvasSize = Vector2.new(1024, 1024)
		surfaceGui.Parent = part
		
		-- Create a Frame to hold drawings
		local drawingFrame = Instance.new("Frame")
		drawingFrame.Name = "DrawingFrame"
		drawingFrame.Size = UDim2.fromScale(1, 1)
		drawingFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		drawingFrame.BorderSizePixel = 0
		drawingFrame.Parent = surfaceGui
	end
	
	-- Create proximity prompt for claiming
	local proximityPrompt = part:FindFirstChild("ClaimPrompt")
	if not proximityPrompt then
		proximityPrompt = Instance.new("ProximityPrompt")
		proximityPrompt.Name = "ClaimPrompt"
		proximityPrompt.ActionText = "Claim Canvas"
		proximityPrompt.ObjectText = "Drawing Canvas"
		proximityPrompt.MaxActivationDistance = 10
		proximityPrompt.Parent = part
	end
	
	self.Canvases[canvasId] = {
		CanvasId = canvasId,
		Owner = nil,
		SurfacePart = part,
		SurfaceGui = surfaceGui,
		LastModified = os.time(),
	}
	
	-- Setup proximity prompt
	proximityPrompt.Triggered:Connect(function(player)
		self:ClaimCanvas(player, canvasId)
	end)
end

-- Claim a canvas
function CanvasService:ClaimCanvas(player: Player, canvasId: string): boolean
	local canvas = self.Canvases[canvasId]
	if not canvas then
		warn("[CanvasService] Canvas not found:", canvasId)
		return false
	end
	
	-- Check if already owned
	if canvas.Owner then
		if canvas.Owner == player then
			print("[CanvasService]", player.Name, "already owns this canvas")
			return true
		else
			warn("[CanvasService] Canvas already claimed by", canvas.Owner.Name)
			return false
		end
	end
	
	-- Claim the canvas
	canvas.Owner = player
	canvas.LastModified = os.time()
	
	-- Update proximity prompt
	local prompt = canvas.SurfacePart:FindFirstChild("ClaimPrompt")
	if prompt then
		prompt.ActionText = "Owned by " .. player.Name
		prompt.Enabled = false
	end
	
	print("[CanvasService]", player.Name, "claimed canvas:", canvasId)
	
	-- Notify all clients
	Remotes.CanvasClaimed:FireAllClients(canvasId, player)
	
	return true
end

-- Unclaim a canvas
function CanvasService:UnclaimCanvas(player: Player, canvasId: string)
	local canvas = self.Canvases[canvasId]
	if not canvas then return end
	
	if canvas.Owner == player then
		canvas.Owner = nil
		
		-- Reset proximity prompt
		local prompt = canvas.SurfacePart:FindFirstChild("ClaimPrompt")
		if prompt then
			prompt.ActionText = "Claim Canvas"
			prompt.Enabled = true
		end
		
		print("[CanvasService]", player.Name, "unclaimed canvas:", canvasId)
		
		-- Notify all clients
		Remotes.CanvasClaimed:FireAllClients(canvasId, nil)
	end
end

-- Check if player owns canvas
function CanvasService:PlayerOwnsCanvas(player: Player, canvasId: string): boolean
	local canvas = self.Canvases[canvasId]
	return canvas and canvas.Owner == player
end

-- Get canvas owner
function CanvasService:GetCanvasOwner(canvasId: string): Player?
	local canvas = self.Canvases[canvasId]
	return canvas and canvas.Owner
end

-- Handle player leaving
function CanvasService:OnPlayerRemoving(player: Player)
	for canvasId, canvas in pairs(self.Canvases) do
		if canvas.Owner == player then
			self:UnclaimCanvas(player, canvasId)
		end
	end
end

return CanvasService
