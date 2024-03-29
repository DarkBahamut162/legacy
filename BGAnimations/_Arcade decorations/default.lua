return Def.ActorFrame {
	Def.ActorFrame {
		InitCommand=function(self)
			self:name("ArcadeOverlay")
			ActorUtil.LoadAllCommandsAndSetXY(self,Var "LoadingScreen")
		end,
		LoadActor(THEME:GetPathG("OptionRowExit","Frame")) .. {
			InitCommand=function(self) self:diffuse(Color("Orange")):diffusealpha(0.35) end
		},
		LoadFont("Common Normal") .. {
			InitCommand=function(self) self:zoom(0.75):shadowlength(1):glowshift():strokecolor(Color("Outline")):diffuse(Color("Orange")):diffusetopedge(Color("Yellow")):textglowmode('TextGlowMode_Inner') end,
			Text="...",
			OnCommand=function(self) self:playcommand("Refresh") end,
			CoinInsertedMessageCommand=function(self) self:playcommand("Refresh") end,
			CoinModeChangedMessageCommand=function(self) self:playcommand("Refresh") end,
			RefreshCommand=function(self)
				local bCanPlay = GAMESTATE:EnoughCreditsToJoin()
				local bReady = GAMESTATE:GetNumSidesJoined() > 0
				if bCanPlay or bReady then
					self:settext(THEME:GetString("ScreenTitleJoin","HelpTextJoin"))
				else
					self:settext(THEME:GetString("ScreenTitleJoin","HelpTextWait"))
				end
			end
		}
	}
}