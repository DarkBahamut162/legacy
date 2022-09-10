return Def.ActorFrame {
	InitCommand=function(self) self:Center() end,
	Def.Quad {
		InitCommand=function(self) self:zoomto(SCREEN_WIDTH,SCREEN_HEIGHT):visible(false) end,
		StartTransitioningCommand=function(self) self:visible(true):diffuse(Color("Black")):sleep(3.5):diffusealpha(0) end
	},
	Def.Quad {
		InitCommand=function(self) self:zoomto(SCREEN_WIDTH,80):diffuse(Color("Orange")):visible(false) end,
		StartTransitioningCommand=function(self) self:visible(true):decelerate(2):zoomy(44):decelerate(0.5):diffusealpha(0) end
	},
	LoadFont("Common Normal") .. {
		Text="This is only the beginning...",
		InitCommand=function(self) self:visible(false):shadowlength(1):shadowcolor(BoostColor(Color("Orange"),0.5)) end,
		StartTransitioningCommand=function(self) self:visible(true):zoom(0.75):fadeleft(1):faderight(1):linear(1):faderight(0):fadeleft(0):sleep(1):decelerate(0.5):y(12):diffusealpha(0) end
	},
	Def.Quad {
		InitCommand=function(self) self:zoomto(SCREEN_WIDTH,SCREEN_HEIGHT):diffuse(Color("White")):visible(false) end,
		StartTransitioningCommand=function(self) self:visible(true):decelerate(1):diffusealpha(0) end
	}
}