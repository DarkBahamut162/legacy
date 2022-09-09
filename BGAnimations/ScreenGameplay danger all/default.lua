return Def.ActorFrame {
	Def.Quad{
		InitCommand=function(self) self:FullScreen():diffuse(color("1,0,0,0")):blend(Blend.Multiply) end,
		OnCommand=function(self) self:smooth(1):diffuse(color("0.75,0,0,0.75")):decelerate(2):diffuse(color("0,0,0,1")) end
	}
}