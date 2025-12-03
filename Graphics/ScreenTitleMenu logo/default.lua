return Def.ActorFrame{
	InitCommand=function(self) self:fov(70) end,
	Def.Sprite{
		Texture= THEME:GetPathG("ScreenTitleMenu","logo/_arrow"),
		InitCommand=function(self) self:x(225*WideScreenDiff()):zoom(WideScreenDiff()) end
	},
	Def.Sprite{
		Texture= THEME:GetPathG("ScreenTitleMenu","logo/_text"),
		InitCommand=function(self) self:zoom(WideScreenDiff()) end
	},
	Def.Sprite{
		Texture= THEME:GetPathG("ScreenTitleMenu","logo/_text"),
		Name="TextGlow",
		InitCommand=function(self) self:blend(Blend.Add):diffusealpha(0.05):zoom(WideScreenDiff()) end,
		OnCommand=function(self) self:glowshift():effectperiod(2.5):effectcolor1(color("1,1,1,0.25")):effectcolor2(color("1,1,1,1")) end
	}
}
