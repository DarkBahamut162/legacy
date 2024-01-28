local courseMode = GAMESTATE:IsCourseMode()

return Def.ActorFrame {
	Def.BitmapText{ Font= "Common Normal",
		Text="BPM",
		InitCommand= function(self) self:horizalign(right):zoom(0.75):strokecolor(Color("Outline")) end,
		SetCommand=function(self)
			local bIsFirst = false
			local song = GAMESTATE:GetCurrentSong()
			self:stoptweening()
			if song then
				self:diffusebottomedge( song:GetTimingData():HasStops() and Color("Orange") or Color("White") )
			else
				self:diffusebottomedge( Color("White") )
			end
		end,
		CurrentSongChangedMessageCommand=function(self) if not courseMode then self:playcommand("Set") end end,
		CurrentCourseChangedMessageCommand=function(self) if courseMode then self:playcommand("Set") end end
	}
}