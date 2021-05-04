return Def.ActorFrame {
	Def.BitmapText{ Font= "Common Normal",
		Text="BPM",
		InitCommand= function(self) self:horizalign(right):zoom(0.75):strokecolor(Color("Outline")) end,
		SetCommand=function(self)
			local bIsFirst = false;
			local song = GAMESTATE:GetCurrentSong();
			self:stoptweening();
-- 			self:linear(0.25);
			if song then
				self:diffusebottomedge( song:GetTimingData():HasStops() and Color("Orange") or Color("White") );
			else
				self:diffusebottomedge( Color("White") );
			end;
		end;
		CurrentSongChangedMessageCommand=function(self) self:playcommand("Set") end;
		CurrentCourseChangedMessageCommand=function(self) self:playcommand("Set") end;
	}
}