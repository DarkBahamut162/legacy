local numPlayers = GAMESTATE:GetNumPlayersEnabled()

local function UpdateSingleBPM(self)
	local bpmDisplay = self:GetChild("BPMDisplay")
	local pn = GAMESTATE:GetMasterPlayerNumber()
	local pState = GAMESTATE:GetPlayerState(pn)
	local songPosition = pState:GetSongPosition()
	local bpm = songPosition:GetCurBPS() * 60
	bpmDisplay:settext( string.format("%03.0f",bpm) )
end

local displaySingle = Def.ActorFrame{
	InitCommand=function(self) self:SetUpdateFunction(UpdateSingleBPM) end,
	Def.BitmapText{
		Font= THEME:GetPathF("BPMDisplay", "bpm"),
		Name="BPMDisplay",
		InitCommand=function(self) self:zoom(0.675):shadowlength(1) end
	}
}

if numPlayers == 1 then
	return displaySingle
else
	local stepsP1 = GAMESTATE:GetCurrentSteps(PLAYER_1)
	local stepsP2 = GAMESTATE:GetCurrentSteps(PLAYER_2)

	if not stepsP1 or not stepsP2 then
		return displaySingle
	end

	local stP1 = stepsP1:GetStepsType()
	local stP2 = stepsP2:GetStepsType()

	local diffP1 = stepsP1:GetDifficulty()
	local diffP2 = stepsP2:GetDifficulty()

	local timingP1 = stepsP1:GetTimingData()
	local timingP2 = stepsP2:GetTimingData()

	if timingP1 == timingP2 then
		return displaySingle
	end

	local function Update2PBPM(self)
		local dispP1 = self:GetChild("DisplayP1")
		local dispP2 = self:GetChild("DisplayP2")

		for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
			local bpmDisplay = (pn == PLAYER_1) and dispP1 or dispP2
			local pState = GAMESTATE:GetPlayerState(pn)
			local songPosition = pState:GetSongPosition()
			local bpm = songPosition:GetCurBPS() * 60
			bpmDisplay:settext( string.format("%03.0f",bpm) )
		end
	end

	local playerOffset = 36
	return Def.ActorFrame{
		InitCommand=function(self) self:SetUpdateFunction(Update2PBPM) end,
		Def.BitmapText{
			Font= THEME:GetPathF("BPMDisplay", "bpm"),
			Name="DisplayP1",
			InitCommand=function(self) self:x(-playerOffset):zoom(0.6):shadowlength(1) end
		},
		Def.BitmapText{
			Font= THEME:GetPathF("BPMDisplay", "bpm"),
			Name="DisplayP2",
			InitCommand=function(self) self:x(playerOffset):zoom(0.6):shadowlength(1) end
		}
	}
end