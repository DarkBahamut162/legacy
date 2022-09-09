local timer_seconds = THEME:GetMetric(Var "LoadingScreen","TimerSeconds")

return Def.ActorFrame {
	InitCommand=function(self) self:Center() end,
	-- Fade
	Def.ActorFrame {
		Def.Quad {
			InitCommand=function(self) self:scaletoclipped(SCREEN_WIDTH,SCREEN_HEIGHT) end,
			OnCommand=function(self) self:diffuse(Color.Black):diffusealpha(0):linear(0.5):diffusealpha(0.25):sleep(timer_seconds/2):  linear(timer_seconds/2-0.5):diffusealpha(0.8) end
		},
		-- Warning Fade
		Def.Quad {
			InitCommand=function(self) self:y(-4):scaletoclipped(SCREEN_WIDTH,164) end,
			OnCommand=function(self) self:diffuse(Color.Black):diffusealpha(0.5):linear(timer_seconds):zoomtoheight(164*0.75) end
		}
	},
	--
	LoadActor(THEME:GetPathG("ScreenGameOver","gameover"))..{
		InitCommand=function(self) self:y(-16):shadowlength(2) end
	},
	LoadFont("Common Normal")..{
		Text=ScreenString("Play again soon!"),
		InitCommand=function(self) self:y(36):shadowlength(2) end
	}
}