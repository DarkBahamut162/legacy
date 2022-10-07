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
			InitCommand=function(self) self:diffuse(icon_color):diffusebottomedge(icon_color2) end
		},
		Def.Sprite{ Texture= THEME:GetPathG("ScreenSelectPlayMode", "icon/_background effect") },
		Def.Sprite{ Texture= THEME:GetPathG("ScreenSelectPlayMode", "icon/_gloss") },
		Def.Sprite{ Texture= THEME:GetPathG("ScreenSelectPlayMode", "icon/_stroke") },
		Def.Sprite{ Texture= THEME:GetPathG("ScreenSelectPlayMode", "icon/_cutout") },
		Def.BitmapText{ Font= "_helveticaneuelt std extblk cn 42px",
			Text=ToUpper(string_name),
			InitCommand=function(self) self:y(-12):maxwidth(232) end,
			OnCommand=function(self)
				self:diffuse(Color.Black):shadowlength(1):shadowcolor(color("#ffffff77")) end
		},
		Def.BitmapText{ Font= "_helveticaneuelt std extblk cn 42px",
			Text=ToUpper(string_expl),
			InitCommand=function(self) self:y(27.5):zoom(0.45):maxwidth(320*1.6) end
		},

		Def.Sprite{ Texture=THEME:GetPathG("ScreenSelectPlayMode", "icon/_background base"),
			DisabledCommand=function(self) self:diffuse(color("0,0,0,0.5")) end,
			EnabledCommand=function(self) self:diffuse(color("1,1,1,0")) end
		}
	}
}