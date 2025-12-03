-- VERSION CHECKS
function isStepMania()
	return ProductFamily() == "StepMania"
end

function isOldStepMania()
	return ProductFamily() == "StepMania" and not VersionDateCheck(20180000)
end

function isOutFox(version)
	local productCheck = ProductFamily() == "OutFox" or (isStepMania() and tonumber(split("-",ProductVersion())[1]) == 5.3)
	if version then return productCheck and VersionDateCheck(version) else return productCheck end
end

function isOutFoxV(version)
	local versionSplit = tonumber(split("-",ProductVersion())[1])
	local productCheck = isOutFox() and versionSplit >= 0.5 and versionSplit < 5
	if version then return productCheck and VersionDateCheck(version) else return productCheck end
end

function isOutFoxV043(version)
	if version then return isOutFoxV(20240000) and VersionDateCheck(version) else return isOutFoxV(20240000) end
end

function VersionDateCheck(version)
	return tonumber(VersionDate()) > version
end

-- SCREEN CHECKS
function WideScreenDiff()
	return math.min(1,GetScreenAspectRatio() / (4/3))
end

function WideScreenDiff_(aspect)
	return math.min(1,GetScreenAspectRatio() / aspect)
end

function WideScreenSemiDiff()
	return 1-(1-WideScreenDiff())*0.5
end

function WideScreenSemiDiff_(aspect)
	return 1-(1-WideScreenDiff_(aspect))*0.5
end

function WideScaleFixed(AR4_3, AR16_9)
	return clamp(scale( SCREEN_WIDTH, 640, 854, AR4_3, AR16_9 ), AR4_3, AR16_9)
end

-- ADDITIONAL FUNCTIONS
function FindInTable(needle, haystack)
	for i = 1, #haystack do
		if needle == haystack[i] then
			return i
		end
	end
	return nil
end

-- BUTTON CHECKS
local GameAndMenuButtons = {
	dance		= { "Left", "Down", "Up", "Right" },
	groove		= { "Left", "Down", "Up", "Right" },
	pump		= { "DownLeft", "UpLeft", "Center", "UpRight", "DownRight" },
	smx			= { "Left", "Down", "Up", "Right" },
	["be-mu"]	= { "Key1", "Key7", "Scratch up", "Scratch down" },
	techno		= { "Left", "Down", "Up", "Right" },
	["po-mu"]	= { "Left Yellow", "Left Blue", "Red", "Right Blue", "Right Yellow" },
}

local LocalizedGameButtons = {}

local DelocalizeGameButton = function(localized_btn)
	local game = GAMESTATE:GetCurrentGame():GetName()
	if not GameAndMenuButtons[game] then return false end

	local language = THEME:GetCurLanguage()
	if not LocalizedGameButtons[language] then
		local t = {}
		for gb in ivalues(GameAndMenuButtons[game]) do
			t[THEME:GetString("GameButton", gb)] = gb
		end
		LocalizedGameButtons[language] = t
	end

	return LocalizedGameButtons[language][localized_btn]
end

function IsGameAndMenuButton(localized_btn)
	if PREFSMAN:GetPreference("OnlyDedicatedMenuButtons") then return false end

	local btn = DelocalizeGameButton(localized_btn)
	if not btn then return false end

	return FindInTable(btn, GameAndMenuButtons[GAMESTATE:GetCurrentGame():GetName()])
end

function ScreenSelectStylePositions(count)
	local poses= {}
	local columns= 1
	local choice_height= 96*WideScreenDiff()
	local width_small = math.min(SCREEN_WIDTH/4-10,160)
	local width_big = math.min(SCREEN_WIDTH/3-10,240)
	local column_x= {_screen.cx, _screen.cx + width_small}
	if count > 4 then
		column_x[1]= _screen.cx - width_small
		columns= 2
	end
	if count > 8 then
		column_x[1]= _screen.cx - width_big
		column_x[2]= _screen.cx
		column_x[3]= _screen.cx + width_big
		columns= 3
	end
	local num_per_column= {math.ceil(count/columns), math.floor(count/columns)}
	if count > 8 then
		if count % 3 == 0 then
			num_per_column[3]= count/columns
		elseif count % 3 == 1 then
			num_per_column[3]= num_per_column[2]
		else
			num_per_column[3]= num_per_column[1]
		end
	end
	for c= 1, columns do
		local start_y= _screen.cy - (choice_height * ((num_per_column[c] / 2)+.5))
		for i= 1, num_per_column[c] do
			poses[#poses+1]= {column_x[c], start_y + (choice_height * i)}
		end
	end
	return poses
end