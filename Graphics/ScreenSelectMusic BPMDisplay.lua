local courseMode = GAMESTATE:IsCourseMode()

return Def.BPMDisplay {
	File=THEME:GetPathF("BPMDisplay", "bpm"),
	Name="BPMDisplay",
	SetCommand=function(self) self:SetFromGameState() end,
	CurrentSongChangedMessageCommand=function(self) if not courseMode then self:playcommand("Set") end end,
	CurrentCourseChangedMessageCommand=function(self) if courseMode then self:playcommand("Set") end end
}