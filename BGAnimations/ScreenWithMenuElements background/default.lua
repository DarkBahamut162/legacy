return Def.ActorFrame {
	Def.ActorFrame{
		FOV = 90,
		InitCommand=function(self) self:Center() end,
		UpdateParticleShowMessageCommand=function(self) self:hide_if( hideFancyElements ) end,
		Def.Quad {
			InitCommand=function(self) self:scaletoclipped(SCREEN_WIDTH,SCREEN_HEIGHT) end,
			OnCommand=function(self) self:diffuse(color("#FFCB05")):diffusebottomedge(color("#F0BA00")) end
		},
	},
	Def.ActorFrame {
		LoadActor("_checkerboard") .. {
			InitCommand=function(self)
				self:rotationx(-90/4*3.5):zoomto(SCREEN_WIDTH*2,SCREEN_HEIGHT*2):customtexturerect(0,0,SCREEN_WIDTH*4/256,SCREEN_HEIGHT*4/256)
			end,
			OnCommand=function(self) self:texcoordvelocity(0,0.25):diffuse(color("#ffd400")):fadetop(1) end
		}
	},
	LoadActor("_particleLoader") .. {
		InitCommand=function(self)
			self:xy(-SCREEN_CENTER_X,-SCREEN_CENTER_Y)
		end
	}
}