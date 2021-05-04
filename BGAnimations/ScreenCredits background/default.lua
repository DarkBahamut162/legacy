local scrolltime = 95;

local t = Def.ActorFrame {
	InitCommand=function(self) self:Center() end;
	LoadActor("_space")..{
		InitCommand=function(self) self:y(-SCREEN_HEIGHT*1.5):fadebottom(0.125):fadetop(0.25) end;
		OnCommand=function(self) self:linear(scrolltime):addy(SCREEN_HEIGHT*1.5825) end;
	};
	Def.Quad {
		InitCommand=function(self) self:scaletoclipped(SCREEN_WIDTH+1,SCREEN_HEIGHT) end;
		OnCommand=function(self) self:diffusecolor(color("#FFCB05")):diffusebottomedge(color("#F0BA00")):diffusealpha(0.45) end;
	};
	LoadActor("_grid")..{
		InitCommand=function(self) self:customtexturerect(0,0,(SCREEN_WIDTH+1)/4,SCREEN_HEIGHT/4):SetTextureFiltering(true) end;
		OnCommand=function(self) self:zoomto(SCREEN_WIDTH+1,SCREEN_HEIGHT):diffuse(Color("Black") end;diffuseshift;effecttiming,(1/8)*4,0,(7/8)*4,0;effectclock,'beatnooffset';
		effectcolor2,Color("Black");effectcolor1,Color.Alpha(Color("Black"),0.45);fadebottom,0.25;fadetop,0.25;croptop,48/480;cropbottom,48/480;diffusealpha,0.345);
	};
};

return t