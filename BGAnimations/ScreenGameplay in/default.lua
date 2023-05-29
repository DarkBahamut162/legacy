return Def.ActorFrame {
	Def.Sprite {
		InitCommand=function(self) self:Center():diffusealpha(1) end,
		BeginCommand=function(self) self:LoadFromCurrentSongBackground() end,
		OnCommand=function(self)
			if PREFSMAN:GetPreference("StretchBackgrounds") then
				self:SetSize(SCREEN_WIDTH,SCREEN_HEIGHT)
			else
				self:scale_or_crop_background()
			end
			self:linear(SongMeasureSec()/8):diffusealpha(0):sleep(BeginReadyDelay())
		end
	}
}