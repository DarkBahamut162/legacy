return Def.ActorFrame {
	InitCommand=function(self) self:fov(90) end,
	Def.ActorFrame {
		InitCommand=function(self) self:Center() end,
		Def.Quad {
			InitCommand=function(self) self:scaletoclipped(SCREEN_WIDTH,SCREEN_HEIGHT) end;
			OnCommand=function(self) self:diffuse(color("#ffcb05")) end;
		};
		Def.Sprite{
			Texture= THEME:GetPathB("ScreenWithMenuElements","background/_bg top"),
			InitCommand=function(self) self:scaletoclipped(SCREEN_WIDTH,SCREEN_HEIGHT) end,
		},
		Def.Quad{
			InitCommand=function(self)
				self:scaletoclipped(SCREEN_WIDTH,SCREEN_HEIGHT):diffuse(color("0.2,0.2,0.2,0")) end,
			OnCommand=function(self)
				local topScreen = SCREENMAN:GetTopScreen()
				if topScreen then
					local screenName = topScreen:GetName()
					if screenName == "ScreenEdit" or screenName == "ScreenPractice" then
						self:diffusealpha(0.325)
					else
						self:diffusealpha(0)
					end
				end
			end,
			EditorShowMessageCommand=function(self) self:stoptweening():linear(0.5):diffusealpha(0.75) end,
			EditorHideMessageCommand=function(self) self:stoptweening():linear(0.5):diffusealpha(0.325) end,
		}
	}
}