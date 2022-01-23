--[[
OLD STATS
local mainMaxWidth = 228; -- zoom w/subtitle is 0.75 (multiply by 1.25)
local subMaxWidth = 420; -- zoom is 0.6 (multiply zoom,1 value by 1.4)
local artistMaxWidth = 300/0.8;

local mainMaxWidthHighScore = 192; -- zoom w/subtitle is 0.75 (multiply by 1.25)
local subMaxWidthHighScore = 280; -- zoom is 0.6 (multiply zoom,1 value by 1.4)
local artistMaxWidthHighScore = 280/0.8;
]]
local mainMaxWidth = 280;
local subMaxWidth = 448;
local artistMaxWidth = 280;

local mainMaxWidthHighScore = 280;
local subMaxWidthHighScore = 448;
local artistMaxWidthHighScore = 280;

--[[
-- The old (cmd(blah))(Actor) syntax is hard to read.
-- This is longer, but much easier to read. - Colby
--]]
function TextBannerAfterSet(self,param)
	local Title = self:GetChild("Title")
	local Subtitle = self:GetChild("Subtitle")
	local Artist = self:GetChild("Artist")
	
	if Subtitle:GetText() == "" then
		Title:maxwidth(mainMaxWidth)
		Title:y(-9)
		Title:zoom(1)
		
		-- hide so that the game skips drawing.
		Subtitle:visible(false)

		Artist:zoom(0.66)
		Artist:maxwidth(artistMaxWidth/0.66)
		Artist:y(9)
	else
		Title:maxwidth(mainMaxWidth*1.333)
		Title:y(-12)
		Title:zoom(0.75)
		
		-- subtitle below title
		Subtitle:visible(true)
		Subtitle:zoom(0.6)
		Subtitle:y(0)
		Subtitle:maxwidth(subMaxWidth)
		
		Artist:zoom(0.6)
		Artist:maxwidth(artistMaxWidth/0.6)
		Artist:y(12)
	end
end

function TextBannerHighScoreAfterSet(self,param)
	local Title = self:GetChild("Title")
	local Subtitle = self:GetChild("Subtitle")
	local Artist = self:GetChild("Artist")
	
	if Subtitle:GetText() == "" then
		Title:maxwidth(mainMaxWidthHighScore)
		Title:y(-9)
		Title:zoom(1)
		
		-- hide so that the game skips drawing.
		Subtitle:visible(false)

		Artist:zoom(0.66)
		Artist:maxwidth(artistMaxWidthHighScore/0.66)
		Artist:y(9)
	else
		Title:maxwidth(mainMaxWidthHighScore*1.333)
		Title:y(-12)
		Title:zoom(0.75)
		
		-- subtitle below title
		Subtitle:visible(true)
		Subtitle:zoom(0.6)
		Subtitle:y(0)
		Subtitle:maxwidth(subMaxWidthHighScore)
		
		Artist:zoom(0.6)
		Artist:maxwidth(artistMaxWidthHighScore*1.5)
		Artist:y(12)
	end
end
