local t = LoadFallbackB()

local StepsType = ToEnumShortString( GAMEMAN:GetFirstStepsTypeForGame(GAMESTATE:GetCurrentGame()) )
local stString = THEME:GetString("StepsType",StepsType)
local NumColumns = THEME:GetMetric(Var "LoadingScreen", "NumColumns")

t[#t+1] = Def.ActorFrame {
	InitCommand=function(self) self:CenterX():y(SCREEN_CENTER_Y-160) end,
	Def.Quad {
		InitCommand=function(self) self:zoomto(SCREEN_WIDTH, 32) end,
		OnCommand=function(self) self:y(-16):diffuse(Color.Black):fadebottom(0.8) end
	},
	Def.Quad {
		InitCommand=function(self) self:zoomto(SCREEN_WIDTH, 56) end,
		OnCommand=function(self) self:diffuse(color("#333333")):diffusealpha(0.75):fadebottom(0.35) end
	}
}

for i=1,NumColumns do
	local st = THEME:GetMetric(Var "LoadingScreen","ColumnStepsType" .. i)
	local dc = THEME:GetMetric(Var "LoadingScreen","ColumnDifficulty" .. i)
	local s = GetCustomDifficulty( st, dc )

	t[#t+1] = Def.ActorFrame {
		InitCommand=function(self) self:x(SCREEN_CENTER_X-60 + 80 * (i-1)):y(SCREEN_CENTER_Y-168) end,
		LoadActor(THEME:GetPathB("_frame","3x1"),"rounded fill", 18) .. {
			OnCommand=function(self) self:diffuse(CustomDifficultyToDarkColor(s)):diffusealpha(0.5) end
		},
		LoadActor(THEME:GetPathB("_frame","3x1"),"rounded gloss", 18) .. {
			OnCommand=function(self) self:diffuse(CustomDifficultyToColor(s)):diffusealpha(0.125) end
		},
		LoadFont("Common Normal") .. {
			InitCommand=function(self) self:uppercase(true):settext(CustomDifficultyToLocalizedString(s)) end,
			OnCommand=function(self) self:zoom(0.675):maxwidth(80/0.675):diffuse(CustomDifficultyToColor(s)):shadowlength(1) end
		}
	}
end

t[#t+1] = LoadFont("Common Bold") .. {
	InitCommand=function(self) self:settext(stString):x(SCREEN_CENTER_X-220):y(SCREEN_CENTER_Y-168) end,
	OnCommand=function(self) self:skewx(-0.125):diffusebottomedge(color("0.75,0.75,0.75")):shadowlength(2) end
}

t.OnCommand=function(self) self:draworder(105) end

return t