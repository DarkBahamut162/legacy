return Def.ActorFrame {
    Name="YOU_WISH_YOU_WERE_PLAYING_BEATMANIA_RIGHT_NOW",
    OnCommand=function(self)
        for pn in ivalues(GAMESTATE:GetEnabledPlayers()) do
            if GAMESTATE:GetPlayMode() == 'PlayMode_Rave' then
                if SCREENMAN:GetTopScreen():GetChild("Player"..pname(pn)) then
					SCREENMAN:GetTopScreen():GetChild("Player"..pname(pn)):x(THEME:GetMetric("ScreenGameplay","Player"..pname(pn).."OnePlayerOneSideX"))
                end
            end
        end
    end
}