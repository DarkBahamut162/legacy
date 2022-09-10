local c
local cf
local canAnimate = false
local player = Var "Player"
local ShowComboAt = THEME:GetMetric("Combo", "ShowComboAt")
local Pulse = THEME:GetMetric("Combo", "PulseCommand")
local PulseLabel = THEME:GetMetric("Combo", "PulseLabelCommand")

local NumberMinZoom = THEME:GetMetric("Combo", "NumberMinZoom")
local NumberMaxZoom = THEME:GetMetric("Combo", "NumberMaxZoom")
local NumberMaxZoomAt = THEME:GetMetric("Combo", "NumberMaxZoomAt")

local LabelMinZoom = THEME:GetMetric("Combo", "LabelMinZoom")
local LabelMaxZoom = THEME:GetMetric("Combo", "LabelMaxZoom")

local ShowFlashyCombo = ThemePrefs.Get("FlashyCombo")

return Def.ActorFrame {
	InitCommand=function(self) self:vertalign(bottom) end,
 	loadfile(THEME:GetPathG("Combo","100Milestone"))() .. {
		Name="OneHundredMilestone",
		InitCommand=function(self) self:visible(ShowFlashyCombo) end,
		FiftyMilestoneCommand=function(self) self:playcommand("Milestone") end,
	},
	loadfile(THEME:GetPathG("Combo","1000Milestone"))() .. {
		Name="OneThousandMilestone",
		InitCommand=function(self) self:visible(ShowFlashyCombo) end,
		ToastyAchievedMessageCommand=function(self) self:playcommand("Milestone") end,
	},
	Def.ActorFrame {
		Name="ComboFrame",
		Def.BitmapText{
			Font= THEME:GetPathF("Combo", "numbers"),
			Name="Number",
			OnCommand = THEME:GetMetric("Combo", "NumberOnCommand")
		},
		Def.Sprite{
			Texture= THEME:GetPathG("Player", "Combo/_combo"),
			Name="ComboLabel",
			OnCommand = THEME:GetMetric("Combo", "ComboLabelOnCommand")
		},
		Def.Sprite{
			Texture= THEME:GetPathG("Player", "Combo/_misses"),
			Name="MissLabel",
			OnCommand = THEME:GetMetric("Combo", "MissLabelOnCommand")
		}
	},
	InitCommand = function(self)
		c = self:GetChildren()
		cf = c.ComboFrame:GetChildren()
		cf.Number:visible(false)
		cf.ComboLabel:visible(false)
		cf.MissLabel:visible(false)
	end,
 	TwentyFiveMilestoneCommand=function(self,parent)
		if ShowFlashyCombo then
			self:finishtweening():addy(-4):bounceend(0.125):addy(4)
		end
	end,
	ComboCommand=function(self, param)
		local iCombo = param.Misses or param.Combo
		if not iCombo or iCombo < ShowComboAt then
			cf.Number:visible(false)
			cf.ComboLabel:visible(false)
			cf.MissLabel:visible(false)
			return
		end

		cf.ComboLabel:visible(false)
		cf.MissLabel:visible(false)

		param.Zoom = scale( iCombo, 0, NumberMaxZoomAt, NumberMinZoom, NumberMaxZoom )
		param.Zoom = clamp( param.Zoom, NumberMinZoom, NumberMaxZoom )

		param.LabelZoom = scale( iCombo, 0, NumberMaxZoomAt, LabelMinZoom, LabelMaxZoom )
		param.LabelZoom = clamp( param.LabelZoom, LabelMinZoom, LabelMaxZoom )

		if param.Combo then
			cf.ComboLabel:visible(true)
			cf.MissLabel:visible(false)
		else
			cf.ComboLabel:visible(false)
			cf.MissLabel:visible(true)
		end

		cf.Number:visible(true)
		cf.Number:settext( string.format("%i", iCombo) )
        cf.Number:textglowmode("TextGlowMode_Stroke")
		if param.FullComboW1 then
			cf.Number:diffuse( GameColor.Judgment["JudgmentLine_W1"] )
			cf.Number:strokecolor( GameColor.Judgment["JudgmentLine_W1"] )
            cf.Number:textglowmode("TextGlowMode_Stroke")
			cf.Number:glowshift()
		elseif param.FullComboW2 then
			cf.Number:diffuse( GameColor.Judgment["JudgmentLine_W2"] )
			cf.Number:strokecolor( GameColor.Judgment["JudgmentLine_W2"] )
            cf.Number:textglowmode("TextGlowMode_Stroke")
			cf.Number:glowshift()
		elseif param.FullComboW3 then
			cf.Number:diffuse( GameColor.Judgment["JudgmentLine_W3"] )
			cf.Number:strokecolor( GameColor.Judgment["JudgmentLine_W3"] )
            cf.Number:textglowmode("TextGlowMode_Stroke")
			cf.Number:glowshift()
		elseif param.Combo then
			cf.Number:diffuse(Color("White"))
			cf.Number:strokecolor(Color("Stealth"))
			cf.Number:stopeffect()
		else
			cf.Number:diffuse(color("#ff0000"))
			cf.Number:stopeffect()
		end
		Pulse( cf.Number, param )
		if param.Combo then
			PulseLabel( cf.ComboLabel, param )
		else
			PulseLabel( cf.MissLabel, param )
		end
	end
}
