if IsNetSMOnline() then
	return Def.ActorFrame{}
end

local length = SongMeasureSec()
local graphic = "ready"
local color = Color("Orange")

if MinSecondsToStep() <= 2 then
	length = length * 2
	graphic = "not ready"
	color = Color("Red")
end

return LoadActor(graphic) .. {
	InitCommand=function(self) self:Center():draworder(105) end,
	StartTransitioningCommand=function(self) self:zoom(1.3):diffusealpha(0)
		:bounceend(SongMeasureSec()/4):zoom(1):diffusealpha(1)
		:linear(SongMeasureSec()/8):glow(BoostColor(color,1.75))
		:decelerate(SongMeasureSec()/8):glow(1,1,1,0)
		:sleep(SongMeasureSec()/4)
		:linear(SongMeasureSec()/4):diffusealpha(0) end
}