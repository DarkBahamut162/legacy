local iPN = ...
assert(iPN,"[Graphics/PaneDisplay text.lua] No PlayerNumber Provided.")
local courseMode = GAMESTATE:IsCourseMode()

local function GetRadarData( pnPlayer, rcRadarCategory )
	local tRadarValues
	local StepsOrTrail
	local fDesiredValue = 0
	if GAMESTATE:GetCurrentSteps( pnPlayer ) then
		StepsOrTrail = GAMESTATE:GetCurrentSteps( pnPlayer )
		fDesiredValue = StepsOrTrail:GetRadarValues( pnPlayer ):GetValue( rcRadarCategory )
	elseif GAMESTATE:GetCurrentTrail( pnPlayer ) then
		StepsOrTrail = GAMESTATE:GetCurrentTrail( pnPlayer )
		fDesiredValue = StepsOrTrail:GetRadarValues( pnPlayer ):GetValue( rcRadarCategory )
	else
		StepsOrTrail = nil
	end
	return fDesiredValue
end

local function CreatePaneDisplayItem( _pnPlayer, _sLabel, _rcRadarCategory )
	return Def.ActorFrame {
		Def.BitmapText{
			Font= "Common Normal",
			Text=string.upper( THEME:GetString("PaneDisplay",_sLabel) ),
			InitCommand=function(self) self:horizalign(left) end,
			OnCommand=function(self) self:zoom(0.5):diffuse(color("0.9,0.9,0.9")):shadowlength(1) end
		},
		Def.BitmapText{
			Font= "Common Normal",
			Text=string.format("%04i", 0),
			InitCommand=function(self) self:x(96-24-2):horizalign(right) end,
			OnCommand=function(self) self:zoom(0.5):shadowlength(1) end,
			CurrentSongChangedMessageCommand=function(self) if not courseMode then self:playcommand("Set") end end,
			CurrentCourseChangedMessageCommand=function(self) if courseMode then self:playcommand("Set") end end,
			CurrentStepsP1ChangedMessageCommand=function(self) if not courseMode then self:playcommand("Set") end end,
			CurrentStepsP2ChangedMessageCommand=function(self) if not courseMode then self:playcommand("Set") end end,
			CurrentTrailP1ChangedMessageCommand=function(self) if courseMode then self:playcommand("Set") end end,
			CurrentTrailP2ChangedMessageCommand=function(self) if courseMode then self:playcommand("Set") end end,
			SetCommand=function(self)
				local song = GAMESTATE:GetCurrentSong()
				local course = GAMESTATE:GetCurrentCourse()
				if not song and not course then
					self:settextf("%04i", 0)
				else
					self:settextf("%04i", GetRadarData( _pnPlayer, _rcRadarCategory ) )
				end
			end
		}
	}
end

local function CreatePaneDisplayGraph( _pnPlayer, _sLabel, _rcRadarCategory )
	return Def.ActorFrame {
		Def.BitmapText{
			Font= "Common Normal",
			Text=_sLabel,
			InitCommand=function(self) self:horizalign(left) end,
			OnCommand=function(self) self:zoom(0.5):shadowlength(1) end
		},
		Def.Quad {
			InitCommand=function(self) self:x(12):zoomto(50,10):horizalign(left) end,
			OnCommand=function(self) self:diffuse(Color("Black")):shadowlength(1):diffusealpha(0.5) end
		},
		Def.Quad {
			InitCommand=function(self) self:x(12):zoomto(50,10):horizalign(left) end,
			OnCommand=function(self) self:shadowlength(0):diffuse(Color("Green")):diffusebottomedge(ColorLightTone(Color("Green"))) end,
			CurrentSongChangedMessageCommand=function(self) if not courseMode then self:playcommand("Set") end end,
			CurrentCourseChangedMessageCommand=function(self) if courseMode then self:playcommand("Set") end end,
			CurrentStepsP1ChangedMessageCommand=function(self) if not courseMode then self:playcommand("Set") end end,
			CurrentStepsP2ChangedMessageCommand=function(self) if not courseMode then self:playcommand("Set") end end,
			CurrentTrailP1ChangedMessageCommand=function(self) if courseMode then self:playcommand("Set") end end,
			CurrentTrailP2ChangedMessageCommand=function(self) if courseMode then self:playcommand("Set") end end,
			SetCommand=function(self)
				local song = GAMESTATE:GetCurrentSong()
				local course = GAMESTATE:GetCurrentCourse()
				if not song and not course then
					self:stoptweening()
					self:decelerate(0.2)
					self:zoomtowidth(0)
				else
					self:stoptweening()
					self:decelerate(0.2)
					self:zoomtowidth( clamp(GetRadarData( _pnPlayer, _rcRadarCategory ) * 50,0,50) )
				end
			end
		},
		Def.BitmapText{
			Font= "Common Normal",
			InitCommand=function(self) self:x(14+25):zoom(0.5):horizalign(center) end,
			OnCommand=function(self) self:shadowlength(1):strokecolor(color("0.15,0.15,0.15,0.625")) end,
			CurrentSongChangedMessageCommand=function(self) if not courseMode then self:playcommand("Set") end end,
			CurrentCourseChangedMessageCommand=function(self) if courseMode then self:playcommand("Set") end end,
			CurrentStepsP1ChangedMessageCommand=function(self) if not courseMode then self:playcommand("Set") end end,
			CurrentStepsP2ChangedMessageCommand=function(self) if not courseMode then self:playcommand("Set") end end,
			CurrentTrailP1ChangedMessageCommand=function(self) if courseMode then self:playcommand("Set") end end,
			CurrentTrailP2ChangedMessageCommand=function(self) if courseMode then self:playcommand("Set") end end,
			SetCommand=function(self)
				local song = GAMESTATE:GetCurrentSong()
				local course = GAMESTATE:GetCurrentCourse()
				if not song and not course then
					self:settext("")
				else
					self:settextf("%i%%", GetRadarData( _pnPlayer, _rcRadarCategory ) * 100 )
				end
			end
		}
	}
end

return Def.ActorFrame {
	Def.ActorFrame{
		CreatePaneDisplayItem( iPN, "Taps", 'RadarCategory_TapsAndHolds' ) .. {
			InitCommand=function(self) self:x(-128+16+8):y(-14) end
		},
		CreatePaneDisplayItem( iPN, "Jumps", 'RadarCategory_Jumps' ) .. {
			InitCommand=function(self) self:x(-128+16+8):y(-14+16) end
		},
		CreatePaneDisplayItem( iPN, "Holds", 'RadarCategory_Holds' ) .. {
			InitCommand=function(self) self:x(-128+16+8):y(-14+16*2) end
		},
		CreatePaneDisplayItem( iPN, "Mines", 'RadarCategory_Mines' ) .. {
			InitCommand=function(self) self:x(-128+16+8):y(-14+16*3) end
		},
		CreatePaneDisplayItem( iPN, "Hands", 'RadarCategory_Hands' ) .. {
			InitCommand=function(self) self:x(-128+16+8+74):y(-14) end
		},
		CreatePaneDisplayItem( iPN, "Rolls", 'RadarCategory_Rolls' ) .. {
			InitCommand=function(self) self:x(-128+16+8+74):y(-14+16) end
		},
		CreatePaneDisplayItem( iPN, "Lifts", 'RadarCategory_Lifts' ) .. {
			InitCommand=function(self) self:x(-128+16+8+74):y(-14+16*2) end
		},
		CreatePaneDisplayItem( iPN, "Fakes", 'RadarCategory_Fakes' ) .. {
			InitCommand=function(self) self:x(-128+16+8+74):y(-14+16*3) end
		},
		CreatePaneDisplayGraph( iPN, "S", 'RadarCategory_Stream' ) .. {
			InitCommand=function(self) self:x(-128+16+8+74*2):y(-14) end
		},
		CreatePaneDisplayGraph( iPN, "V", 'RadarCategory_Voltage' ) .. {
			InitCommand=function(self) self:x(-128+16+8+74*2):y(-14+12) end
		},
		CreatePaneDisplayGraph( iPN, "A", 'RadarCategory_Air' ) .. {
			InitCommand=function(self) self:x(-128+16+8+74*2):y(-14+12*2) end
		},
		CreatePaneDisplayGraph( iPN, "F", 'RadarCategory_Freeze' ) .. {
			InitCommand=function(self) self:x(-128+16+8+74*2):y(-14+12*3) end
		},
		CreatePaneDisplayGraph( iPN, "C", 'RadarCategory_Chaos' ) .. {
			InitCommand=function(self) self:x(-128+16+8+74*2):y(-14+12*4) end
		}
	}
}