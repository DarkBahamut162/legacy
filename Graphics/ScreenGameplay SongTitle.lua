return Def.BitmapText{
	Font= THEME:GetPathF("ScreenGameplay","SongTitle"),
	CurrentSongChangedMessageCommand=function(self) if GAMESTATE:IsCourseMode() then self:playcommand("Refresh") end end,
	RefreshCommand=function(self)
		local vSong = GAMESTATE:GetCurrentSong()
		local vCourse = GAMESTATE:GetCurrentCourse()
		local sText = ""
		if vSong then
			sText = vSong:GetDisplayArtist() .. " - " .. vSong:GetDisplayFullTitle()
		end
		if vCourse then
			sText = vCourse:GetDisplayFullTitle() .. " - " .. vSong:GetDisplayFullTitle()
		end
		self:settext( sText )
		self:playcommand( "On" )
	end
}