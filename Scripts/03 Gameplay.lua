local tNotePositions = {
	Normal = { -144, 144, },
	Lower = { -125, 145, }
}

function GetTapPosition( sType )
	local bCategory = (sType == 'Standard') and 1 or 2
	local bPreference = ThemePrefs.Get("NotePosition") and "Normal" or "Lower"
	local tNotePos = tNotePositions[bPreference]
	return tNotePos[bCategory]
end

function ComboUnderField()
	return ThemePrefs.Get("ComboUnderField")
end