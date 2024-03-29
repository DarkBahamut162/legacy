local courseMode = GAMESTATE:IsCourseMode()

local function GraphDisplay( pn )
	local t = Def.ActorFrame {
		LoadActor( THEME:GetPathG("_GraphDisplay","overlay")) .. {
			InitCommand=function(self) self:y(6) end
		},
		Def.GraphDisplay {
			InitCommand=function(self) self:Load("GraphDisplay") end,
			BeginCommand=function(self)
				local ss = SCREENMAN:GetTopScreen():GetStageStats()
				self:Set( ss, ss:GetPlayerStageStats(pn) )
				self:player( pn )
			end
		}
	}
	return t
end

local function ComboGraph( pn )
	local t = Def.ActorFrame {
		Def.ComboGraph {
			InitCommand=function(self) self:Load("ComboGraph") end,
			BeginCommand=function(self)
				local ss = SCREENMAN:GetTopScreen():GetStageStats()
				self:Set( ss, ss:GetPlayerStageStats(pn) )
				self:player( pn )
			end
		}
	}
	return t
end

local function PercentScore( pn )
	local t = LoadFont("Common normal")..{
		InitCommand=function(self) self:zoom(0.625):shadowlength(1):player(pn) end,
		BeginCommand=function(self) self:playcommand("Set") end,
		SetCommand=function(self)
			local SongOrCourse, StepsOrTrail
			if courseMode then
				SongOrCourse = GAMESTATE:GetCurrentCourse()
				StepsOrTrail = GAMESTATE:GetCurrentTrail(pn)
			else
				SongOrCourse = GAMESTATE:GetCurrentSong()
				StepsOrTrail = GAMESTATE:GetCurrentSteps(pn)
			end
			if SongOrCourse and StepsOrTrail then
				local st = StepsOrTrail:GetStepsType()
				local diff = StepsOrTrail:GetDifficulty()
				local courseType = courseMode and SongOrCourse:GetCourseType() or nil
				local cd = GetCustomDifficulty(st, diff, courseType)
				self:diffuse(CustomDifficultyToColor(cd))
				self:shadowcolor(CustomDifficultyToDarkColor(cd))
			end

			local pss = STATSMAN:GetPlayedStageStats(1):GetPlayerStageStats(pn)
			if pss then
				local pct = pss:GetPercentDancePoints()
				if pct == 1 then
					self:settext("100%")
				else
					self:settext(FormatPercentScore(pct))
				end
			end
		end
	}
	return t
end

local t = LoadFallbackB()

if ShowStandardDecoration("GraphDisplay") and GAMESTATE:GetPlayMode() ~= "PlayMode_Rave" then
	for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
		t[#t+1] = StandardDecorationFromTable( "GraphDisplay" .. ToEnumShortString(pn), GraphDisplay(pn) )
	end
end

if ShowStandardDecoration("ComboGraph") and GAMESTATE:GetPlayMode() ~= "PlayMode_Rave" then
	for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
		t[#t+1] = StandardDecorationFromTable( "ComboGraph" .. ToEnumShortString(pn), ComboGraph(pn) )
	end
end

if ShowStandardDecoration("StepsDisplay") then
	for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
		local t2 = Def.StepsDisplay {
			InitCommand=function(self) self:Load("StepsDisplayEvaluation",pn):SetFromGameState(pn) end,
			UpdateNetEvalStatsMessageCommand=function(self,param)
				if GAMESTATE:IsPlayerEnabled(pn) then
					self:SetFromSteps(param.Steps)
				end
			end
		}
		t[#t+1] = StandardDecorationFromTable( "StepsDisplay" .. ToEnumShortString(pn), t2 )
		t[#t+1] = StandardDecorationFromTable( "PercentScore" .. ToEnumShortString(pn), PercentScore(pn) )
	end
end

for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
	local MetricsName = "MachineRecord" .. PlayerNumberToString(pn)
	t[#t+1] = LoadActor( THEME:GetPathG(Var "LoadingScreen", "MachineRecord"), pn ) .. {
		InitCommand=function(self)
			self:player(pn)
			self:name(MetricsName)
			ActorUtil.LoadAllCommandsAndSetXY(self,Var "LoadingScreen")
		end
	}
end

for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
	local MetricsName = "PersonalRecord" .. PlayerNumberToString(pn)
	t[#t+1] = LoadActor( THEME:GetPathG(Var "LoadingScreen", "PersonalRecord"), pn ) .. {
		InitCommand=function(self)
			self:player(pn)
			self:name(MetricsName)
			ActorUtil.LoadAllCommandsAndSetXY(self,Var "LoadingScreen")
		end
	}
end

for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
	local MetricsName = "StageAward" .. PlayerNumberToString(pn)
	t[#t+1] = LoadActor( THEME:GetPathG(Var "LoadingScreen", "StageAward"), pn ) .. {
		InitCommand=function(self)
			self:player(pn)
			self:name(MetricsName)
			ActorUtil.LoadAllCommandsAndSetXY(self,Var "LoadingScreen")
		end,
		BeginCommand=function(self) self:playcommand("Set") end,
		SetCommand=function(self)
			local award = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn):GetStageAward()
			if award then
				self:settext( THEME:GetString( "StageAward", ToEnumShortString( award ) ) )
			else
				self:settext( "" )
			end
		end
	}
end

for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
	local MetricsName = "PeakComboAward" .. PlayerNumberToString(pn)
	t[#t+1] = LoadActor( THEME:GetPathG(Var "LoadingScreen", "PeakComboAward"), pn ) .. {
		InitCommand=function(self)
			self:player(pn)
			self:name(MetricsName)
			ActorUtil.LoadAllCommandsAndSetXY(self,Var "LoadingScreen")
		end,
		BeginCommand=function(self) self:playcommand("Set") end,
		SetCommand=function(self)
			local award = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn):GetPeakComboAward()
			if award then
				self:settext( THEME:GetString( "PeakComboAward", ToEnumShortString( award ) ) )
			else
				self:settext( "" )
			end
		end
	}
end

t[#t+1] = StandardDecorationFromFileOptional("SongInformation","SongInformation") .. {
	BeginCommand=function(self)
		local SongOrCourse
		if GAMESTATE:GetCurrentSong() then
			SongOrCourse = GAMESTATE:GetCurrentSong()
		elseif GAMESTATE:GetCurrentCourse() then
			SongOrCourse = GAMESTATE:GetCurrentCourse()
		else
			return
		end

		if SongOrCourse:HasBanner() then
			self:visible(false)
		else
			self:visible(true)
		end
	end,
	SetCommand=function(self)
		local c = self:GetChildren()
		local SongOrCourse
		if GAMESTATE:GetCurrentSong() then
			SongOrCourse = GAMESTATE:GetCurrentSong()

			c.TextTitle:settext( SongOrCourse:GetDisplayMainTitle() or nil )
			c.TextSubtitle:settext( SongOrCourse:GetDisplaySubTitle() or nil )
			c.TextArtist:settext( SongOrCourse:GetDisplayArtist() or nil )

			if SongOrCourse:GetDisplaySubTitle() == "" then
				c.TextTitle:visible(true)
				c.TextTitle:y(-16.5/2)
				c.TextSubtitle:visible(false)
				c.TextSubtitle:y(0)
				c.TextArtist:visible(true)
				c.TextArtist:y(18/2)
			else
				c.TextTitle:visible(true)
				c.TextTitle:y(-16.5)
				c.TextSubtitle:visible(true)
				c.TextSubtitle:y(0)
				c.TextArtist:visible(true)
				c.TextArtist:y(18)
			end
		elseif GAMESTATE:GetCurrentCourse() then
			SongOrCourse = GAMESTATE:GetCurrentCourse()

			c.TextTitle:settext( SongOrCourse:GetDisplayMainTitle() or nil )
			c.TextSubtitle:settext( SongOrCourse:GetDisplaySubTitle() or nil )
			c.TextArtist:settext( SongOrCourse:GetDisplayArtist() or nil )
		else
			SongOrCourse = nil

			c.TextTitle:settext("")
			c.TextSubtitle:settext("")
			c.TextArtist:settext("")

			self:playcommand("Hide")
		end
	end,
	CurrentSongChangedMessageCommand=function(self) if not courseMode then self:playcommand("Set") end end,
	CurrentCourseChangedMessageCommand=function(self) if courseMode then self:playcommand("Set") end end,
	DisplayLanguageChangedMessageCommand=function(self) self:playcommand("Set") end
}
t[#t+1] = StandardDecorationFromFileOptional("LifeDifficulty","LifeDifficulty")
t[#t+1] = StandardDecorationFromFileOptional("TimingDifficulty","TimingDifficulty")
t[#t+1] = Def.ActorFrame {
	Condition=GAMESTATE:HasEarnedExtraStage() and GAMESTATE:IsExtraStage() and not GAMESTATE:IsExtraStage2(),
	InitCommand=function(self) self:draworder(105) end,
	LoadActor( THEME:GetPathS("ScreenEvaluation","try Extra1" ) ) .. {
		Condition=THEME:GetMetric( Var "LoadingScreen","Summary" ) == false,
		OnCommand=function(self) self:play() end
	},
	LoadActor( THEME:GetPathG("ScreenStageInformation","Stage extra1" ) ) .. {
		Condition=THEME:GetMetric( Var "LoadingScreen","Summary" ) == false,
		InitCommand=function(self) self:Center() end,
		OnCommand=function(self) self:diffusealpha(0):zoom(0.85):bounceend(1):zoom(1):diffusealpha(1):sleep(0):glow(Color("White")):decelerate(1):glow(Color("Invisible")):smooth(0.35):zoom(0.25):y(SCREEN_BOTTOM-72) end
	}
}
t[#t+1] = Def.ActorFrame {
	Condition=GAMESTATE:HasEarnedExtraStage() and not GAMESTATE:IsExtraStage() and GAMESTATE:IsExtraStage2(),
	InitCommand=function(self) self:draworder(105) end,
	LoadActor( THEME:GetPathS("ScreenEvaluation","try Extra2" ) ) .. {
		Condition=THEME:GetMetric( Var "LoadingScreen","Summary" ) == false,
		OnCommand=function(self) self:play() end
	},
	LoadActor( THEME:GetPathG("ScreenStageInformation","Stage extra2" ) ) .. {
		Condition=THEME:GetMetric( Var "LoadingScreen","Summary" ) == false,
		InitCommand=function(self) self:Center() end,
		OnCommand=function(self) self:diffusealpha(0):zoom(0.85):bounceend(1):zoom(1):diffusealpha(1):sleep(0):glow(Color("White")):decelerate(1):glow(Color("Invisible")):smooth(0.35):zoom(0.25):y(SCREEN_BOTTOM-72) end
	}
}
return t