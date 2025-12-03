return Def.ActorFrame {
	Def.Quad {
		InitCommand=function(self) self:zoomto(32*WideScreenDiff(),32*WideScreenDiff()) end,
		OnCommand=function(self) self:spin() end
	}
}