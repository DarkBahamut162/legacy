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
	if metric then 
		firstSec = song:GetFirstSecond() - firstSec + offset
		return math.max(firstSec, 1)
	else
		return song:GetFirstSecond() - firstSec + offset
	end
end

function BeginReadyDelay()
	local trueFirstSecond = MinSecondsToStep()
	local td = GetSong():GetTimingData()
	local bpm = round(td:GetBPMAtBeat(0),3)
	local m = 1
	
	if bpm > 240 then
		m =  2
	elseif bpm < 30 then
		m =  0.25
	elseif bpm < 60 then
		m =  0.5
	end
	
	local timeSigs = split('=', td:GetTimeSignatures()[1])
	local n = timeSigs[2]
	local d = timeSigs[3]
	local g_offset = round(PREFSMAN:GetPreference("GlobalOffsetSeconds"),3)
	
	local delay = trueFirstSecond-(60/bpm*12*m*(n/d))+g_offset
	
	if delay < 0 then
		delay = 0
	end
	
	return round(delay,3)
end

function SongMeasureSec()
	local MinSecondsToStep = MinSecondsToStep()
	local firstSecond = GetSong():GetFirstSecond()
	local firstBeat = GetSong():GetFirstBeat()
	local td = GetSong():GetTimingData()
	local bpm = round(td:GetBPMAtBeat(0),3)
	local trueFirstBeat = math.abs(MinSecondsToStep * (60/bpm)) + firstBeat
	local trueFirstSecond = math.abs(MinSecondsToStep) + firstSecond
	local timeSigs = split('=', td:GetTimeSignatures()[1])
	local n = timeSigs[2]
	local d = timeSigs[3]
	local sec = 0
	local m = 1
	
	if trueFirstBeat < 12 then
		if bpm <= 30 then
			sec = trueFirstSecond/6*(n/d)
		elseif bpm <= 60 then
			sec = trueFirstSecond/5*(n/d)
		elseif bpm <= 120 then
			sec = trueFirstSecond/4*(n/d)
		else
			sec = trueFirstSecond/3*(n/d)
		end
		if sec < 1 then sec = sec + 0.25 end
	else
		if bpm >= 240 then
			m = 2
		elseif bpm < 30 then
			m = 0.25
		elseif bpm < 60 then
			m = 0.5
		end
		sec = 60/bpm*4*m*(n/d)
	end

	-- check for BPMChanges between beat 0 and the first beat ~DarkBahamut162
	for k,v in pairs(td:GetBPMsAndTimes()) do
		local data = split('=', v)
		local numData = {tonumber(data[1]), tonumber(data[2])}
		numData[2] = math.round(numData[2] * 1000) / 1000
		if numData[1] > firstBeat then break end
		if numData[1] > 0 then
			sec = firstSecond + math.abs(GAMESTATE:GetCurMusicSeconds())
			sec = sec / 3
			break
		end
	end
	
	return sec
end