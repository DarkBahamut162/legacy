if IsNetSMOnline() or MinSecondsToStep() <= 2 then return Def.ActorFrame{} end

local length = SongMeasureSec() / 8 * 7

return LoadActor("go") .. {
	InitCommand=function(self) self:Center():draworder(105) end,
	StartTransitioningCommand=function(self) self:zoom(1.3):diffusealpha(0)
		:bounceend(length/4):zoom(1):diffusealpha(1)
		:linear(length/8):glow(BoostColor(Color("Blue"),1.75))
		:decelerate(length/8):glow(1,1,1,0)
		:sleep(length/4)
		:linear(length/4):diffusealpha(0) end
}