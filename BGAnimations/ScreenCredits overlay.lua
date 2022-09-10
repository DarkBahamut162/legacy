local line_on = function(self) self:zoom(0.875):strokecolor(color("#444444")):shadowcolor(color("#444444")):shadowlength(1) end
local section_on = function(self) self:diffuse( color("#88DDFF") ):strokecolor( color("#446688") ):shadowcolor( color("#446688")):shadowlength(1) end
local subsection_on = function(self) self:diffuse( color("#88DDFF") ):strokecolor( color("#446688") ):shadowcolor( color("#446688")):shadowlength(1) end
local item_padding_start = 4
local line_height= 30

StepManiaCredits.SetLineHeight(line_height)

local creditScroller = Def.ActorScroller {
	SecondsPerItem = 0.5,
	NumItemsToDraw = 40,
	TransformFunction = function( self, offset, itemIndex, numItems)
		self:y(line_height*offset)
	end,
	OnCommand = function( self )
		self:scrollwithpadding(item_padding_start,15)
	end
}

for section in ivalues(StepManiaCredits.Get()) do
	StepManiaCredits.AddLineToScroller(creditScroller, section.name, section_on)
	for name in ivalues(section) do
		if name.type == "subsection" then
			StepManiaCredits.AddLineToScroller(creditScroller, name, subsection_on)
		else
			StepManiaCredits.AddLineToScroller(creditScroller, name, line_on)
		end
	end
	StepManiaCredits.AddLineToScroller(creditScroller)
	StepManiaCredits.AddLineToScroller(creditScroller)
end

creditScroller.BeginCommand=function(self)
	SCREENMAN:GetTopScreen():PostScreenMessage( 'SM_MenuTimer', (creditScroller.SecondsPerItem * (#creditScroller + item_padding_start) + 10) )
end

return Def.ActorFrame{
	creditScroller..{
		InitCommand=function(self) self:xy( SCREEN_CENTER_X,SCREEN_BOTTOM-64 ) end
	},
	Def.Sprite{
		Texture=THEME:GetPathB("ScreenWithMenuElements","background/_bg top"),
		InitCommand=function(self) self:Center() end
	}
}
