return Def.ActorFrame {
	Def.ActorFrame {
		InitCommand=function(self) self:Center() end,
		Def.Quad {
			InitCommand=function(self) self:scaletoclipped(SCREEN_WIDTH,SCREEN_HEIGHT) end,
			OnCommand=function(self) self:diffuse(color("#00bfe8")):diffusetopedge(color("#009ad5")) end
		}
	}
}