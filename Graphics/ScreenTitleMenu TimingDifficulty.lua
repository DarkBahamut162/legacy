local label_text= false
return Def.ActorFrame {
	Def.BitmapText{
		Font= "Common Normal",
		Text=GetTimingDifficulty(),
		AltText="",
		InitCommand=function(self) self:horizalign(left):zoom(0.675*WideScreenDiff()) end,
		OnCommand= function(self)
			label_text= self
			self:shadowlength(1):settextf(Screen.String("TimingDifficulty"), "")
		end
	},
	Def.BitmapText{
		Font= "Common Normal",
		Text=GetTimingDifficulty(),
		AltText="",
		InitCommand=function(self) self:x(136*WideScreenDiff()):zoom(0.675*WideScreenDiff()):halign(0) end,
		OnCommand=function(self)
			self:shadowlength(1):skewx(-0.125):x(label_text:GetZoomedWidth()+8*WideScreenDiff())
			if GetTimingDifficulty() == 9 then
				self:settext(Screen.String("Hardest Timing"))
				self:zoom(0.5*WideScreenDiff()):diffuse(ColorLightTone( Color("Orange")))
			else
				self:settext( GetTimingDifficulty() )
			end
		end
	}
}
