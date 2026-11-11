-- DrawingService.luau
-- Handles drawing replication and validation

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes = require(ReplicatedStorage.Shared.RemoteEvents)
local CanvasService = require(script.Parent.CanvasService)

local DrawingService = {}

function DrawingService:Initialize()
	print("[DrawingService] Initializing...")
	
	-- Handle drawing events
	Remotes.StartDrawing.OnServerEvent:Connect(function(player, canvasId, position, color, size)
		self:OnStartDrawing(player, canvasId, position, color, size)
	end)
	
	Remotes.DrawStroke.OnServerEvent:Connect(function(player, canvasId, position, color, size)
		self:OnDrawStroke(player, canvasId, position, color, size)
	end)
	
	Remotes.EndDrawing.OnServerEvent:Connect(function(player, canvasId)
		self:OnEndDrawing(player, canvasId)
	end)
	
	Remotes.ClearCanvas.OnServerEvent:Connect(function(player, canvasId)
		self:OnClearCanvas(player, canvasId)
	end)
end

function DrawingService:OnStartDrawing(player: Player, canvasId: string, position: Vector2, color: Color3, size: number)
	-- Validate ownership
	if not CanvasService:PlayerOwnsCanvas(player, canvasId) then
		warn("[DrawingService]", player.Name, "tried to draw on canvas they don't own:", canvasId)
		return
	end
	
	-- Replicate to all other clients
	for _, otherPlayer in ipairs(game.Players:GetPlayers()) do
		if otherPlayer ~= player then
			Remotes.StartDrawing:FireClient(otherPlayer, canvasId, position, color, size)
		end
	end
end

function DrawingService:OnDrawStroke(player: Player, canvasId: string, position: Vector2, color: Color3, size: number)
	-- Validate ownership
	if not CanvasService:PlayerOwnsCanvas(player, canvasId) then
		return
	end
	
	-- Replicate to all other clients
	for _, otherPlayer in ipairs(game.Players:GetPlayers()) do
		if otherPlayer ~= player then
			Remotes.DrawStroke:FireClient(otherPlayer, canvasId, position, color, size)
		end
	end
end

function DrawingService:OnEndDrawing(player: Player, canvasId: string)
	-- Validate ownership
	if not CanvasService:PlayerOwnsCanvas(player, canvasId) then
		return
	end
	
	-- Replicate to all other clients
	for _, otherPlayer in ipairs(game.Players:GetPlayers()) do
		if otherPlayer ~= player then
			Remotes.EndDrawing:FireClient(otherPlayer, canvasId)
		end
	end
end

function DrawingService:OnClearCanvas(player: Player, canvasId: string)
	-- Validate ownership
	if not CanvasService:PlayerOwnsCanvas(player, canvasId) then
		warn("[DrawingService]", player.Name, "tried to clear canvas they don't own:", canvasId)
		return
	end
	
	-- Clear the canvas on server
	local canvas = CanvasService.Canvases[canvasId]
	if canvas and canvas.SurfaceGui then
		local drawingFrame = canvas.SurfaceGui:FindFirstChild("DrawingFrame")
		if drawingFrame then
			drawingFrame:ClearAllChildren()
		end
	end
	
	-- Replicate to all clients
	for _, otherPlayer in ipairs(game.Players:GetPlayers()) do
		Remotes.ClearCanvas:FireClient(otherPlayer, canvasId)
	end
	
	print("[DrawingService]", player.Name, "cleared canvas:", canvasId)
end

return DrawingService
