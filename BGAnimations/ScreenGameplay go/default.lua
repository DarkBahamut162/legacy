if IsNetSMOnline() or MinSecondsToStep() <= 2 then
	return Def.ActorFrame{}
end

return LoadActor("go") .. {
	InitCommand=function(self) self:Center():draworder(105) end,
	StartTransitioningCommand=function(self) self:zoom(1.3):diffusealpha(0)
		:bounceend(SongMeasureSec()/4):zoom(1):diffusealpha(1)
		:linear(SongMeasureSec()/8):glow(BoostColor(Color("Blue"),1.75))
		:decelerate(SongMeasureSec()/8):glow(1,1,1,0)
		:sleep(SongMeasureSec()/4)
		:linear(SongMeasureSec()/4):diffusealpha(0) end
}