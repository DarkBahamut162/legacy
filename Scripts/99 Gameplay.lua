function GetSong()
	if GAMESTATE:IsCourseMode() then
		local trail = GAMESTATE:GetCurrentTrail(GAMESTATE:GetMasterPlayerNumber())
		local tEntry = trail:GetTrailEntries()
		local i = GAMESTATE:GetLoadingCourseSongIndex()+1

		if tEntry[i] then
			return tEntry[i]:GetSong()
		end
	else
		return GAMESTATE:GetCurrentSong()
	end
end

function GetSMParameter(song,parameter)
	local filePath = song:GetSongFilePath()
	local suffix = string.match(filePath, '.+%.([^.]+)')
	if suffix ~= 'sm' and suffix ~= 'ssc' then return "" end
	local file = RageFileUtil.CreateRageFile()
	file:Open(filePath,1)
	file:Seek(0)
	local gLine = ""
	local line
	while true do
		if file then
			line = file:GetLine()
			if string.find(line,"#NOTES:.*") or string.find(line,"#NOTEDATA:.*") or file:AtEOF() then break
			elseif (string.find(line,"^.*#"..parameter..":.*") and (not string.find(line,"^%/%/.*"))) or gLine ~= "" then
				gLine = gLine..""..split("//",line)[1]
				if string.find(line,".*;") then break end
			end
		end
	end
	local tmp = {}
	if gLine == "" then
		tmp = {""}
	else
		tmp = split(":",gLine)
		if tmp[2] == ";" then
			tmp[1] = ""
		else
			if #tmp > 2 then
				tmp[1] = tmp[2]
				for i = 3, #tmp do
					tmp[1] = tmp[1]..":"..split(";",tmp[i])[1]
				end
			else
				tmp[1] = split(";",tmp[2])[1]
			end
		end
	end
	file:Close()
	file:destroy()
	return tmp[1]
end

function MinSecondsToStep(metric)
	local song = GetSong()
	local firstSec, firstBeat = 0, 999
	local firstBpm, offset = 60, 0
	local BGCHANGES = GetSMParameter(song,"BGCHANGES")
	local firstOffset = 0
	if #BGCHANGES > 0 then
		firstOffset = tonumber(split('=', split(',', BGCHANGES)[1])[1])
		if firstOffset < firstBeat then firstBeat = firstOffset end
	end
	local BPMS = GetSMParameter(song,"BPMS")
	if #BPMS > 0 then firstBpm = split('=', split(',', BPMS)[1])[2] end
	local OFFSET = GetSMParameter(song,"OFFSET")
	if #OFFSET > 0 then offset = OFFSET end
	if firstBeat < 999 then firstSec = firstBeat * 60 / firstBpm end

	firstSec = song:GetFirstSecond() - firstSec + offset
	return math.max(firstSec, 1)
end

function BeginReadyDelay()
	local trueFirstSecond = MinSecondsToStep()
	local td = GetSong():GetTimingData()
	local bpm = round(td:GetBPMAtBeat(0),3)
	local m = 1

	if bpm >= 240 then
		m = math.ceil(math.ceil(bpm/240)/2)*2
	else
		m = 1/(math.ceil(math.round(240/bpm)/2)*2)
	end

	local timeSigs = split('=', td:GetTimeSignatures()[1])
	local n = timeSigs[2]
	local d = timeSigs[3]
	local g_offset = round(PREFSMAN:GetPreference("GlobalOffsetSeconds"),3)

	local delay = trueFirstSecond-(60/bpm*12*m*(n/d))+g_offset

	if delay < 0 then delay = 0 end

	return round(delay,3)
end

function SongMeasureSec()
	return math.max((MinSecondsToStep()-BeginReadyDelay()) / 2,0.5)
end