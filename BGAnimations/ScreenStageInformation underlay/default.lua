local playMode = GAMESTATE:GetPlayMode()

local sStage = ""
sStage = GAMESTATE:GetCurrentStage()

if playMode ~= 'PlayMode_Regular' and playMode ~= 'PlayMode_Rave' and playMode ~= 'PlayMode_Battle' then
  sStage = playMode;
end;

local t = Def.ActorFrame {};
t[#t+1] = Def.Quad {
	InitCommand=function(self) self:Center():zoomto(SCREEN_WIDTH,SCREEN_HEIGHT):diffuse(Color("Black")) end;
};
if GAMESTATE:IsCourseMode() then
	t[#t+1] = LoadActor("CourseDisplay");
else
	t[#t+1] = Def.Sprite {
		InitCommand=function(self) self:Center():diffusealpha(0) end;
		BeginCommand=function(self) self:LoadFromCurrentSongBackground() end;
		OnCommand=function(self)
			self:scale_or_crop_background()
			self:sleep(0.5)
			self:linear(0.50)
			self:diffusealpha(1)
			self:sleep(3)
		end;
	};
end

local stage_num_actor= THEME:GetPathG("ScreenStageInformation", "Stage " .. ToEnumShortString(sStage), true)
if stage_num_actor ~= "" and FILEMAN:DoesFileExist(stage_num_actor) then
	stage_num_actor= LoadActor(stage_num_actor)
else
	-- Midiman:  We need a "Stage Next" actor or something for stages after
	-- the 6th. -Kyz
	local curStage = GAMESTATE:GetCurrentStage();
	stage_num_actor= Def.BitmapText{
		Font= "Common Normal",  Text= thified_curstage_index(false) .. " Stage",
		InitCommand= function(self)
			self:zoom(1.5)
			self:strokecolor(Color.Black)
			self:diffuse(StageToColor(curStage));
			self:diffusetopedge(ColorLightTone(StageToColor(curStage)));
		end
	}
end

t[#t+1] = Def.ActorFrame {
	InitCommand=function(self) self:Center() end;
	OnCommand=function(self) self:stoptweening():zoom(1.25):decelerate(3):zoom(1) end;
	stage_num_actor .. {
		OnCommand=function(self) self:diffusealpha(0):linear(0.25):diffusealpha(1):sleep(1.75):linear(0.5):zoomy(0):zoomx(2):diffusealpha(0) end;
	};
};

t[#t+1] = Def.ActorFrame {
  InitCommand=function(self) self:CenterX():y(SCREEN_CENTER_Y+96) end;
  OnCommand=function(self) self:stoptweening():addy(-16):decelerate(3):addy(16) end;
	LoadFont("Common Normal") .. {
		Text=GAMESTATE:IsCourseMode() and GAMESTATE:GetCurrentCourse():GetDisplayFullTitle() or GAMESTATE:GetCurrentSong():GetDisplayFullTitle();
		InitCommand=function(self) self:strokecolor(Color("Outline")):y(-20):maxwidth(SCREEN_WIDTH-16) end;
		OnCommand=function(self) self:diffusealpha(0):linear(0.5):diffusealpha(1):sleep(1.5):linear(0.5):diffusealpha(0) end;
	};
	LoadFont("Common Normal") .. {
		Text=GAMESTATE:IsCourseMode() and ToEnumShortString( GAMESTATE:GetCurrentCourse():GetCourseType() ) or GAMESTATE:GetCurrentSong():GetDisplayArtist();
		InitCommand=function(self) self:strokecolor(Color("Outline")):zoom(0.75):maxwidth(SCREEN_WIDTH-16) end;
		OnCommand=function(self) self:diffusealpha(0):linear(0.5):diffusealpha(1):sleep(1.5):linear(0.5):diffusealpha(0) end;
	};
	LoadFont("Common Normal") .. {
		InitCommand=function(self) self:strokecolor(Color("Outline")):diffuse(Color("Orange")):diffusebottomedge(Color("Yellow")):zoom(0.75):y(20) end;
		BeginCommand=function(self)
			local text = "";
			local SongOrCourse;
			if GAMESTATE:IsCourseMode() then
				local trail = GAMESTATE:GetCurrentTrail(GAMESTATE:GetMasterPlayerNumber());
				SongOrCourse = GAMESTATE:GetCurrentCourse();
				if SongOrCourse:GetEstimatedNumStages() == 1 then
					text = SongOrCourse:GetEstimatedNumStages() .." Stage / ".. SecondsToMSSMsMs( TrailUtil.GetTotalSeconds(trail) );
				else
					text = SongOrCourse:GetEstimatedNumStages() .." Stages / ".. SecondsToMSSMsMs( TrailUtil.GetTotalSeconds(trail) );
				end
			else
				SongOrCourse = GAMESTATE:GetCurrentSong();
				text = SecondsToMSSMsMs( SongOrCourse:MusicLengthSeconds() );
			end;
			self:settext(text);
		end;
		OnCommand=function(self) self:diffusealpha(0):linear(0.5):diffusealpha(1):sleep(1.5):linear(0.5):diffusealpha(0) end;
	};
};

return t