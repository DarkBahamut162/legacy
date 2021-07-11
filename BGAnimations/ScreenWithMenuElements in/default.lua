local fTileSize = 32;
local iTilesX = math.ceil( SCREEN_WIDTH/fTileSize );
local iTilesY = math.ceil( SCREEN_HEIGHT/fTileSize );
local fSleepTime = THEME:GetMetric( Var "LoadingScreen","ScreenInDelay");
local t = Def.ActorFrame {
	InitCommand=function(self) self:Center() end;
	OnCommand=function(self) self:sleep(fSleepTime) end;
};
t[#t+1] = Def.Quad {
	InitCommand=function(self) self:zoomto(SCREEN_WIDTH+1,SCREEN_HEIGHT) end;
	OnCommand=function(self) self:diffuse(color("0,0,0,1")):sleep(0.0325 + fSleepTime):linear(0.15):diffusealpha(0) end;
};

return t