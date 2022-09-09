local mainMaxWidth = 280
local subMaxWidth = 448
local artistMaxWidth = 280

local mainMaxWidthHighScore = 280
local subMaxWidthHighScore = 448
local artistMaxWidthHighScore = 280

function TextBannerAfterSet(self,param)
	local Title = self:GetChild("Title")
	local Subtitle = self:GetChild("Subtitle")
	local Artist = self:GetChild("Artist")

	if Subtitle:GetText() == "" then
		Title:maxwidth(mainMaxWidth)
		Title:y(-9)
		Title:zoom(1)

		Subtitle:visible(false)

		Artist:zoom(0.66)
		Artist:maxwidth(artistMaxWidth/0.66)
		Artist:y(9)
	else
		Title:maxwidth(mainMaxWidth*1.333)
		Title:y(-12)
		Title:zoom(0.75)

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

		Subtitle:visible(false)

		Artist:zoom(0.66)
		Artist:maxwidth(artistMaxWidthHighScore/0.66)
		Artist:y(9)
	else
		Title:maxwidth(mainMaxWidthHighScore*1.333)
		Title:y(-12)
		Title:zoom(0.75)

		Subtitle:visible(true)
		Subtitle:zoom(0.6)
		Subtitle:y(0)
		Subtitle:maxwidth(subMaxWidthHighScore)

		Artist:zoom(0.6)
		Artist:maxwidth(artistMaxWidthHighScore*1.5)
		Artist:y(12)
	end
end
