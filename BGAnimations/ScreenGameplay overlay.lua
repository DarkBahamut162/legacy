local t = Def.ActorFrame {
	InitCommand=function(self) self:SetUpdateFunction(UpdateTime) end
}
local function UpdateTime(self)
	local c = self:GetChildren()
	for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
		local vStats = STATSMAN:GetCurStageStats():GetPlayerStageStats( pn )
		local vTime
		local obj = self:GetChild( string.format("RemainingTime" .. PlayerNumberToString(pn) ) )
		if vStats and obj then
			vTime = vStats:GetLifeRemainingSeconds()
			obj:settext( SecondsToMMSSMsMs( vTime ) )
		end
	end
end
if GAMESTATE:GetCurrentCourse() then
	if GAMESTATE:GetCurrentCourse():GetCourseType() == "CourseType_Survival" then
		for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
			local MetricsName = "RemainingTime" .. PlayerNumberToString(pn)
			t[#t+1] = loadfile( THEME:GetPathG( Var "LoadingScreen", "RemainingTime"))( pn ) .. {
				InitCommand=function(self)
					self:player(pn)
					self:name(MetricsName)
					ActorUtil.LoadAllCommandsAndSetXY(self,Var "LoadingScreen")
				end
			}
		end
		for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
			local MetricsName = "DeltaSeconds" .. PlayerNumberToString(pn)
			t[#t+1] = loadfile( THEME:GetPathG( Var "LoadingScreen", "DeltaSeconds"))( pn ) .. {
				InitCommand=function(self)
					self:player(pn)
					self:name(MetricsName)
					ActorUtil.LoadAllCommandsAndSetXY(self,Var "LoadingScreen")
				end
			}
		end
	end
end

return t