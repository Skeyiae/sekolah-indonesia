-- PlacementSystem.luau
-- Handle device placement: ghost model, validation, placement

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local DeviceTypes = require(ReplicatedStorage.Shared.DeviceTypes)
local Remotes = require(ReplicatedStorage.Shared.NetworkRemotes)

local PlacementSystem = {}
PlacementSystem.isPlacing = false
PlacementSystem.currentDeviceType = nil
PlacementSystem.ghostModel = nil
PlacementSystem.placementConnection = nil

-- Helper: Create a ghost model (semi-transparent preview)
local function CreateGhostModel(deviceType: string): Part
	local size = DeviceTypes:GetProperties(deviceType).Size
	local color = DeviceTypes:GetProperties(deviceType).Color

	local ghost = Instance.new("Part")
	ghost.Name = "GhostModel"
	ghost.Shape = Enum.PartType.Block
	ghost.Size = size
	ghost.Color = color
	ghost.Transparency = 0.5
	ghost.CanCollide = false
	ghost.CastShadow = false
	ghost.TopSurface = Enum.SurfaceType.Smooth
	ghost.BottomSurface = Enum.SurfaceType.Smooth

	return ghost
end

-- Helper: Check if placement position is valid
local function IsValidPlacement(position: Vector3): boolean
	-- Check if position is above ground
	if position.Y < 1 then
		return false
	end

	-- Check if position is within arena bounds (roughly)
	local maxDistance = 100
	if position.Magnitude > maxDistance then
		return false
	end

	-- Check if too close to other objects (simple check)
	local region = Region3.new(position - Vector3.new(5, 5, 5), position + Vector3.new(5, 5, 5))
	region = region:ExpandToGrid(4)

	local partsInRegion = workspace:FindPartBoundsInRadius(position, 5)
	for _, part in ipairs(partsInRegion) do
		if part.Name:find("GhostModel") then
			continue
		end
		if part.Parent:IsDescendantOf(Players) then
			continue
		end
		if part:IsDescendantOf(workspace) and part ~= workspace.Baseplate and part.Name ~= "Terrain" then
			return false
		end
	end

	return true
end

-- Start placement mode
function PlacementSystem:StartPlacement(deviceType: string)
	if not DeviceTypes:IsValidType(deviceType) then
		warn("[PlacementSystem] Invalid device type:", deviceType)
		return
	end

	if self.isPlacing then
		self:CancelPlacement()
	end

	self.isPlacing = true
	self.currentDeviceType = deviceType

	-- Create ghost model
	self.ghostModel = CreateGhostModel(deviceType)
	self.ghostModel.Parent = workspace

	-- Connect mouse movement
	self.placementConnection = game:GetService("RunService").RenderStepped:Connect(function()
		if not self.isPlacing or not self.ghostModel then
			return
		end

		local mouse = Players.LocalPlayer:GetMouse()
		local rayOrigin = workspace.CurrentCamera.CFrame.Position
		local rayDirection = (mouse.Hit.Position - rayOrigin).Unit * 1000

		local raycastResult = workspace:FindPartOnRay(Ray.new(rayOrigin, rayDirection))
		if raycastResult and raycastResult.Name ~= "GhostModel" then
			-- Place ghost model at mouse position with Y offset
			local position = mouse.Hit.Position + Vector3.new(0, 2, 0)
			self.ghostModel.Position = position

			-- Update color based on validity
			if IsValidPlacement(position) then
				self.ghostModel.Color = Color3.fromRGB(0, 255, 0) -- Green = valid
			else
				self.ghostModel.Color = Color3.fromRGB(255, 0, 0) -- Red = invalid
			end
		end
	end)

	print("[PlacementSystem] Started placement mode for:", deviceType)
end

-- Cancel placement
function PlacementSystem:CancelPlacement()
	if not self.isPlacing then
		return
	end

	self.isPlacing = false
	self.currentDeviceType = nil

	if self.placementConnection then
		self.placementConnection:Disconnect()
		self.placementConnection = nil
	end

	if self.ghostModel then
		self.ghostModel:Destroy()
		self.ghostModel = nil
	end

	print("[PlacementSystem] Cancelled placement")
end

-- Complete placement
function PlacementSystem:CompleteePlacement(position: Vector3): boolean
	if not self.isPlacing or not self.currentDeviceType then
		return false
	end

	-- Validate placement
	if not IsValidPlacement(position) then
		warn("[PlacementSystem] Invalid placement position")
		return false
	end

	-- Send placement request to server
	Remotes.PlaceDevice:FireServer(self.currentDeviceType, position)

	-- Cancel placement mode
	self:CancelPlacement()

	return true
end

-- Setup input for placement
function PlacementSystem:SetupInputHandlers()
	-- Left click to place
	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then
			return
		end

		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			if self.isPlacing then
				local mouse = Players.LocalPlayer:GetMouse()
				local position = mouse.Hit.Position + Vector3.new(0, 2, 0)
				self:CompleteePlacement(position)
			end
		end

		-- Esc to cancel
		if input.KeyCode == Enum.KeyCode.Escape then
			if self.isPlacing then
				self:CancelPlacement()
			end
		end
	end)
end

-- Initialize
function PlacementSystem:Init()
	self:SetupInputHandlers()
	print("[PlacementSystem] Initialized")
end

return PlacementSystem
