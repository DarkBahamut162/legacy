local maxSegments = 150

local function CreateSegments(Player)
	local t = Def.ActorFrame { }
	local bars = Def.ActorFrame{ Name="CoverBars" }
	local bpmFrame = Def.ActorFrame{ Name="BPMFrame" }
	local stopFrame = Def.ActorFrame{ Name="StopFrame" }
	local delayFrame = Def.ActorFrame{ Name="DelayFrame" }
	local warpFrame = Def.ActorFrame{ Name="WarpFrame" }
	local fakeFrame = Def.ActorFrame{ Name="FakeFrame" }
	local scrollFrame = Def.ActorFrame{ Name="ScrollFrame" }
	local speedFrame = Def.ActorFrame{ Name="SpeedFrame" }

	local fFrameWidth = 380
	local fFrameHeight = 8
	if not GAMESTATE:IsCourseMode() then
		local song = GAMESTATE:GetCurrentSong()
		local timingData = song:GetTimingData()
		if song then
			local songLen = song:MusicLengthSeconds()
			local firstBeatSecs = song:GetFirstSecond()
			local lastBeatSecs = song:GetLastSecond()
			local step = GAMESTATE:GetCurrentSteps(Player)

			if step then
				timingData = step:GetTimingData()

				local bpms = timingData:GetBPMsAndTimes(true)
				local stops = timingData:GetStops(true)
				local delays = timingData:GetDelays(true)
				local warps = timingData:GetWarps(true)
				local fakes = timingData:GetFakes(true)
				local scrolls = timingData:GetScrolls(true)
				local speeds = timingData:GetSpeeds(true)

				local function CreateLine(beat, secs, firstShadow, firstDiffuse, secondShadow, firstEffect, secondEffect)
					local beatTime = timingData:GetElapsedTimeFromBeat(beat)
					if beatTime < 0 then beatTime = 0 end
					return Def.ActorFrame {
						Def.Quad {
							InitCommand=function(self)
								self:shadowlength(0)
								self:shadowcolor(color(firstShadow))
								self:zoomto(math.max((secs/songLen)*fFrameWidth, 1), fFrameHeight)
								self:x((scale(beatTime,firstBeatSecs,lastBeatSecs,-fFrameWidth/2,fFrameWidth/2)))
							end,
							OnCommand=function(self)
								self:diffuse(color(firstDiffuse))
								self:sleep(beatTime+1)
								self:linear(2)
								self:diffusealpha(0)
							end
						},
						Def.Quad {
							InitCommand=function(self)
								self:shadowlength(0)
								self:shadowcolor(color(secondShadow))
								self:zoomto(math.max((secs/songLen)*fFrameWidth, 1),fFrameHeight)
								self:x((scale(beatTime,firstBeatSecs,lastBeatSecs,-fFrameWidth/2,fFrameWidth/2)))
							end,
							OnCommand=function(self)
								self:diffusealpha(1)
								self:diffuseshift()
								self:effectcolor1(color(firstEffect))
								self:effectcolor2(color(secondEffect))
								self:effectclock('beat')
								self:effectperiod(1/8)
								self:diffusealpha(0)
								self:sleep(beatTime+1)
								self:diffusealpha(1)
								self:linear(4)
								self:diffusealpha(0)
							end
						}
					}
				end

				for i=2,#bpms do
					bpmFrame[#bpmFrame+1] = CreateLine(bpms[i][1], 0,
						"#00808077", "#00808077", "#00808077", "#FF634777", "#FF000077")
				end

				for i=1,#delays do
					delayFrame[#delayFrame+1] = CreateLine(delays[i][1], delays[i][2],
						"#FFFF0077", "#FFFF0077", "#FFFF0077", "#00FF0077", "#FF000077")
				end

				for i=1,#stops do
					stopFrame[#stopFrame+1] = CreateLine(stops[i][1], stops[i][2],
						"#FFFFFF77", "#FFFFFF77", "#FFFFFF77", "#FFA50077", "#FF000077")
				end

				for i=1,#scrolls do
					scrollFrame[#scrollFrame+1] = CreateLine(scrolls[i][1], 0,
						"#4169E177", "#4169E177", "#4169E177", "#0000FF77", "#FF000077")
				end

				for i=1,#speeds do
					speedFrame[#speedFrame+1] = CreateLine(speeds[i][1], 0,
						"#ADFF2F77", "#ADFF2F77", "#ADFF2F77", "#7CFC0077", "#FF000077")
				end

				for i=1,#warps do
					warpFrame[#warpFrame+1] = CreateLine(warps[i][1], 0,
						"#CC00CC77", "#CC00CC77", "#CC00CC77", "#FF33CC77", "#FF000077")
				end

				for i=1,#fakes do
					fakeFrame[#fakeFrame+1] = CreateLine(fakes[i][1], 0,
						"#BC8F8F77", "#BC8F8F77", "#BC8F8F77", "#F4A46077", "#FF000077")
				end
			end
		end
		bars[#bars+1] = bpmFrame
		bars[#bars+1] = scrollFrame
		bars[#bars+1] = speedFrame
		bars[#bars+1] = stopFrame
		bars[#bars+1] = delayFrame
		bars[#bars+1] = warpFrame
		bars[#bars+1] = fakeFrame
		t[#t+1] = bars
	end
	return t
end
local t = LoadFallbackB()
t[#t+1] = StandardDecorationFromFileOptional("ScoreFrame","ScoreFrame")

local function songMeterScale(val) return scale(val,0,1,-380/2,380/2) end

for pn in ivalues(PlayerNumber) do
	local MetricsName
	local playerColor
	if GAMESTATE:GetNumPlayersEnabled()==1 then
		MetricsName = "SongMeterDisplay"
		playerColor = Color("Orange")
	else
		MetricsName = "SongMeterDisplay" .. PlayerNumberToString(pn)
		playerColor = PlayerColor(pn)
	end
	local songMeterDisplay = Def.ActorFrame{
		InitCommand=function(self)
			self:name(MetricsName)
			ActorUtil.LoadAllCommandsAndSetXY(self,Var "LoadingScreen")
		end,
		LoadActor( THEME:GetPathG( 'SongMeterDisplay', 'frame ' .. PlayerNumberToString(pn) ) ) .. {
			InitCommand=function(self)
				self:name('Frame')
				ActorUtil.LoadAllCommandsAndSetXY(self,MetricsName)
			end
		},
		Def.Quad {
			InitCommand=function(self) self:zoomto(2,8) end,
			OnCommand=function(self) self:x(songMeterScale(0.25)):diffuse(playerColor):diffusealpha(0.5) end
		},
		Def.Quad {
			InitCommand=function(self) self:zoomto(2,8) end,
			OnCommand=function(self) self:x(songMeterScale(0.5)):diffuse(playerColor):diffusealpha(0.5) end
		},
		Def.Quad {
			InitCommand=function(self) self:zoomto(2,8) end,
			OnCommand=function(self) self:x(songMeterScale(0.75)):diffuse(playerColor):diffusealpha(0.5) end
		},
		Def.SongMeterDisplay {
			StreamWidth=THEME:GetMetric( MetricsName, 'StreamWidth' ),
			Stream=LoadActor( THEME:GetPathG( 'SongMeterDisplay', 'stream ' .. PlayerNumberToString(pn) ) )..{
				InitCommand=function(self) self:diffuse(playerColor):diffusealpha(0.5):blend(Blend.Add) end
			},
			Tip=LoadActor( THEME:GetPathG( 'SongMeterDisplay', 'tip ' .. PlayerNumberToString(pn) ) ) .. { InitCommand=function(self) self:visible(false) end }
		}
	}
	songMeterDisplay[#songMeterDisplay+1] = CreateSegments(pn)
	t[#t+1] = songMeterDisplay
end

for pn in ivalues(PlayerNumber) do
	local MetricsName = "ToastyDisplay" .. PlayerNumberToString(pn)
	t[#t+1] = LoadActor( THEME:GetPathG("Player", 'toasty'), pn ) .. {
		InitCommand=function(self)
			self:player(pn)
			self:name(MetricsName)
			ActorUtil.LoadAllCommandsAndSetXY(self,Var "LoadingScreen")
		end
	}
end

t[#t+1] = StandardDecorationFromFileOptional("BPMDisplay","BPMDisplay")
t[#t+1] = StandardDecorationFromFileOptional("SongTitle","SongTitle")

return t