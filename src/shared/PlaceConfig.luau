-- PlaceConfig.luau
-- Configuration for all places in the game
-- UPDATE THESE AFTER PUBLISHING EACH PLACE!

local PlaceConfig = {}

-- Place IDs (Update after publishing!)
PlaceConfig.Places = {
	Lobby = 0,      -- TODO: Update after publishing lobby
	Quiz = 0,       -- TODO: Update after publishing quiz
	Drawing = 0,    -- TODO: Update after publishing drawing
	WinBox = 0,     -- TODO: Update after publishing winbox (future)
}

-- Place Names
PlaceConfig.PlaceNames = {
	[PlaceConfig.Places.Lobby] = "Lobby",
	[PlaceConfig.Places.Quiz] = "Quiz Arena",
	[PlaceConfig.Places.Drawing] = "Drawing Studio",
	[PlaceConfig.Places.WinBox] = "WinBox Lab",
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
