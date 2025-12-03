return Def.ActorFrame {
	Def.Quad {
		InitCommand=function(self) self:align(0,0):y(SCREEN_TOP+8*WideScreenDiff()) end,
		OnCommand=function(self) self:diffuse(Color.Black):diffusealpha(0.5):zoomto(256*WideScreenDiff(),84*WideScreenDiff()):faderight(1) end
	},
	Def.Quad {
		InitCommand=function(self) self:align(1,0):xy(SCREEN_RIGHT,SCREEN_TOP+8*WideScreenDiff()) end,
		OnCommand=function(self) self:diffuse(Color.Black):diffusealpha(0.5):zoomto(256*WideScreenDiff(),46*WideScreenDiff()):fadeleft(1) end
	}
}