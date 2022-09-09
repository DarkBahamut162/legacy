if not GAMESTATE:IsCourseMode() then return Def.ActorFrame{} end
local course = GAMESTATE:GetCurrentCourse()

return Def.ActorFrame{
	Def.Sprite{
		InitCommand=function(self) self:Center() end,
		BeginCommand=function(self)
			if course:GetBackgroundPath() then
				self:Load( course:GetBackgroundPath() )
			else
				self:LoadFromCurrentSongBackground()
			end
		end,
		OnCommand=function(self) self:diffusealpha(0):scale_or_crop_background():sleep(0.5):linear(0.50):diffusealpha(1):sleep(3) end
	},
	Def.Sprite{
		InitCommand=function(self) self:Center() end,
		BeginCommand=function(self) self:LoadFromCurrentSongBackground():scale_or_crop_background():diffusealpha(0) end,
		OnCommand=function(self) self:sleep(4):playcommand("Show") end,
		ShowCommand=function(self)
			if course:HasBackground() then
				self:accelerate(0.25)
				self:diffusealpha(1)
			end
		end
	}
}