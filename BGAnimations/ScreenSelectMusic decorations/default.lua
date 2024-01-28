local t = LoadFallbackB()
local courseMode = GAMESTATE:IsCourseMode()

local function StepsDisplay(pn)
	local function set(self, player)
		self:SetFromGameState( player )
	end

	local t = Def.StepsDisplay {
		InitCommand=function(self) self:Load("StepsDisplay",GAMESTATE:GetPlayerState(pn)) end
	}

	if pn == PLAYER_1 then
		t.CurrentStepsP1ChangedMessageCommand=function(self) if not courseMode then set(self, pn) end end
		t.CurrentTrailP1ChangedMessageCommand=function(self) if courseMode then set(self, pn) end end
	else
		t.CurrentStepsP2ChangedMessageCommand=function(self) if not courseMode then set(self, pn) end end
		t.CurrentTrailP2ChangedMessageCommand=function(self) if courseMode then set(self, pn) end end
	end

	return t
end

t[#t+1] = StandardDecorationFromFileOptional("AlternateHelpDisplay","AlternateHelpDisplay")

local function PercentScore(pn)
	local t = LoadFont("Common normal")..{
		InitCommand=function(self) self:zoom(0.625):shadowlength(1) end,
		BeginCommand=function(self) self:playcommand("Set") end,
		SetCommand=function(self)
			local SongOrCourse, StepsOrTrail
			if GAMESTATE:IsCourseMode() then
				SongOrCourse = GAMESTATE:GetCurrentCourse()
				StepsOrTrail = GAMESTATE:GetCurrentTrail(pn)
			else
				SongOrCourse = GAMESTATE:GetCurrentSong()
				StepsOrTrail = GAMESTATE:GetCurrentSteps(pn)
			end

			local profile, scorelist
			local text = ""

			if SongOrCourse and StepsOrTrail then
				local st = StepsOrTrail:GetStepsType()
				local diff = StepsOrTrail:GetDifficulty()
				local courseType = GAMESTATE:IsCourseMode() and SongOrCourse:GetCourseType() or nil
				local cd = GetCustomDifficulty(st, diff, courseType)
				self:diffuse(CustomDifficultyToColor(cd))
				self:shadowcolor(CustomDifficultyToDarkColor(cd))

				if PROFILEMAN:IsPersistentProfile(pn) then
					profile = PROFILEMAN:GetProfile(pn)
				else
					profile = PROFILEMAN:GetMachineProfile()
				end

				scorelist = profile:GetHighScoreList(SongOrCourse,StepsOrTrail)
				assert(scorelist)
				local scores = scorelist:GetHighScores()
				local topscore = scores[1]
				if topscore then
					text = string.format("%.2f%%", topscore:GetPercentDP()*100.0)
					if text == "100.00%" then
						text = "100%"
					end
				else
					text = string.format("%.2f%%", 0)
				end
			else
				text = ""
			end
			self:settext(text)
		end,
		CurrentSongChangedMessageCommand=function(self) if not courseMode then self:playcommand("Set") end end,
		CurrentCourseChangedMessageCommand=function(self) if courseMode then self:playcommand("Set") end end
	}

	if pn == PLAYER_1 then
		t.CurrentStepsP1ChangedMessageCommand=function(self) if not courseMode then self:playcommand("Set") end end
		t.CurrentTrailP1ChangedMessageCommand=function(self) if courseMode then self:playcommand("Set") end end
	else
		t.CurrentStepsP2ChangedMessageCommand=function(self) if not courseMode then self:playcommand("Set") end end
		t.CurrentTrailP2ChangedMessageCommand=function(self) if courseMode then self:playcommand("Set") end end
	end

	return t
end

for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
	local MetricsName = "StepsDisplay" .. PlayerNumberToString(pn)
	t[#t+1] = StepsDisplay(pn) .. {
		InitCommand=function(self) self:player(pn):name(MetricsName) ActorUtil.LoadAllCommandsAndSetXY(self,Var "LoadingScreen") end,
		PlayerJoinedMessageCommand=function(self, params)
			if params.Player == pn then
				self:visible(true)
				self:zoom(0):bounceend(0.3):zoom(1)
			end
		end,
		PlayerUnjoinedMessageCommand=function(self, params)
			if params.Player == pn then
				self:visible(true)
				self:bouncebegin(0.3):zoom(0)
			end
		end
	}
	if ShowStandardDecoration("PercentScore"..ToEnumShortString(pn)) then
		t[#t+1] = StandardDecorationFromTable("PercentScore"..ToEnumShortString(pn), PercentScore(pn))
	end
end

t[#t+1] = StandardDecorationFromFileOptional("BannerFrame","BannerFrame")..{
	BeginCommand=function(self) self:playcommand("Set") end,
	SetCommand=function(self)
		if GetSong() then
			local MinSecondsToStep = MinSecondsToStep()
			local firstBeat = GetSong():GetFirstBeat()
			local td = GetSong():GetTimingData()
			local bpm = round(td:GetBPMAtBeat(0),3)
			local trueFirstBeat = math.abs(MinSecondsToStep * (60/bpm)) + firstBeat

			if MinSecondsToStep <= 2 then
				self:diffuse(Color.Black)
			elseif trueFirstBeat < 12 then
				self:diffuse(Color.Red)
			else
				self:diffuse(Color.White)
			end
		else
			self:diffuse(Color.White)
		end
	end,
	CurrentSongChangedMessageCommand=function(self) if not courseMode then self:playcommand("Set") end end,
	CurrentCourseChangedMessageCommand=function(self) if courseMode then self:playcommand("Set") end end
}
t[#t+1] = StandardDecorationFromFileOptional("PaneDisplayFrameP1","PaneDisplayFrame")
t[#t+1] = StandardDecorationFromFileOptional("PaneDisplayFrameP2","PaneDisplayFrame")
t[#t+1] = StandardDecorationFromFileOptional("PaneDisplayTextP1","PaneDisplayTextP1")
t[#t+1] = StandardDecorationFromFileOptional("PaneDisplayTextP2","PaneDisplayTextP2")
t[#t+1] = StandardDecorationFromFileOptional("DifficultyList","DifficultyList")

t[#t+1] = StandardDecorationFromFileOptional("BPMDisplay","BPMDisplay")
t[#t+1] = StandardDecorationFromFileOptional("BPMLabel","BPMLabel")
t[#t+1] = StandardDecorationFromFileOptional("SegmentDisplay","SegmentDisplay")
t[#t+1] = StandardDecorationFromFileOptional("SongTime","SongTime") .. {
	SetCommand=function(self)
		local curSelection = nil
		local length = 0.0
		if GAMESTATE:IsCourseMode() then
			curSelection = GAMESTATE:GetCurrentCourse()
			self:playcommand("Reset")
			if curSelection then
				local trail = GAMESTATE:GetCurrentTrail(GAMESTATE:GetMasterPlayerNumber())
				if trail then
					length = TrailUtil.GetTotalSeconds(trail)
				else
					length = 0.0
				end
			else
				length = 0.0
			end
		else
			curSelection = GAMESTATE:GetCurrentSong()
			self:playcommand("Reset")
			if curSelection then
				length = curSelection:MusicLengthSeconds()
				if curSelection:IsLong() then
					self:playcommand("Long")
				elseif curSelection:IsMarathon() then
					self:playcommand("Marathon")
				else
					self:playcommand("Reset")
				end
			else
				length = 0.0
				self:playcommand("Reset")
			end
		end
		self:settext( SecondsToMSS(length) )
	end,
	CurrentSongChangedMessageCommand=function(self) if not courseMode then self:playcommand("Set") end end,
	CurrentCourseChangedMessageCommand=function(self) if courseMode then self:playcommand("Set") end end,
	CurrentStepsP1ChangedMessageCommand=function(self) if not courseMode then self:playcommand("Set") end end,
	CurrentStepsP2ChangedMessageCommand=function(self) if not courseMode then self:playcommand("Set") end end,
	CurrentTrailP1ChangedMessageCommand=function(self) if courseMode then self:playcommand("Set") end end,
	CurrentTrailP2ChangedMessageCommand=function(self) if courseMode then self:playcommand("Set") end end
}

if not GAMESTATE:IsCourseMode() then
	local function CDTitleUpdate(self)
		local song = GAMESTATE:GetCurrentSong()
		local cdtitle = self:GetChild("CDTitle")
		local height = cdtitle:GetHeight()
		if song then
			if song:HasCDTitle() then
				cdtitle:visible(true)
				cdtitle:Load(song:GetCDTitlePath())
			else
				cdtitle:visible(false)
			end
		else
			cdtitle:visible(false)
		end
		self:zoom(scale(height,32,480,1,32/480))
	end
	t[#t+1] = Def.ActorFrame {
		OnCommand=function(self) self:draworder(105):x(SCREEN_CENTER_X-256):y(SCREEN_CENTER_Y-84):zoom(0):sleep(0.5):decelerate(0.25):zoom(1):SetUpdateFunction(CDTitleUpdate) end,
		OffCommand=function(self) self:bouncebegin(0.15):zoomx(0) end,
		Def.Sprite {
			Name="CDTitle",
			OnCommand=function(self) self:draworder(106):shadowlength(1):zoom(0.75):diffusealpha(1):zoom(0):bounceend(0.35):zoom(0.75):spin():effectperiod(2):effectmagnitude(0,180,0) end,
			BackCullCommand=function(self) self:diffuse(color("0.5,0.5,0.5,1")) end
		}
	}
	t[#t+1] = StandardDecorationFromFileOptional("NewSong","NewSong") .. {
		InitCommand=function(self) self:playcommand("Set") end,
		BeginCommand=function(self) self:playcommand("Set") end,
		CurrentSongChangedMessageCommand=function(self) if not courseMode then self:playcommand("Set") end end,
		SetCommand=function(self)
			local sSong
			if GAMESTATE:GetCurrentSong() then
				if PROFILEMAN:IsSongNew(GAMESTATE:GetCurrentSong()) then
					self:playcommand("Show")
				else
					self:playcommand("Hide")
				end
			else
				self:playcommand("Hide")
			end
		end
	}
end

if GAMESTATE:IsCourseMode() then
	t[#t+1] = Def.ActorFrame {
		Def.Quad {
			InitCommand=function(self) self:x(THEME:GetMetric(Var "LoadingScreen","CourseContentsListX")):y(THEME:GetMetric(Var "LoadingScreen","CourseContentsListY") - 118):zoomto(256+32,192) end,
			OnCommand=function(self) self:diffuse(Color.Green):MaskSource() end
		},
		Def.Quad {
			InitCommand=function(self) self:x(THEME:GetMetric(Var "LoadingScreen","CourseContentsListX")):y(THEME:GetMetric(Var "LoadingScreen","CourseContentsListY") + 186):zoomto(256+32,64) end,
			OnCommand=function(self) self:diffuse(Color.Blue):MaskSource() end
		}
	}
	t[#t+1] = StandardDecorationFromFileOptional("CourseContentsList","CourseContentsList")
	t[#t+1] = StandardDecorationFromFileOptional("NumCourseSongs","NumCourseSongs")..{
		InitCommand=function(self) self:horizalign(right) end,
		SetCommand=function(self)
			local curSelection= nil
			local sAppend = ""
			if GAMESTATE:IsCourseMode() then
				curSelection = GAMESTATE:GetCurrentCourse()
				if curSelection then
					sAppend = (curSelection:GetEstimatedNumStages() == 1) and "Stage" or "Stages"
					self:visible(true)
					self:settext( curSelection:GetEstimatedNumStages() .. " " .. sAppend)
				else
					self:visible(false)
				end
			else
				self:visible(false)
			end
		end,
		CurrentCourseChangedMessageCommand=function(self) if courseMode then self:playcommand("Set") end end
	}
end

t[#t+1] = StandardDecorationFromFileOptional("DifficultyDisplay","DifficultyDisplay")
t[#t+1] = StandardDecorationFromFileOptional("SortOrderFrame","SortOrderFrame")
t[#t+1] = StandardDecorationFromFileOptional("SortOrder","SortOrderText") .. {
	BeginCommand=function(self) self:playcommand("Set") end,
	SortOrderChangedMessageCommand=function(self) self:playcommand("Set") end,
	SetCommand=function(self)
		local s = GAMESTATE:GetSortOrder()
		if s ~= nil then
			local s = SortOrderToLocalizedString( s )
			self:settext( s )
			self:playcommand("Sort")
		else
			return
		end
	end
}

t[#t+1] = StandardDecorationFromFileOptional("SongOptionsFrame","SongOptionsFrame") .. {
	ShowPressStartForOptionsCommand=THEME:GetMetric(Var "LoadingScreen","SongOptionsFrameShowCommand"),
	ShowEnteringOptionsCommand=THEME:GetMetric(Var "LoadingScreen","SongOptionsFrameEnterCommand"),
	HidePressStartForOptionsCommand=THEME:GetMetric(Var "LoadingScreen","SongOptionsFrameHideCommand")
}
t[#t+1] = StandardDecorationFromFileOptional("SongOptions","SongOptionsText") .. {
	ShowPressStartForOptionsCommand=THEME:GetMetric(Var "LoadingScreen","SongOptionsShowCommand"),
	ShowEnteringOptionsCommand=THEME:GetMetric(Var "LoadingScreen","SongOptionsEnterCommand"),
	HidePressStartForOptionsCommand=THEME:GetMetric(Var "LoadingScreen","SongOptionsHideCommand")
}

t[#t+1] = Def.ActorFrame {
	LoadActor(THEME:GetPathS("_switch","up")) .. {
		SelectMenuOpenedMessageCommand=function(self) self:stop():play() end
	},
	LoadActor(THEME:GetPathS("_switch","down")) .. {
		SelectMenuClosedMessageCommand=function(self) self:stop():play() end
	}
}

return t
