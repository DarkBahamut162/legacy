function GetLocalProfiles()
	local ret = {}

	for p = 0,PROFILEMAN:GetNumLocalProfiles()-1 do
		local profile=PROFILEMAN:GetLocalProfileFromIndex(p)
		table.insert( ret, Def.ActorFrame {
			Def.BitmapText{
				Font= "Common Normal",
				Text=profile:GetDisplayName(),
				InitCommand=function(self) self:shadowlength(1):y(-10*WideScreenDiff()):zoom(1*WideScreenDiff()):ztest(true) end
			},
			Def.BitmapText{
				Font= "Common Normal",
				InitCommand=function(self) self:shadowlength(1):y(8*WideScreenDiff()):zoom(0.5*WideScreenDiff()):vertspacing(-8*WideScreenDiff()):ztest(true) end,
				BeginCommand=function(self)
					local numSongsPlayed = profile:GetNumTotalSongsPlayed()
					local s = numSongsPlayed == 1 and "Song" or "Songs"
					self:settext( string.format(THEME:GetString("ScreenSelectProfile","%d "..s.." Played"),numSongsPlayed) )
				end
			}
		} )
	end

	return ret
end

function LoadCard(cColor)
	local t = Def.ActorFrame {
		Def.Sprite{
			Texture= THEME:GetPathG("ScreenSelectProfile","CardBackground"),
			InitCommand=function(self) self:diffuse(cColor) end,
		},
		Def.Sprite{ Texture= THEME:GetPathG("ScreenSelectProfile","CardFrame") }
	}
	return t
end
function LoadPlayerStuff(Player)
	local pn = (Player == PLAYER_1) and 1 or 2

	return {
		Def.ActorFrame {
			Name = 'JoinFrame',
			LoadCard(Color('Orange')),
			Def.BitmapText{
				Font= "Common Normal",
				Text=THEME:GetString("ScreenSelectProfile","PressStart"),
				InitCommand=function(self) self:shadowlength(1) end,
				OnCommand=function(self) self:diffuseshift():effectcolor1(Color('White')):effectcolor2(color("0.5,0.5,0.5")) end
			}
		},
		Def.ActorFrame {
			Name = 'BigFrame',
			LoadCard(PlayerColor(Player))
		},
		Def.ActorFrame {
			Name = 'SmallFrame',
			InitCommand=function(self) self:y(-2) end,
			Def.Quad {
				InitCommand=function(self) self:zoomto(200-10,40+2) end,
				OnCommand=function(self) self:diffuse(Color('Black')):diffusealpha(0.5) end
			},
			Def.Quad {
				InitCommand=function(self) self:zoomto(200-10,40) end,
				OnCommand=function(self) self:diffuse(PlayerColor(Player)):fadeleft(0.25):faderight(0.25):glow(color("1,1,1,0.25")) end
			},
			Def.Quad {
				InitCommand=function(self) self:zoomto(200-10,40):y(-40/2+20) end,
				OnCommand=function(self) self:diffuse(Color("Black")):fadebottom(1):diffusealpha(0.35) end
			},
			Def.Quad {
				InitCommand=function(self) self:zoomto(200-10,1):y(-40/2+1) end,
				OnCommand=function(self) self:diffuse(PlayerColor(Player)):glow(color("1,1,1,0.25")) end
			}
		},
		Def.ActorScroller{
			Name = 'ProfileScroller',
			NumItemsToDraw=6,
			OnCommand=function(self) self:y(1):SetFastCatchup(true):SetMask(200,58):SetSecondsPerItem(0.15) end,
			TransformFunction=function(self, offset, itemIndex, numItems)
				local focus = scale(math.abs(offset),0,2,1,0)
				self:visible(false):y(math.floor( offset*40 ))
			end,
			children = GetLocalProfiles()
		},
		Def.ActorFrame {
			Name = "EffectFrame"
		},
		Def.BitmapText{
			Font= "Common Normal",
			Name = 'SelectedProfileText',
			InitCommand=function(self) self:y(160):shadowlength(1) end
		}
	}
end

function UpdateInternal3(self, Player)
	local pn = (Player == PLAYER_1) and 1 or 2
	local frame = self:GetChild(string.format('P%uFrame', pn))
	local scroller = frame:GetChild('ProfileScroller')
	local seltext = frame:GetChild('SelectedProfileText')
	local joinframe = frame:GetChild('JoinFrame')
	local smallframe = frame:GetChild('SmallFrame')
	local bigframe = frame:GetChild('BigFrame')

	if GAMESTATE:IsHumanPlayer(Player) then
		frame:visible(true)
		if MEMCARDMAN:GetCardState(Player) == 'MemoryCardState_none' then
			joinframe:visible(false)
			smallframe:visible(true)
			bigframe:visible(true)
			seltext:visible(true)
			scroller:visible(true)
			local ind = SCREENMAN:GetTopScreen():GetProfileIndex(Player)
			if ind > 0 then
				scroller:SetDestinationItem(ind-1)
				seltext:settext(PROFILEMAN:GetLocalProfileFromIndex(ind-1):GetDisplayName())
			else
				if SCREENMAN:GetTopScreen():SetProfileIndex(Player, 1) then
					scroller:SetDestinationItem(0)
					self:queuecommand('UpdateInternal2')
				else
					joinframe:visible(true)
					smallframe:visible(false)
					bigframe:visible(false)
					scroller:visible(false)
					seltext:settext('No profile')
				end
			end
		else
			smallframe:visible(false)
			scroller:visible(false)
			seltext:settext('CARD')
			SCREENMAN:GetTopScreen():SetProfileIndex(Player, 0)
		end
	else
		joinframe:visible(true)
		scroller:visible(false)
		seltext:visible(false)
		smallframe:visible(false)
		bigframe:visible(false)
	end
end

local main_frame= false

local function input(event)
	if event.type == "InputEventType_Release" then return end
	local pn= event.PlayerNumber
	local code= event.GameButton
	if not pn or not code then return end
	local input_functions= {
		Start= function()
			MESSAGEMAN:Broadcast("StartButton")
			if not GAMESTATE:IsHumanPlayer(pn) then
				SCREENMAN:GetTopScreen():SetProfileIndex(pn, -1)
			else
				SCREENMAN:GetTopScreen():Finish()
			end
		end,
		Back= function()
			if GAMESTATE:GetNumPlayersEnabled()==0 then
				SCREENMAN:GetTopScreen():Cancel()
			else
				MESSAGEMAN:Broadcast("BackButton")
				SCREENMAN:GetTopScreen():SetProfileIndex(pn, -2)
			end
		end,
		MenuUp= function()
			if GAMESTATE:IsHumanPlayer(pn) then
				local ind = SCREENMAN:GetTopScreen():GetProfileIndex(pn)
				if ind > 1 then
					if SCREENMAN:GetTopScreen():SetProfileIndex(pn, ind - 1) then
						MESSAGEMAN:Broadcast("DirectionButton")
						main_frame:queuecommand('UpdateInternal2')
					end
				end
			end
		end,
		MenuDown= function()
			if GAMESTATE:IsHumanPlayer(pn) then
				local ind = SCREENMAN:GetTopScreen():GetProfileIndex(pn)
				if ind > 0 then
					if SCREENMAN:GetTopScreen():SetProfileIndex(pn, ind + 1) then
						MESSAGEMAN:Broadcast("DirectionButton")
						main_frame:queuecommand('UpdateInternal2')
					end
				end
			end
		end
	}
	input_functions.MenuLeft= input_functions.MenuUp
	input_functions.MenuRight= input_functions.MenuDown
	if input_functions[code] then
		input_functions[code]()
	end
end

return Def.ActorFrame {
	StorageDevicesChangedMessageCommand=function(self, params)
		self:queuecommand('UpdateInternal2')
	end,
	PlayerJoinedMessageCommand=function(self, params)
		self:queuecommand('UpdateInternal2')
	end,
	PlayerUnjoinedMessageCommand=function(self, params)
		self:queuecommand('UpdateInternal2')
	end,
	OnCommand=function(self, params)
		main_frame= self:GetParent()
		SCREENMAN:GetTopScreen():AddInputCallback(input)
		self:queuecommand('UpdateInternal2')
	end,
	UpdateInternal2Command=function(self)
		UpdateInternal3(self, PLAYER_1)
		UpdateInternal3(self, PLAYER_2)
	end,
	children = {
		Def.ActorFrame {
			Name = 'P1Frame',
			InitCommand=function(self) self:x(SCREEN_CENTER_X-160*WideScreenDiff()):CenterY() end,
			OnCommand=function(self) self:zoom(0):bounceend(0.35):zoom(1*WideScreenDiff()) end,
			OffCommand=function(self) self:bouncebegin(0.35):zoom(0) end,
			PlayerJoinedMessageCommand=function(self,param)
				if param.Player == PLAYER_1 then
					self:zoom(1.15*WideScreenDiff()):bounceend(0.175):zoom(1.0*WideScreenDiff())
				end
			end,
			children = LoadPlayerStuff(PLAYER_1)
		},
		Def.ActorFrame {
			Name = 'P2Frame',
			InitCommand=function(self) self:x(SCREEN_CENTER_X+160*WideScreenDiff()):CenterY() end,
			OnCommand=function(self) self:zoom(0):bounceend(0.35):zoom(1*WideScreenDiff()) end,
			OffCommand=function(self) self:bouncebegin(0.35):zoom(0) end,
			PlayerJoinedMessageCommand=function(self,param)
				if param.Player == PLAYER_2 then
					self:zoom(1.15*WideScreenDiff()):bounceend(0.175):zoom(1.0*WideScreenDiff())
				end
			end,
			children = LoadPlayerStuff(PLAYER_2)
		},
		Def.Sound{
			File= THEME:GetPathS("Common","start"),
			IsAction= true,
			StartButtonMessageCommand=function(self) self:play() end
		},
		Def.Sound{
			File= THEME:GetPathS("Common","cancel"),
			IsAction= true,
			BackButtonMessageCommand=function(self) self:play() end
		},
		Def.Sound{
			File= THEME:GetPathS("Common","value"),
			IsAction= true,
			DirectionButtonMessageCommand=function(self) self:play() end
		}
	}
}
