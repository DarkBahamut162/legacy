local sString
return Def.ActorFrame{
	Def.BitmapText{
		Font= "Common normal",
		InitCommand=function(self) self:shadowlength(1):horizalign(left):zoom(0.45):skewx(-0.125) end,
		SetMessageCommand=function(self,param)
			sString = THEME:GetString("StepsListDisplayRow StepsType",ToEnumShortString(param.StepsType))
			if param.Steps and param.Steps:IsAutogen() then
				self:diffusebottomedge(color("0.75,0.75,0.75,1"))
			else
				self:diffuse(Color("White"))
			end
			self:settext( sString )
		end
	}
}