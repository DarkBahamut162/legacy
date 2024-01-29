if IsNetSMOnline() or GAMESTATE:IsCourseMode() then return Def.ActorFrame{} end

local length = SongMeasureSec() / 8 * 7
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
		:bounceend(length/4):zoom(1):diffusealpha(1)
		:linear(length/8):glow(BoostColor(color,1.75))
		:decelerate(length/8):glow(1,1,1,0)
		:sleep(length/4)
		:linear(length/4):diffusealpha(0) end
}