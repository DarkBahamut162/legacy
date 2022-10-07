return Def.ActorFrame {
	Def.BitmapText{
		Font= "Common Normal",
		Name="TextTitle",
		InitCommand=function(self) self:y(-16.5):zoom(0.875):maxwidth(256/0.875) end,
		OnCommand=function(self) self:shadowlength(1) end
	},
		Def.BitmapText{
		Font= "Common Normal",
		Name="TextSubtitle",
		InitCommand=function(self) self:zoom(0.5):maxwidth(256/0.5) end,
		OnCommand=function(self) self:shadowlength(1) end
	},
	Def.BitmapText{
		Font= "Common Normal",
		Name="TextArtist",
		InitCommand=function(self) self:y(18):zoom(0.75):maxwidth(256/0.75) end,
		OnCommand=function(self) self:shadowlength(1):skewx(-0.2) end
	}
}