return Def.ActorFrame {
	-- Fade
	Def.ActorFrame {
		InitCommand=function(self) self:Center() end,
		Def.Quad {
			InitCommand=function(self) self:scaletoclipped(SCREEN_WIDTH,SCREEN_HEIGHT) end,
			OnCommand=function(self) self:diffuse(Color.Black):diffusealpha(0):linear(0.5):diffusealpha(0.75) end,
			OffCommand=function(self) self:linear(0.25):diffusealpha(0) end
		}
	},
	-- Emblem
	Def.ActorFrame {
		InitCommand=function(self) self:Center() end,
		OnCommand=function(self) self:diffusealpha(0.5) end,
		LoadActor("_warning bg") .. {
			OnCommand=function(self) self:diffuse(Color.Yellow) end
		},
		Def.ActorFrame {
			LoadActor("_exclamation") .. {
				OnCommand=function(self) self:diffuse(Color.Yellow) end
			}
		}
	},
	-- Text
	Def.ActorFrame {
		InitCommand=function(self) self:Center() end,
		OnCommand=function(self) self:addy(-96) end,
		-- Underline
		Def.Quad {
			InitCommand=function(self) self:y(24):zoomto(256,2) end,
			OnCommand=function(self) self:diffuse(color("#ffd400")):shadowcolor(BoostColor(color("#ffd40077"),0.25)):linear(0.25):zoomtowidth(256):fadeleft(0.25):faderight(0.25) end
		},
		LoadFont("Common Large") .. {
			Text=Screen.String("Caution"),
			OnCommand=function(self) self:skewx(-0.125):diffuse(color("#ffd400")):strokecolor(ColorDarkTone(color("#ffd400"))) end
		},
		LoadFont("Common Normal") .. {
			Text=Screen.String("CautionText"),
			InitCommand=function(self) self:y(128) end,
			OnCommand=function(self) self:strokecolor(color("0,0,0,0.5")):shadowlength(1):wrapwidthpixels(SCREEN_WIDTH-80) end
		}
	}
}