local curScreen = Var "LoadingScreen"
local curStageIndex = GAMESTATE:GetCurrentStageIndex() + 1
local playMode = GAMESTATE:GetPlayMode()
local courseMode = GAMESTATE:IsCourseMode()

return Def.ActorFrame {
	loadfile(THEME:GetPathB("_frame","3x3"))("rounded black",64,16),
	Def.BitmapText{
		Font= "Common Normal",
		InitCommand=function(self) self:y(-1):shadowlength(1):playcommand("Set") end,
		CurrentSongChangedMessageCommand=function(self) if not courseMode then self:playcommand("Set") end end,
		CurrentCourseChangedMessageCommand=function(self) if courseMode then self:playcommand("Set") end end,
		CurrentStepsP1ChangedMessageCommand=function(self) if not courseMode then self:playcommand("Set") end end,
		CurrentStepsP2ChangedMessageCommand=function(self) if not courseMode then self:playcommand("Set") end end,
		CurrentTraiP1ChangedMessageCommand=function(self) if courseMode then self:playcommand("Set") end end,
		CurrentTraiP2ChangedMessageCommand=function(self) if courseMode then self:playcommand("Set") end end,
		SetCommand=function(self)
			local curStage = GAMESTATE:GetCurrentStage()
			if GAMESTATE:IsCourseMode() then
				local stats = STATSMAN:GetCurStageStats()
				if not stats then
					return
				end
				local mpStats = stats:GetPlayerStageStats( GAMESTATE:GetMasterPlayerNumber() )
				local songsPlayed = mpStats:GetSongsPassed() + 1
				self:settextf("%i / %i", songsPlayed, GAMESTATE:GetCurrentCourse():GetEstimatedNumStages())
			else
				if GAMESTATE:IsEventMode() then
					self:settextf("Stage %s", curStageIndex)
				else
					local thed_stage= thified_curstage_index(false)
					if THEME:GetMetric(curScreen,"StageDisplayUseShortString") then
						self:settextf(thed_stage)
					else
						self:settextf("%s Stage", thed_stage)
					end
				end
			end
			self:zoom(0.675)
			self:diffuse(StageToColor(curStage))
			self:diffusetopedge(ColorLightTone(StageToColor(curStage)))
		end
	}
}

