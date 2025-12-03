local gc = Var("GameCommand")

local string_name = gc:GetText()
local string_expl = THEME:GetString("StyleType", gc:GetStyle():GetStyleType())
local icon_color = color("#FFCB05")
local icon_color2 = color("#F0BA00")

return Def.ActorFrame {
	Def.ActorFrame {
		GainFocusCommand=THEME:GetMetric(Var "LoadingScreen","IconGainFocusCommand"),
		LoseFocusCommand=THEME:GetMetric(Var "LoadingScreen","IconLoseFocusCommand"),
		Def.Sprite{ Texture= THEME:GetPathG("ScreenSelectPlayMode", "icon/_background base"),
			InitCommand=function(self) self:diffuse(icon_color):diffusebottomedge(icon_color2):zoom(WideScreenDiff()) end
		},
		Def.Sprite{ Texture= THEME:GetPathG("ScreenSelectPlayMode", "icon/_background effect"),
			InitCommand=function(self) self:zoom(WideScreenDiff()) end
		},
		Def.Sprite{ Texture= THEME:GetPathG("ScreenSelectPlayMode", "icon/_gloss"),
			InitCommand=function(self) self:zoom(WideScreenDiff()) end
		},
		Def.Sprite{ Texture= THEME:GetPathG("ScreenSelectPlayMode", "icon/_stroke"),
			InitCommand=function(self) self:zoom(WideScreenDiff()) end
		},
		Def.Sprite{ Texture= THEME:GetPathG("ScreenSelectPlayMode", "icon/_cutout"),
			InitCommand=function(self) self:zoom(WideScreenDiff()) end
		},
		Def.BitmapText{ Font= "_helveticaneuelt std extblk cn 42px",
			Text=string.upper(string_name),
			InitCommand=function(self) self:y(-12*WideScreenDiff()):maxwidth(232):zoom(WideScreenDiff()) end,
			OnCommand=function(self)
				self:diffuse(Color.Black):shadowlength(1):shadowcolor(color("#ffffff77")) end
		},
		Def.BitmapText{ Font= "_helveticaneuelt std extblk cn 42px",
			Text=string.upper(string_expl),
			InitCommand=function(self) self:y(27.5*WideScreenDiff()):zoom(0.45*WideScreenDiff()):maxwidth(320*1.6) end
		},

		Def.Sprite{ Texture=THEME:GetPathG("ScreenSelectPlayMode", "icon/_background base"),
			InitCommand=function(self) self:zoom(WideScreenDiff()) end,
			DisabledCommand=function(self) self:diffuse(color("0,0,0,0.5")) end,
			EnabledCommand=function(self) self:diffuse(color("1,1,1,0")) end
		}
	}
}