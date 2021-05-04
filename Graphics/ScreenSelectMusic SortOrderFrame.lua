return Def.ActorFrame {
	LoadActor(THEME:GetPathG("OptionRowExit","frame")) .. {
		InitCommand=function(self) self:diffusebottomedge(Color("Orange")) end;
	};
	LoadActor(THEME:GetPathG("_icon","Sort")) .. {
		InitCommand=function(self) self:x(-60):shadowlength(1):diffuse(Color("Orange")):diffusetopedge(Color("Yellow")) end;
	};
};