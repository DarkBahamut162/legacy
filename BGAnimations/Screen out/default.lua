local fSleepTime = THEME:GetMetric( Var "LoadingScreen","ScreenOutDelay");

return Def.ActorFrame {
	Def.Quad {
		InitCommand=function(self) self:Center():zoomto(SCREEN_WIDTH+1,SCREEN_HEIGHT) end;
		OnCommand=function(self) self:diffuse(color("0,0,0,0")):sleep(fSleepTime):linear(0.01):diffusealpha(1) end;
	};
};