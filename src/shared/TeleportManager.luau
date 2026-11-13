-- TeleportManager.luau
-- Handle teleportation between places

local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

local PlaceConfig = require(script.Parent.PlaceConfig)

local TeleportManager = {}

-- Teleport options with GUI
local teleportOptions = Instance.new("TeleportOptions")
teleportOptions.ShouldReserveServer = false

-- Teleport a player to another place
function TeleportManager:TeleportToPlace(player: Player, placeId: number, teleportData: {any}?)
	if placeId == 0 then
		warn("[TeleportManager] Invalid Place ID! Please update PlaceConfig.")
		return false
	end
	
	-- Set teleport data
	if teleportData then
		teleportOptions:SetTeleportData(teleportData)
	end
	
	local success, errorMessage = pcall(function()
		TeleportService:TeleportAsync(placeId, {player}, teleportOptions)
	end)
	
	if not success then
		warn("[TeleportManager] Teleport failed:", errorMessage)
		return false
	end
	
	print("[TeleportManager]", player.Name, "teleported to place", placeId)
	return true
end

-- Teleport to Lobby
function TeleportManager:ToLobby(player: Player)
	return self:TeleportToPlace(player, PlaceConfig.Places.Lobby)
end

-- Teleport to Quiz
function TeleportManager:ToQuiz(player: Player, quizData: {any}?)
	return self:TeleportToPlace(player, PlaceConfig.Places.Quiz, quizData)
end

-- Teleport to Drawing Studio
function TeleportManager:ToDrawing(player: Player)
	return self:TeleportToPlace(player, PlaceConfig.Places.Drawing)
end

-- Teleport to WinBox Lab
function TeleportManager:ToWinBox(player: Player)
	return self:TeleportToPlace(player, PlaceConfig.Places.WinBox)
end

-- Teleport multiple players (party)
function TeleportManager:TeleportParty(players: {Player}, placeId: number, teleportData: {any}?)
	if placeId == 0 then
		warn("[TeleportManager] Invalid Place ID!")
		return false
	end
	
	if teleportData then
		teleportOptions:SetTeleportData(teleportData)
	end
	
	local success, errorMessage = pcall(function()
		TeleportService:TeleportAsync(placeId, players, teleportOptions)
	end)
	
	if not success then
		warn("[TeleportManager] Party teleport failed:", errorMessage)
		return false
	end
	
	return true
end

-- Get teleport data (data passed from previous place)
function TeleportManager:GetTeleportData(player: Player): any
	local joinData = player:GetJoinData()
	if joinData.TeleportData then
		return joinData.TeleportData
	end
	return nil
end

return TeleportManager
