local checkVisibility = not (GAMESTATE:GetPlayMode() == "PlayMode_Endless" or GAMESTATE:GetPlayMode() == "PlayMode_Nonstop" or GAMESTATE:GetPlayMode() == "PlayMode_Oni")

return Def.ActorFrame {
	LoadActor(THEME:GetPathG("OptionRowExit","frame")) .. {
		InitCommand=function(self) self:diffusebottomedge(Color("Orange")):visible(checkVisibility); end;
	};
	LoadActor(THEME:GetPathG("_icon","Sort")) .. {
		InitCommand=function(self) self:x(-60):shadowlength(1):diffuse(Color("Orange")):diffusetopedge(Color("Yellow")):visible(checkVisibility); end;
	};
};