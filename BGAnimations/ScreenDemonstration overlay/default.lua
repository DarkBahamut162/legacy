local t = Def.ActorFrame{
	Def.Quad{
		Name="TopFrame";
		InitCommand=function(self) self:CenterX():y(SCREEN_TOP):valign(0):zoomto(SCREEN_WIDTH,SCREEN_HEIGHT*0.15):diffuse(color("0,0,0,1")):fadebottom(0.5) end;
	};

	Def.Quad{
		Name="BotFrame";
		InitCommand=function(self) self:CenterX():y(SCREEN_BOTTOM):valign(1):zoomto(SCREEN_WIDTH,SCREEN_HEIGHT*0.15):diffuse(color("0,0,0,1")):fadetop(0.5) end;
	};

	Def.ActorFrame{
		Name="MiddleSection";
		InitCommand=function(self) self:CenterX():y(SCREEN_CENTER_Y*1.35) end;
		Def.Quad{
			Name="Frame";
			InitCommand=function(self) self:zoomto(SCREEN_WIDTH,0):diffuse(color("0.1,0.1,0.1,0.75")):fadebottom(0.25):fadetop(0.25) end;
			OnCommand=function(self) self:smooth(0.75):zoomtoheight(64) end;
		};
		LoadFont("Common normal")..{
			Text=Screen.String("Demonstration");
			InitCommand=function(self) self:diffusealpha(0):strokecolor(color("0,0,0,0.5")) end;
			OnCommand=function(self) self:smooth(0.75):diffusealpha(1):diffuseshift():effectcolor1(HSV(38,0.45,0.95)) end;
		};
	};

	LoadFont("Common normal")..{
		Name="SongTitle";
		InitCommand=function(self) self:CenterX():y(SCREEN_TOP+16):zoom(0.5):shadowlength(1):valign(0) end;
		BeginCommand=function(self)
			local song = GAMESTATE:GetCurrentSong();
			local text = "";
			if song then
				local artist = song:GetDisplayArtist()
				local title = song:GetDisplayFullTitle()
				local group = song:GetGroupName()
				text = string.format(Screen.String("%s - %s   [from %s]"),artist,title,group)
			end;
			self:settext(text);
		end;
-- 		OnCommand=function(self) self:queuecommand("Scroll") end;
-- 		ScrollCommand=function(self) self:linear(10):x(-SCREEN_WIDTH*2):sleep(1):x(SCREEN_WIDTH*2):queuecommand("Scroll") end;
	};
};

return t;