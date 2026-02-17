function GetGradeFromPercent(percent)
	local grades = {
		{1.00,"☆☆☆☆"},
		{0.99,"☆☆☆"},
		{0.98,"☆☆"},
		{0.96,"☆"},
		{0.94,"S+"},
		{0.92,"S"},
		{0.89,"S-"},
		{0.86,"A+"},
		{0.83,"A"},
		{0.80,"A-"},
		{0.76,"B+"},
		{0.72,"B"},
		{0.68,"B-"},
		{0.64,"C+"},
		{0.60,"C"},
		{0.55,"C-"},
		{0.50,"D+"},
		{-999,"D"},
	}

	if percent >= grades[1][1] then return grades[g][2] end

	for g=1,#grades-1 do
		if percent < grades[g][1] and percent >= grades[g+1][1] then return grades[g+1][2] end
	end

	return "F"
end

return Def.ActorFrame{
	Def.Sprite { Texture = "MusicWheelItem _Song NormalPart" },
	Def.ActorFrame{
		Condition=GAMESTATE:IsHumanPlayer(PLAYER_1),
		Def.BitmapText{
			Font= "Common Normal",
			Text="?",
			InitCommand=function(self)
				self:x(168):y(-8):horizalign(left):zoom(0.75):diffuse(PlayerColor(PLAYER_1)):diffusetopedge(BoostColor(PlayerColor(PLAYER_1),1.5)):strokecolor(BoostColor(PlayerColor(PLAYER_1),0.25))
			end,
			SetCommand=function(self,params)
				if params.Song then
					local steps
					if params.Song == GAMESTATE:GetCurrentSong() then
						steps = GAMESTATE:GetCurrentSteps(PLAYER_1)
					elseif GAMESTATE:GetCurrentSteps(PLAYER_1) then
						local currentDifficulty = GAMESTATE:GetCurrentSteps(PLAYER_1):GetDifficulty()
						local allSteps = params.Song:GetAllSteps()
						for step in ivalues(allSteps) do
							if step:GetDifficulty() == currentDifficulty then steps = step break end
						end
					end
					if steps then
						local profile = PROFILEMAN:GetProfile(PLAYER_1):GetHighScoreListIfExists(params.Song,steps)
						if profile then profile = profile:GetHighScores() end
						if profile and #profile > 0 then
							for place,highscore in pairs(profile) do
								if highscore:GetGrade() == "Grade_Failed" then self:settext("F") break end
								self:settext(GetGradeFromPercent(highscore:GetPercentDP()))
								break
							end
						else
							self:settext("")
						end
					else
						self:settext("")
					end
				else
					self:settext("")
				end
			end
		}
	},
	Def.ActorFrame{
		Condition=GAMESTATE:IsHumanPlayer(PLAYER_2),
		Def.BitmapText{
			Font= "Common Normal",
			InitCommand=function(self)
				self:x(168):y(8):horizalign(left):zoom(0.75):diffuse(PlayerColor(PLAYER_2)):diffusetopedge(BoostColor(PlayerColor(PLAYER_2),1.5)):strokecolor(BoostColor(PlayerColor(PLAYER_2),0.25)):visible(false)
			end,
			SetCommand=function(self,params)
				if params.Song then
					local steps
					if params.Song == GAMESTATE:GetCurrentSong() then
						steps = GAMESTATE:GetCurrentSteps(PLAYER_2)
					elseif GAMESTATE:GetCurrentSteps(PLAYER_2) then
						local currentDifficulty = GAMESTATE:GetCurrentSteps(PLAYER_2):GetDifficulty()
						local allSteps = params.Song:GetAllSteps()
						for step in ivalues(allSteps) do
							if step:GetDifficulty() == currentDifficulty then steps = step break end
						end
					end
					if steps then
						local profile = PROFILEMAN:GetProfile(PLAYER_2):GetHighScoreListIfExists(params.Song,steps)
						if profile then profile = profile:GetHighScores() end
						if profile and #profile > 0 then
							for place,highscore in pairs(profile) do
								if highscore:GetGrade() == "Grade_Failed" then self:settext("F") break end
								self:settext(GetGradeFromPercent(highscore:GetPercentDP()))
								break
							end
						else
							self:settext("")
						end
					else
						self:settext("")
					end
				else
					self:settext("")
				end
			end
		}
	}
}