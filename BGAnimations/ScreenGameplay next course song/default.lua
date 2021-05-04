local t = Def.ActorFrame{};

if not GAMESTATE:IsCourseMode() then return t; end;

t[#t+1] = Def.Sprite {
	InitCommand=function(self) self:Center() end;
	BeforeLoadingNextCourseSongMessageCommand=function(self) self:LoadFromSongBackground( SCREENMAN:GetTopScreen():GetNextCourseSong() ) end;
	ChangeCourseSongInMessageCommand=function(self) self:scale_or_crop_background() end;
	StartCommand=function(self) self:diffusealpha(0):decelerate(0.5):diffusealpha(1) end;
	FinishCommand=function(self) self:linear(0.1):glow(Color.Alpha(Color("White"),0.5)):decelerate(0.4):glow(Color("Invisible")):diffusealpha(0) end;
};

t[#t+1] = Def.ActorFrame {
  InitCommand=function(self) self:Center() end;
  OnCommand=function(self) self:stoptweening():addx(30):linear(3):addx(-30) end;
	LoadFont("Common Normal") .. {
		InitCommand=function(self) self:strokecolor(Color("Outline")):y(-10) end;
		BeforeLoadingNextCourseSongMessageCommand=function(self)
			local NextSong = SCREENMAN:GetTopScreen():GetNextCourseSong();
			self:settext( NextSong:GetDisplayFullTitle() );
		end;
		StartCommand=function(self) self:faderight(1):diffusealpha(0):linear(0.5):faderight(0):diffusealpha(1):sleep(1.5):linear(0.5):diffusealpha(0) end;
	};
--[[ 	LoadFont("Common Normal") .. {
		Text=GAMESTATE:IsCourseMode() and GAMESTATE:GetCurrentCourse():GetCourseType() or GAMESTATE:GetCurrentSong():GetDisplayArtist();
		InitCommand=function(self) self:strokecolor(Color("Outline")):zoom(0.75) end;
		OnCommand=function(self) self:faderight(1):diffusealpha(0):linear(0.5):faderight(0):diffusealpha(1):sleep(1.5):linear(0.5):diffusealpha(0) end;
	}; --]]
	LoadFont("Common Normal") .. {
		InitCommand=function(self) self:strokecolor(Color("Outline")):diffuse(Color("Orange")):diffusebottomedge(Color("Yellow")):zoom(0.75):y(10) end;
		BeforeLoadingNextCourseSongMessageCommand=function(self)
			local NextSong = SCREENMAN:GetTopScreen():GetNextCourseSong();
			self:settext( SecondsToMSSMsMs( NextSong:MusicLengthSeconds() ) );
		end;
		StartCommand=function(self) self:faderight(1):diffusealpha(0):linear(0.5):faderight(0):diffusealpha(1):sleep(1.5):linear(0.5):diffusealpha(0) end;
	};
};

return t;