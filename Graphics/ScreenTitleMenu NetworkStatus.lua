local netConnected = IsNetConnected()
local t = Def.ActorFrame{
	Def.Quad {
		InitCommand=function(self)
			self:y(-12):x(160):zoomto(320+32,38):vertalign(top):diffuse(Color.Black):diffusealpha(0.5) end,
		OnCommand=function(self) self:faderight(0.45) end,
		BeginCommand=function(self)
			if netConnected then
				self:zoomtoheight( 38 )
			else
				self:zoomtoheight( 24 )
			end
		end
	},
	Def.BitmapText{
		Font= "Common Normal",
		InitCommand=function(self) self:uppercase(true):zoom(0.75):shadowlength(1):horizalign(left) end,
		BeginCommand=function(self)
			if netConnected then
				self:diffuse( color("0.95,0.975,1,1") )
				self:diffusebottomedge( color("0.72,0.89,1,1") )
				self:settext( Screen.String("Network OK") )
			else
				self:diffuse( color("1,1,1,1") )
				self:settext( Screen.String("Offline") )
			end
		end
	}
}

if netConnected then
	t[#t+1] = Def.BitmapText{
		Font= "Common Normal",
		InitCommand=function(self)
			self:y(16):horizalign(left):zoom(0.5875):shadowlength(1):diffuse(color("0.72,0.89,1,1")) end,
		BeginCommand=function(self)
			self:settext( string.format(Screen.String("Connected to %s"), GetServerName()) )
		end
	}
end

return t