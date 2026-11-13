-- PlaceConfig.luau
-- Configuration for all places in the game
-- UPDATE THESE AFTER PUBLISHING EACH PLACE!

local PlaceConfig = {}

-- Place IDs (Update after publishing!)
PlaceConfig.Places = {
	Lobby = 84560064741571,      -- Lobby/Hub
	Quiz = 94193728430263,       -- Quiz Area
	Drawing = 89762625143846,    -- Drawing Studio
	WinBox = 83843058248260,     -- Simulation Mikrotik
}

-- Place Names
PlaceConfig.PlaceNames = {
	[PlaceConfig.Places.Lobby] = "Lobby",
	[PlaceConfig.Places.Quiz] = "Quiz Arena",
	[PlaceConfig.Places.Drawing] = "Drawing Studio",
	[PlaceConfig.Places.WinBox] = "Simulation Mikrotik",
}

-- Get current place name
function PlaceConfig:GetCurrentPlaceName()
	local currentPlaceId = game.PlaceId
	return self.PlaceNames[currentPlaceId] or "Unknown Place"
end

-- Check if in specific place
function PlaceConfig:IsInLobby()
	return game.PlaceId == self.Places.Lobby
end

function PlaceConfig:IsInQuiz()
	return game.PlaceId == self.Places.Quiz
end

function PlaceConfig:IsInDrawing()
	return game.PlaceId == self.Places.Drawing
end

return PlaceConfig
