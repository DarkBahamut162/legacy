local gc = Var "GameCommand"
local icon_color = ModeIconColors[gc:GetName()]
local string_name = gc:GetText()
local string_expl = THEME:GetString(Var "LoadingScreen", gc:GetName() .. "Explanation")

return Def.ActorFrame {
	GainFocusCommand=function(self) self:finishtweening():visible(true):zoom(1.1*WideScreenDiff()):decelerate(0.25):zoom(WideScreenDiff()) end,
	LoseFocusCommand=function(self) self:finishtweening():visible(false):zoom(WideScreenDiff()) end,
	Def.ActorFrame {
		Def.Sprite{
			Texture= THEME:GetPathG("ScreenSelectPlayMode","BackgroundFrame"),
			InitCommand=function(self) self:diffuse(Color("Black")):diffusealpha(0.45) end,
			GainFocusCommand=function(self) self:visible(true) end,
			LoseFocusCommand=function(self) self:visible(false) end
		},
		Def.Sprite{
			Texture= THEME:GetPathG("ScreenSelectPlayMode","scroller/_HighlightFrame"),
			InitCommand=function(self) self:diffuse(icon_color):diffusealpha(0) end,
			GainFocusCommand=function(self)
				self:finishtweening():diffuse(ColorLightTone(icon_color)):linear(1):diffuse(icon_color) end,
			LoseFocusCommand=function(self) self:finishtweening():diffusealpha(0) end,
			OffFocusedCommand=function(self)
				self:finishtweening():glow(Color("White")):decelerate(1):glow(Color("Invisible")) end
		}
	},
	Def.ActorFrame {
		FOV=90,
		InitCommand=function(self) self:x(-192*WideScreenDiff()):zoom(0.9*WideScreenDiff()) end,
		Def.Sprite{
			Texture= THEME:GetPathG("ScreenSelectPlayMode","scroller/"..gc:GetName()),
			InitCommand=function(self) self:diffusealpha(0):zoom(0.75*WideScreenDiff()) end,
			GainFocusCommand=function(self)
				self:finishtweening():stopeffect():diffusealpha(1):zoom(WideScreenDiff()):glow(Color("White"))
				:decelerate(0.5):glow(Color("Invisible")):pulse():effecttiming(0.75,0.125,0.125,0.75)
				:effectmagnitude(0.95,1,1) end,
			LoseFocusCommand=function(self)
				self:finishtweening():stopeffect():smooth(0.4)
				:diffusealpha(0):zoom(0.75*WideScreenDiff()):glow(Color("Invisible")) end,
			OffFocusedCommand=function(self)
				self:finishtweening():stopeffect():glow(icon_color):decelerate(0.5)
				:rotationy(360):glow(Color("Invisible")) end
		}
	},
	Def.ActorFrame {
		InitCommand=function(self) self:x(-192/2*WideScreenDiff()):y(-10*WideScreenDiff()) end,
		Def.BitmapText{
			Font= "_helveticaneuelt std extblk cn 42px",
			Text=string_name,
			InitCommand=function(self)
				self:y(-2*WideScreenDiff()):horizalign(left):diffuse(icon_color):strokecolor(ColorDarkTone(icon_color))
				:shadowlength(2):diffusealpha(0):skewx(-0.125) end,
			OnCommand=function(self)
				self:glowshift():textglowmode('TextGlowMode_Inner')
				:effectcolor1(color("1,1,1,0.5")):effectcolor2(color("1,1,1,0"))
			end,
			GainFocusCommand=function(self)
				self:finishtweening():x(-16*WideScreenDiff()):diffuse(ColorLightTone(icon_color))
				:decelerate(0.45):diffusealpha(1):x(0):diffuse(icon_color) end,
			LoseFocusCommand=function(self) self:finishtweening():x(0):accelerate(0.4):diffusealpha(0):x(32*WideScreenDiff()):diffusealpha(0) end
		},
		Def.BitmapText{
			Font= "_helveticaneuelt std extblk cn 42px",
			Text=string_expl,
			InitCommand=function(self)
				self:horizalign(right):x(320*WideScreenDiff()):y(30*WideScreenDiff()):shadowlength(1)
				:diffusealpha(0):skewx(-0.125):zoom(0.5*WideScreenDiff()) end,
			GainFocusCommand=function(self)
				self:finishtweening():x(336*WideScreenDiff()):decelerate(0.45):diffusealpha(1):x(320*WideScreenDiff()) end,
			LoseFocusCommand=function(self)
				self:finishtweening():x(320*WideScreenDiff()):accelerate(0.4):diffusealpha(0):x(288*WideScreenDiff()):diffusealpha(0) end
		},
		Def.Quad {
			InitCommand=function(self)
				self:horizalign(left):y(20*WideScreenDiff()):zoomto(320*WideScreenDiff(),2*WideScreenDiff()):diffuse(icon_color)
				:diffusealpha(0):fadeleft(0.35):faderight(0.35) end,
			GainFocusCommand=function(self) self:stoptweening():linear(0.5):diffusealpha(1) end,
			LoseFocusCommand=function(self) self:stoptweening():linear(0.1):diffusealpha(0) end
		}
	}
}