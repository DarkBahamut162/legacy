return Def.ActorFrame {
	Def.ActorFrame {
		OnCommand=function(self) self:x(SCREEN_CENTER_X-20) end,
		LoadActor("tapglow") .. {
			OnCommand=function(self) self:x(85):y(95):zoom(0.7):rotationz(90):diffuseshift():effectcolor1(1,0.93333,0.266666,0.4):effectcolor2(1,1,1,1):effectperiod(0.25):effectmagnitude(0,1,0):diffusealpha(0):sleep(6):linear(0):diffusealpha(1):sleep(1.7):linear(0):diffusealpha(0) end
		},
		LoadActor("tapglow") .. {
			OnCommand=function(self) self:x(275):y(95):zoom(0.7):rotationz(270):diffuseshift():effectcolor1(1,0.93333,0.266666,0.4):effectcolor2(1,1,1,1):effectperiod(0.25):effectmagnitude(0,1,0):diffusealpha(0):sleep(6):linear(0):diffusealpha(1):sleep(1.7):linear(0):diffusealpha(0) end
		},
		LoadActor("tapglow") .. {
			OnCommand=function(self) self:x(212):y(95):zoom(0.7):rotationz(180):diffuseshift():effectcolor1(1,0.93333,0.266666,0.4):effectcolor2(1,1,1,1):effectperiod(0.25):effectmagnitude(0,1,0):diffusealpha(0):sleep(6):linear(0):diffusealpha(1):sleep(1.7):linear(0):diffusealpha(0) end
		},
		LoadActor("tapglow") .. {
			OnCommand=function(self) self:x(148):y(95):zoom(0.7):diffuseshift():effectcolor1(1,0.93333,0.266666,0.4):effectcolor2(1,1,1,1):effectperiod(0.25):effectmagnitude(0,1,0):diffusealpha(0):sleep(6):linear(0):diffusealpha(1):sleep(1.7):linear(0):diffusealpha(0) end
		},
		LoadActor("tapglow") .. {
			OnCommand=function(self) self:x(148):y(95):zoom(0.7):diffuseshift():effectcolor1(1,0.93333,0.266666,0.4):effectcolor2(1,1,1,1):effectperiod(0.25):effectmagnitude(0,1,0):diffusealpha(0):sleep(9.7):linear(0):diffusealpha(1):sleep(1.7):linear(0):diffusealpha(0) end
		},
		LoadActor("tapglow") .. {
			OnCommand=function(self) self:x(212):y(95):zoom(0.7):rotationz(180):diffuseshift():effectcolor1(1,0.93333,0.266666,0.4):effectcolor2(1,1,1,1):effectperiod(0.25):effectmagnitude(0,1,0):diffusealpha(0):sleep(12.7):linear(0):diffusealpha(1):sleep(1.7):linear(0):diffusealpha(0) end
		},
		LoadActor("tapglow") .. {
			OnCommand=function(self) self:x(84):y(95):zoom(0.7):rotationz(90):diffuseshift():effectcolor1(1,0.93333,0.266666,0.4):effectcolor2(1,1,1,1):effectperiod(0.25):effectmagnitude(0,1,0):diffusealpha(0):sleep(15.7):linear(0):diffusealpha(1):sleep(1.7):linear(0):diffusealpha(0) end
		},
		LoadActor("tapglow") .. {
			OnCommand=function(self) self:x(85):y(95):zoom(0.7):rotationz(90):diffuseshift():effectcolor1(1,0.93333,0.266666,0.4):effectcolor2(1,1,1,1):effectperiod(0.25):effectmagnitude(0,1,0):diffusealpha(0):sleep(18.7):linear(0):diffusealpha(1):sleep(1.7):linear(0):diffusealpha(0) end
		},
		LoadActor("tapglow") .. {
			OnCommand=function(self) self:x(275):y(95):zoom(0.7):rotationz(270):diffuseshift():effectcolor1(1,0.93333,0.266666,0.4):effectcolor2(1,1,1,1):effectperiod(0.25):effectmagnitude(0,1,0):diffusealpha(0):sleep(18.7):linear(0):diffusealpha(1):sleep(1.7):linear(0):diffusealpha(0) end
		},
		LoadActor("healthhilight") .. {
			OnCommand=function(self) self:x(180):y(40):diffuseshift():effectcolor1(1,0.93333,0.266666,0.4):effectcolor2(1,1,1,1):effectperiod(0.25):effectmagnitude(0,1,0):diffusealpha(0):sleep(22.7):linear(0):diffusealpha(1):sleep(1.7):linear(0):diffusealpha(0) end
		}
	},
	LoadFont("Common Bold") .. {
		Text=ScreenString("How To Play StepMania"),
		InitCommand=function(self) self:zbuffer(1):z(20):Center():shadowlength(1):strokecolor(Color("Outline")) end,
		BeginCommand=function(self)
			self:AddAttribute(12, {Length=9, Diffuse=Color.White})
		end,
		OnCommand=function(self) self:skewx(-0.125):diffuse(color("#ffd400")):shadowlength(2):shadowcolor(BoostColor(color("#ffd40077"),0.25)):diffusealpha(0):zoom(4):sleep(0.0):linear(0.3):diffusealpha(1):zoom(1):sleep(1.8):linear(0.3):zoom(0.75):x(170):y(60) end
	},
	LoadActor("_howtoplay feet") .. {
		InitCommand=function(self) self:shadowlength(1):strokecolor(Color.Outline) end,
		OnCommand=function(self) self:z(20):Center():addx(-SCREEN_WIDTH):sleep(2.4):decelerate(0.3):addx(SCREEN_WIDTH):sleep(2):linear(0.3):zoomy(0) end
	},
	Def.ActorFrame {
		InitCommand=function(self) self:x(SCREEN_CENTER_X+120):y(SCREEN_CENTER_Y+40) end,
		LoadActor("_howtoplay tap")..{
			InitCommand=function(self) self:diffusealpha(0) end,
			ShowCommand=function(self) self:linear(0):diffusealpha(1):sleep(2):linear(0):diffusealpha(0) end,
			OnCommand=function(self) self:sleep(6):queuecommand("Show") end
		},
		LoadActor("_howtoplay tap")..{
			InitCommand=function(self) self:diffusealpha(0) end,
			ShowCommand=function(self) self:linear(0):diffusealpha(1):sleep(2):linear(0):diffusealpha(0) end,
			OnCommand=function(self) self:sleep(9.7):queuecommand("Show") end
		},
		LoadActor("_howtoplay tap")..{
			InitCommand=function(self) self:diffusealpha(0) end,
			ShowCommand=function(self) self:linear(0):diffusealpha(1):sleep(2):linear(0):diffusealpha(0) end,
			OnCommand=function(self) self:sleep(12.7):queuecommand("Show") end
		},
		LoadActor("_howtoplay tap")..{
			InitCommand=function(self) self:diffusealpha(0) end,
			ShowCommand=function(self) self:linear(0):diffusealpha(1):sleep(2):linear(0):diffusealpha(0) end,
			OnCommand=function(self) self:sleep(15.7):queuecommand("Show") end
		},
		LoadActor("_howtoplay jump")..{
			InitCommand=function(self) self:diffusealpha(0) end,
			ShowCommand=function(self) self:linear(0):diffusealpha(1):sleep(2):linear(0):diffusealpha(0) end,
			OnCommand=function(self) self:sleep(18.7):queuecommand("Show") end
		},
		LoadActor("_howtoplay miss")..{
			InitCommand=function(self) self:diffusealpha(0) end,
			ShowCommand=function(self) self:linear(0):diffusealpha(1):sleep(2):linear(0):diffusealpha(0) end,
			OnCommand=function(self) self:sleep(22.7):queuecommand("Show") end
		}
	}
}