local vStats = STATSMAN:GetCurStageStats()

local function CreateStats( pnPlayer )
	local aLabel = LoadFont("Common Normal") .. { InitCommand=function(self) self:zoom(0.5*WideScreenDiff()):shadowlength(1):horizalign(left) end }
	local aText = LoadFont("Common Normal") .. { InitCommand=function(self) self:zoom(0.5*WideScreenDiff()):shadowlength(1):horizalign(left) end }
	local pnStageStats = vStats:GetPlayerStageStats( pnPlayer )
	local tStats = {
		W1			= pnStageStats:GetTapNoteScores('TapNoteScore_W1'),
		W2			= pnStageStats:GetTapNoteScores('TapNoteScore_W2'),
		W3			= pnStageStats:GetTapNoteScores('TapNoteScore_W3'),
		W4			= pnStageStats:GetTapNoteScores('TapNoteScore_W4'),
		W5			= pnStageStats:GetTapNoteScores('TapNoteScore_W5'),
		Miss		= pnStageStats:GetTapNoteScores('TapNoteScore_Miss'),
		HitMine		= pnStageStats:GetTapNoteScores('TapNoteScore_HitMine'),
		AvoidMine	= pnStageStats:GetTapNoteScores('TapNoteScore_AvoidMine'),
		Held		= pnStageStats:GetHoldNoteScores('HoldNoteScore_Held'),
		LetGo		= pnStageStats:GetHoldNoteScores('HoldNoteScore_LetGo')
	}
	local tValues = {
		ITG			= ( tStats["W1"]*7 + tStats["W2"]*6 + tStats["W3"]*5 + tStats["W4"]*4 + tStats["W5"]*2 + tStats["Held"]*7 ),
		ITG_MAX		= ( tStats["W1"] + tStats["W2"] + tStats["W3"] + tStats["W4"] + tStats["W5"] + tStats["Miss"] + tStats["Held"] + tStats["LetGo"] )*7,
		MIGS		= ( tStats["W1"]*3 + tStats["W2"]*2 + tStats["W3"] - tStats["W5"]*4 - tStats["Miss"]*8 + tStats["Held"]*6 ),
		MIGS_MAX	= ( (tStats["W1"] + tStats["W2"] + tStats["W3"] + tStats["W4"] + tStats["W5"] + tStats["Miss"])*3 + (tStats["Held"] + tStats["LetGo"])*6 ),
	}

	local t = Def.ActorFrame {}
	t[#t+1] = Def.ActorFrame {
		InitCommand=function(self) self:y(-34*WideScreenDiff()) end,
		LoadActor(THEME:GetPathG("ScreenTitleMenu","PreferenceFrame")) .. {
			InitCommand=function(self) self:zoom(0.875*WideScreenDiff()):diffuse(PlayerColor( pnPlayer )) end
		},
		aLabel .. { Text=THEME:GetString("ScreenEvaluation","ITG DP:"), InitCommand=function(self) self:x(-64*WideScreenDiff()) end },
		aText .. { Text=string.format("%04i",tValues["ITG"]), InitCommand=function(self) self:x(-8*WideScreenDiff()):y(5*WideScreenDiff()):vertalign(bottom):zoom(0.6*WideScreenDiff()):maxwidth(60) end},
		aText .. { Text="/", InitCommand=function(self) self:x(28*WideScreenDiff()):y(5*WideScreenDiff()):vertalign(bottom):zoom(0.5*WideScreenDiff()):diffusealpha(0.5) end },
		aText .. { Text=string.format("%04i",tValues["ITG_MAX"]), InitCommand=function(self) self:x(32*WideScreenDiff()):y(5*WideScreenDiff()):vertalign(bottom):zoom(0.5*WideScreenDiff()):maxwidth(60) end }
	}
	t[#t+1] = Def.ActorFrame {
		InitCommand=function(self) self:y(-6*WideScreenDiff()) end,
		LoadActor(THEME:GetPathG("ScreenTitleMenu","PreferenceFrame")) .. {
			InitCommand=function(self) self:zoom(0.875*WideScreenDiff()):diffuse(PlayerColor( pnPlayer )) end
		},
		aLabel .. { Text=THEME:GetString("ScreenEvaluation","MIGS DP:"), InitCommand=function(self) self:x(-64*WideScreenDiff()) end },
		aText .. { Text=string.format("%04i",tValues["MIGS"]), InitCommand=function(self) self:x(-8*WideScreenDiff()):y(5*WideScreenDiff()):vertalign(bottom):zoom(0.6*WideScreenDiff()):maxwidth(60) end },
		aText .. { Text="/", InitCommand=function(self) self:x(28*WideScreenDiff()):y(5*WideScreenDiff()):vertalign(bottom):zoom(0.5*WideScreenDiff()):diffusealpha(0.5) end },
		aText .. { Text=string.format("%04i",tValues["MIGS_MAX"]), InitCommand=function(self) self:x(32*WideScreenDiff()):y(5*WideScreenDiff()):vertalign(bottom):zoom(0.5*WideScreenDiff()):maxwidth(60) end }
	}
	return t
end

local t = Def.ActorFrame {}
GAMESTATE:IsPlayerEnabled(PLAYER_1)
t[#t+1] = Def.ActorFrame {
	InitCommand=function(self) self:hide_if(not GAMESTATE:IsPlayerEnabled(PLAYER_1)):x(WideScaleFixed(math.floor(SCREEN_CENTER_X*0.3/WideScreenDiff()/WideScreenDiff()),math.floor(SCREEN_CENTER_X*0.5/WideScreenDiff()/WideScreenDiff()))-8*WideScreenDiff()):y(SCREEN_CENTER_Y-20*WideScreenDiff()) end,
	CreateStats( PLAYER_1 )
}
t[#t+1] = Def.ActorFrame {
	InitCommand=function(self) self:hide_if(not GAMESTATE:IsPlayerEnabled(PLAYER_2)):x(WideScaleFixed(math.floor(SCREEN_CENTER_X*1.7/WideScreenDiff()/WideScreenDiff()),math.floor(SCREEN_CENTER_X*1.5/WideScreenDiff()/WideScreenDiff()))+8*WideScreenDiff()):y(SCREEN_CENTER_Y-20*WideScreenDiff()) end,
	CreateStats( PLAYER_2 )
}

return t