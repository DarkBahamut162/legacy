local grades = {
	Grade_Tier01 = 0,
	Grade_Tier02 = 1,
	Grade_Tier03 = 2,
	Grade_Tier04 = 3,
	Grade_Tier05 = 4,
	Grade_Tier06 = 5,
	Grade_Tier07 = 6,
	Grade_Failed = 7,
	Grade_None = 8
}

return Def.BitmapText{
	Font= "Common Normal",
	InitCommand=function(self) self:zoom(0.75):shadowlength(1):strokecolor(Color("Black")) end,
	ShowCommand=function(self) self:stoptweening():bounceend(0.15):zoomy(0.75) end,
	HideCommand=function(self) self:stoptweening():bouncebegin(0.15):zoomy(0) end,
	SetGradeCommand=function(self,params)
		local pnPlayer = params.PlayerNumber
		local sGrade = params.Grade or 'Grade_None'
		local gradeString = THEME:GetString("Grade",string.sub(sGrade,7))

		self:settext(gradeString)
		self:diffuse(PlayerColor(pnPlayer))
		self:diffusetopedge(BoostColor(PlayerColor(pnPlayer),1.5))
		self:strokecolor(BoostColor(PlayerColor(pnPlayer),0.25))
	end
}