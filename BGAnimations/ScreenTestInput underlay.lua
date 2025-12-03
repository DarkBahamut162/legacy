return Def.ActorFrame {
	Def.DeviceList {
		Font="Common Normal",
		InitCommand=function(self) self:x(SCREEN_LEFT+20*WideScreenDiff()):y(SCREEN_TOP+80):zoom(0.8*WideScreenDiff()):halign(0) end
	},
	Def.InputList {
		Font="Common Normal",
		InitCommand=function(self) self:x(SCREEN_CENTER_X-250*WideScreenDiff()):y(SCREEN_CENTER_Y):zoom(WideScreenDiff()):halign(0):vertspacing(8) end
	}
}