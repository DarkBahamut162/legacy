local iconPath = "_timingicons"
local colX = -138

local showCmd = function(self) self:stoptweening():accelerate(0.1):diffusealpha(1) end
local hideCmd = function(self) self:stoptweening():accelerate(0.1):diffusealpha(0) end

local SegmentTypes = {
	Stops	=	{ Frame = 0, xPos = colX-15, yPos = -2.5+16*(0-2) },
	Delays	=	{ Frame = 1, xPos = colX-15, yPos = -2.5+16*(1-2) },
	Warps	=	{ Frame = 2, xPos = colX-15, yPos = -2.5+16*(2-2) },
	Scrolls	=	{ Frame = 3, xPos = colX, yPos = -2.5+16*(0-2) },
	Speeds	=	{ Frame = 4, xPos = colX, yPos = -2.5+16*(1-2) },
	Fakes	=	{ Frame = 5, xPos = colX, yPos = -2.5+16*(2-2) },
	Attacks	=	{ Frame = 6, xPos = colX, yPos = -2.5+16*(3-2) },
}

return Def.ActorFrame{
	BeginCommand=function(self) self:playcommand("SetIcons",{Player = GAMESTATE:GetEnabledPlayers()}) end,
	SetIconsCommand=function(self,param)
		for i, pn in ipairs(param.Player) do
			local stops = self:GetChild("StopsIcon"..ToEnumShortString(pn))
			local delays = self:GetChild("DelaysIcon"..ToEnumShortString(pn))
			local warps = self:GetChild("WarpsIcon"..ToEnumShortString(pn))
			local scrolls = self:GetChild("ScrollsIcon"..ToEnumShortString(pn))
			local speeds = self:GetChild("SpeedsIcon"..ToEnumShortString(pn))
			local fakes = self:GetChild("FakesIcon"..ToEnumShortString(pn))
			local attacks = self:GetChild("AttacksIcon"..ToEnumShortString(pn))

			local song = GAMESTATE:GetCurrentSong()
			local timing
			local step = GAMESTATE:GetCurrentSteps(pn)
			if song then
				if step then
					timing = step:GetTimingData()
				else
					timing = song:GetTimingData()
				end

				if timing:HasStops() then stops:playcommand("Show")
				else stops:playcommand("Hide")
				end

				if timing:HasDelays() then delays:playcommand("Show")
				else delays:playcommand("Hide")
				end

				if timing:HasWarps() then warps:playcommand("Show")
				else warps:playcommand("Hide")
				end

				if timing:HasScrollChanges() then scrolls:playcommand("Show")
				else scrolls:playcommand("Hide")
				end

				if timing:HasSpeedChanges() then speeds:playcommand("Show")
				else speeds:playcommand("Hide")
				end

				if timing:HasFakes() then fakes:playcommand("Show")
				else fakes:playcommand("Hide")
				end

				if song:HasAttacks() then attacks:playcommand("Show")
				else attacks:playcommand("Hide")
				end
			else
				stops:playcommand("Hide")
				delays:playcommand("Hide")
				warps:playcommand("Hide")
				scrolls:playcommand("Hide")
				speeds:playcommand("Hide")
				fakes:playcommand("Hide")
				attacks:playcommand("Hide")
			end
		end
	end,
	Def.Sprite{
		Texture= THEME:GetPathG("ScreenSelectMusic","SegmentDisplay/"..iconPath),
		Name="StopsIconP1",
		InitCommand=function(self) self:animate(false):x(SegmentTypes.Stops.xPos):y(SegmentTypes.Stops.yPos):setstate(SegmentTypes.Stops.Frame):diffusealpha(0) end,
		ShowCommand=showCmd,
		HideCommand=hideCmd
	},
	Def.Sprite{
		Texture= THEME:GetPathG("ScreenSelectMusic","SegmentDisplay/"..iconPath),
		Name="DelaysIconP1",
		InitCommand=function(self) self:animate(false):x(SegmentTypes.Delays.xPos):y(SegmentTypes.Delays.yPos):setstate(SegmentTypes.Delays.Frame):diffusealpha(0) end,
		ShowCommand=showCmd,
		HideCommand=hideCmd
	},
	Def.Sprite{
		Texture= THEME:GetPathG("ScreenSelectMusic","SegmentDisplay/"..iconPath),
		Name="WarpsIconP1",
		InitCommand=function(self) self:animate(false):x(SegmentTypes.Warps.xPos):y(SegmentTypes.Warps.yPos):setstate(SegmentTypes.Warps.Frame):diffusealpha(0) end,
		ShowCommand=showCmd,
		HideCommand=hideCmd
	},
	Def.Sprite{
		Texture= THEME:GetPathG("ScreenSelectMusic","SegmentDisplay/"..iconPath),
		Name="ScrollsIconP1",
		InitCommand=function(self) self:animate(false):x(SegmentTypes.Scrolls.xPos):y(SegmentTypes.Scrolls.yPos):setstate(SegmentTypes.Scrolls.Frame):diffusealpha(0) end,
		ShowCommand=showCmd,
		HideCommand=hideCmd
	},
	Def.Sprite{
		Texture= THEME:GetPathG("ScreenSelectMusic","SegmentDisplay/"..iconPath),
		Name="SpeedsIconP1",
		InitCommand=function(self) self:animate(false):x(SegmentTypes.Speeds.xPos):y(SegmentTypes.Speeds.yPos):setstate(SegmentTypes.Speeds.Frame):diffusealpha(0) end,
		ShowCommand=showCmd,
		HideCommand=hideCmd
	},
	Def.Sprite{
		Texture= THEME:GetPathG("ScreenSelectMusic","SegmentDisplay/"..iconPath),
		Name="FakesIconP1",
		InitCommand=function(self) self:animate(false):x(SegmentTypes.Fakes.xPos):y(SegmentTypes.Fakes.yPos):setstate(SegmentTypes.Fakes.Frame):diffusealpha(0) end,
		ShowCommand=showCmd,
		HideCommand=hideCmd
	},
	Def.Sprite{
		Texture= THEME:GetPathG("ScreenSelectMusic","SegmentDisplay/"..iconPath),
		Name="AttacksIconP1",
		InitCommand=function(self) self:animate(false):x(SegmentTypes.Attacks.xPos):y(SegmentTypes.Attacks.yPos):setstate(SegmentTypes.Attacks.Frame):diffusealpha(0) end,
		ShowCommand=showCmd,
		HideCommand=hideCmd
	},
	Def.Sprite{
		Texture= THEME:GetPathG("ScreenSelectMusic","SegmentDisplay/"..iconPath),
		Name="StopsIconP2",
		InitCommand=function(self) self:animate(false):x(-SegmentTypes.Stops.xPos):y(SegmentTypes.Stops.yPos):setstate(SegmentTypes.Stops.Frame):diffusealpha(0) end,
		ShowCommand=showCmd,
		HideCommand=hideCmd
	},
	Def.Sprite{
		Texture= THEME:GetPathG("ScreenSelectMusic","SegmentDisplay/"..iconPath),
		Name="DelaysIconP2",
		InitCommand=function(self) self:animate(false):x(-SegmentTypes.Delays.xPos):y(SegmentTypes.Delays.yPos):setstate(SegmentTypes.Delays.Frame):diffusealpha(0) end,
		ShowCommand=showCmd,
		HideCommand=hideCmd
	},
	Def.Sprite{
		Texture= THEME:GetPathG("ScreenSelectMusic","SegmentDisplay/"..iconPath),
		Name="WarpsIconP2",
		InitCommand=function(self) self:animate(false):x(-SegmentTypes.Warps.xPos):y(SegmentTypes.Warps.yPos):setstate(SegmentTypes.Warps.Frame):diffusealpha(0) end,
		ShowCommand=showCmd,
		HideCommand=hideCmd
	},
	Def.Sprite{
		Texture= THEME:GetPathG("ScreenSelectMusic","SegmentDisplay/"..iconPath),
		Name="ScrollsIconP2",
		InitCommand=function(self) self:animate(false):x(-SegmentTypes.Scrolls.xPos):y(SegmentTypes.Scrolls.yPos):setstate(SegmentTypes.Scrolls.Frame):diffusealpha(0) end,
		ShowCommand=showCmd,
		HideCommand=hideCmd
	},
	Def.Sprite{
		Texture= THEME:GetPathG("ScreenSelectMusic","SegmentDisplay/"..iconPath),
		Name="SpeedsIconP2",
		InitCommand=function(self) self:animate(false):x(-SegmentTypes.Speeds.xPos):y(SegmentTypes.Speeds.yPos):setstate(SegmentTypes.Speeds.Frame):diffusealpha(0) end,
		ShowCommand=showCmd,
		HideCommand=hideCmd
	},
	Def.Sprite{
		Texture= THEME:GetPathG("ScreenSelectMusic","SegmentDisplay/"..iconPath),
		Name="FakesIconP2",
		InitCommand=function(self) self:animate(false):x(-SegmentTypes.Fakes.xPos):y(SegmentTypes.Fakes.yPos):setstate(SegmentTypes.Fakes.Frame):diffusealpha(0) end,
		ShowCommand=showCmd,
		HideCommand=hideCmd
	},
	Def.Sprite{
		Texture= THEME:GetPathG("ScreenSelectMusic","SegmentDisplay/"..iconPath),
		Name="AttacksIconP2",
		InitCommand=function(self) self:animate(false):x(-SegmentTypes.Attacks.xPos):y(SegmentTypes.Attacks.yPos):setstate(SegmentTypes.Attacks.Frame):diffusealpha(0) end,
		ShowCommand=showCmd,
		HideCommand=hideCmd
	},
	CurrentSongChangedMessageCommand=function(self) self:playcommand("SetIcons",{Player = GAMESTATE:GetEnabledPlayers()}) end,
	CurrentStepsP1ChangedMessageCommand=function(self) self:playcommand("SetIcons",{Player = {PLAYER_1}}) end,
	CurrentStepsP2ChangedMessageCommand=function(self) self:playcommand("SetIcons",{Player = {PLAYER_2}}) end
}