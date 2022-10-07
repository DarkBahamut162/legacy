local profile= GAMESTATE:GetEditLocalProfile()

local cursor_width_padding = 16
local cursor_spacing_value = 30

local number_entry= new_numpad_entry{
	Name= "number_entry",
	InitCommand= function(self) self:diffusealpha( 0): xy( _screen.cx, _screen.cy * 1.5) end,
	value = Def.BitmapText{
		Font="Common Large",
		InitCommand=function(self) self:xy(0,-62) end,
		OnCommand=function(self) self:zoom(0.75):diffuse(PlayerColor(PLAYER_1)):strokecolor(ColorDarkTone(PlayerColor(PLAYER_1))) end,
		SetCommand=function(self, param)
			self:settext(param[1])
		end
	},
	button = Def.BitmapText{
		Font= "Common Normal",
		InitCommand=function(self) self:shadowlength(1) end,
		SetCommand=function(self, param)
			self:settext(param[1])
		end,
		OnCommand=function(self) self:diffuse(color("0.8,0.8,0.8,1")):zoom(0.875) end,
		GainFocusCommand=function(self) self:finishtweening():decelerate(0.125):zoom(1):diffuse(Color.White) end,
		LoseFocusCommand=function(self) self:finishtweening():smooth(0.1):zoom(0.875):diffuse(color("0.8,0.8,0.8,1")) end
	},
	button_positions = {{-cursor_spacing_value, -cursor_spacing_value}, {0, -cursor_spacing_value}, {cursor_spacing_value, -cursor_spacing_value},
		{-cursor_spacing_value, 0},   {0, 0},   {cursor_spacing_value, 0},
		{-cursor_spacing_value, cursor_spacing_value}, {0, cursor_spacing_value},   {cursor_spacing_value, cursor_spacing_value},
		{-cursor_spacing_value, cursor_spacing_value*2}, {0, cursor_spacing_value*2},   {cursor_spacing_value, cursor_spacing_value*2}},
	cursor = Def.ActorFrame {
		MoveCommand=function(self, param)
			self:stoptweening()
			self:decelerate(0.15)
			self:xy(param[1], param[2])
			if param[3] then
				self:z(param[3])
			end
		end,
		loadfile( THEME:GetPathG("_frame", "1D"))(
			{ 2/18, 14/18, 2/18 },
			Def.Sprite{ Texture= THEME:GetPathB("_frame", "cursors/rounded fill") }
		) .. {
			OnCommand=function(self) self:diffuse(PlayerDarkColor(PLAYER_1)) end,
			FitCommand=function(self, param)
				self:playcommand("SetSize",{ Width=param:GetWidth()+cursor_width_padding, tween=function(self) self:decelerate(0.125) end})
			end
		},
		loadfile( THEME:GetPathG("_frame", "1D"))(
			{ 2/18, 14/18, 2/18 },
			Def.Sprite{ Texture= THEME:GetPathB("_frame", "cursors/rounded gloss") }
		) .. {
			OnCommand=function(self) self:diffuse(PlayerColor(PLAYER_1)) end,
			FitCommand=function(self, param)
				self:playcommand("SetSize",{ Width=param:GetWidth()+cursor_width_padding, tween=function(self) self:decelerate(0.125) end})
			end
		}
	},
	cursor_draw= "first",
	prompt = Def.BitmapText{
		Font= "Common Bold",
		Name="prompt",
		InitCommand=function(self) self:xy(0,-96) end,
		OnCommand=function(self)
			self:shadowlength(1):skewx(-0.125):diffusebottomedge(color("#DDDDDD")):strokecolor(Color.Outline) end,
		SetCommand= function(self, params)
			self:settext(params[1])
		end
	},
	loadfile(THEME:GetPathB("_frame","3x3"))("rounded black", 128, 192) .. {
		InitCommand=function(self) self:xy( 0, -20) end
	}
}

local function calc_list_pos(value, list)
	for i, entry in ipairs(list) do
		if entry.setting == value then
			return i
		end
	end
	return 1
end

local function item_value_to_text(item, value)
	if item.item_type == "bool" then
		if value then
			value= THEME:GetString("ScreenOptionsCustomizeProfile", item.true_text)
		else
			value= THEME:GetString("ScreenOptionsCustomizeProfile", item.false_text)
		end
	elseif item.item_type == "list" then
		local pos= calc_list_pos(value, item.list)
		return item.list[pos].display_name
	end
	return value
end

local char_list= {}
do
	local all_chars= CHARMAN:GetAllCharacters()
	for i, char in ipairs(char_list) do
		char_list[#char_list+1]= {
			setting= char:GetCharacterID(), display_name= char:GetDisplayName()}
	end
end

local menu_items= {
	{name= "weight", get= "GetWeightPounds", set= "SetWeightPounds", item_type= "number", auto_done= 100},
	{name= "voomax", get= "GetVoomax", set= "SetVoomax", item_type= "number", auto_done= 10},
	{name= "birth_year", get= "GetBirthYear", set= "SetBirthYear", item_type= "number", auto_done= 1000},
	{name= "calorie_calc", get= "GetIgnoreStepCountCalories", set= "SetIgnoreStepCountCalories", item_type= "bool", true_text= "use_heart", false_text= "use_steps"},
	{name= "gender", get= "GetIsMale", set= "SetIsMale", item_type= "bool", true_text= "male", false_text= "female"}
}
if #char_list > 0 then
	menu_items[#menu_items+1]= {
		name= "character", get= "GetCharacter", set= "SetCharacter",
		item_type= "list", list= char_list}
end
menu_items[#menu_items+1]= {name= "exit", item_type= "exit"}

local menu_cursor
local menu_pos= 1
local menu_start= SCREEN_TOP + 80
if #menu_items > 6 then
	menu_start= SCREEN_TOP + 68
end
local menu_x= SCREEN_CENTER_X * 0.25
local value_x= ( SCREEN_CENTER_X * 0.25 ) + 256
local fader
local cursor_on_menu= "main"
local menu_item_actors= {}
local menu_values= {}
local list_pos= 0
local active_list= {}
local left_showing= false
local right_showing= false

local function fade_actor_to(actor, alf)
	actor:stoptweening()
	actor:smooth(.15)
	actor:diffusealpha(alf)
end

local function update_menu_cursor()
	local item= menu_item_actors[menu_pos]
	menu_cursor:playcommand("Move", {item:GetX(), item:GetY()})
	menu_cursor:playcommand("Fit", item)
end

local function update_list_cursor()
	local valactor= menu_values[menu_pos]
	valactor:playcommand("Set", {active_list[list_pos].display_name})
	if list_pos > 1 then
		if not left_showing then
			valactor:playcommand("ShowLeft")
			left_showing= true
		end
	else
		if left_showing then
			valactor:playcommand("HideLeft")
			left_showing= false
		end
	end
	if list_pos < #active_list then
		if not right_showing then
			valactor:playcommand("ShowRight")
			right_showing= true
		end
	else
		if right_showing then
			valactor:playcommand("HideRight")
			right_showing= false
		end
	end
end

local function exit_screen()
	local profile_id= GAMESTATE:GetEditLocalProfileID()
	PROFILEMAN:SaveLocalProfile(profile_id)
	SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen")
	SOUND:PlayOnce(THEME:GetPathS("Common", "Start"), true)
end

local function input(event)
	local pn= event.PlayerNumber
	if not pn then return false end
	if event.type == "InputEventType_Release" then return false end
	local button= event.GameButton
	if cursor_on_menu == "main" then
		if button == "Start" then
			local item= menu_items[menu_pos]
			if item.item_type == "bool" then
				local value= not profile[item.get](profile)
				menu_values[menu_pos]:playcommand(
					"Set", {item_value_to_text(item, value)})
				profile[item.set](profile, value)
			elseif item.item_type == "number" then
				fade_actor_to(number_entry.container, 1)
				number_entry.value= profile[item.get](profile)
				number_entry.value_actor:playcommand("Set", {number_entry.value})
				number_entry.auto_done_value= item.auto_done
				number_entry.max_value= item.max
				number_entry:update_cursor(number_entry.cursor_start)
				number_entry.prompt_actor:playcommand(
					"Set", {THEME:GetString("ScreenOptionsCustomizeProfile", item.name)})
				cursor_on_menu= "numpad"
			elseif item.item_type == "list" then
				cursor_on_menu= "list"
				active_list= menu_items[menu_pos].list
				list_pos= calc_list_pos(
					profile[menu_items[menu_pos].get](profile), active_list)
				update_list_cursor()
			elseif item.item_type == "exit" then
				exit_screen()
			end
		elseif button == "Back" then
			exit_screen()
		else
			if button == "MenuLeft" or button == "MenuUp" then
				if menu_pos > 1 then menu_pos= menu_pos - 1 end
				update_menu_cursor()
			elseif button == "MenuRight" or button == "MenuDown" then
				if menu_pos < #menu_items then menu_pos= menu_pos + 1 end
				update_menu_cursor()
			end
		end
	elseif cursor_on_menu == "numpad" then
		local done= number_entry:handle_input(button)
		if done or button == "Back" then
			local item= menu_items[menu_pos]
			if button ~= "Back" then
				profile[item.set](profile, number_entry.value)
				menu_values[menu_pos]:playcommand(
					"Set", {item_value_to_text(item, number_entry.value)})
			end
			fade_actor_to(number_entry.container, 0)
			cursor_on_menu= "main"
		end
	elseif cursor_on_menu == "list" then
		if button == "MenuLeft" or button == "MenuUp" then
			if list_pos > 1 then list_pos= list_pos - 1 end
			update_list_cursor()
			menu_values[menu_pos]:playcommand("PressLeft")
		elseif button == "MenuRight" or button == "MenuDown" then
			if list_pos < #active_list then list_pos= list_pos + 1 end
			update_list_cursor()
			menu_values[menu_pos]:playcommand("PressRight")
		elseif button == "Start" or button == "Back" then
			if button ~= "Back" then
				profile[menu_items[menu_pos].set](
					profile, active_list[list_pos].setting)
			end
			local valactor= menu_values[menu_pos]
			left_showing= false
			right_showing= false
			valactor:playcommand("HideLeft")
			valactor:playcommand("HideRight")
			cursor_on_menu= "main"
		end
	end
end

local args= {
	Def.Actor{
		OnCommand= function(self)
			update_menu_cursor()
			SCREENMAN:GetTopScreen():AddInputCallback(input)
		end
	},
	Def.ActorFrame {
		Name= "menu_cursor", InitCommand= function(self)
			menu_cursor= self
		end,
		MoveCommand=function(self, param)
			self:stoptweening()
			self:decelerate(0.15)
			self:xy(param[1], param[2])
			if param[3] then
				self:z(param[3])
			end
		end,
		FitCommand= function(self, param)
			self:addx(param:GetWidth()/2)
		end,
		loadfile( THEME:GetPathG("_frame", "1D"))(
			{ 2/18, 14/18, 2/18 },
			Def.Sprite{ Texture= THEME:GetPathB("_frame", "cursors/rounded fill") }
		) .. {
			OnCommand=function(self) self:diffuse(PlayerDarkColor(PLAYER_1)) end,
			FitCommand=function(self, param)
				self:playcommand("SetSize",{ Width=param:GetWidth()+cursor_width_padding, tween=function(self) self:stoptweening():decelerate(0.15) end})
			end
		},
		loadfile( THEME:GetPathG("_frame", "1D"))(
			{ 2/18, 14/18, 2/18 },
			Def.Sprite{ Texture= THEME:GetPathB("_frame", "cursors/rounded gloss") }
		) .. {
			OnCommand=function(self) self:diffuse(PlayerColor(PLAYER_1)) end,
			FitCommand=function(self, param)
				self:playcommand("SetSize",{ Width=param:GetWidth()+cursor_width_padding, tween=function(self) self:stoptweening():decelerate(0.15) end})
			end
		}
	},
}

for i, item in ipairs(menu_items) do
	local item_y= menu_start + ((i-1) * 24)
	args[#args+1]= Def.BitmapText{
		Name= "menu_" .. item.name, Font= "Common Normal",
		Text= THEME:GetString("ScreenOptionsCustomizeProfile", item.name),
		InitCommand= function(self)
			menu_item_actors[i]= self
			self:xy(menu_x, item_y)
			self:diffuse(Color.White)
			self:horizalign(left)
		end
	}
	if item.get then
		local value_text= item_value_to_text(item, profile[item.get](profile))
		local value_args= {
			Name= "value_" .. item.name,
			InitCommand= function(self)
				menu_values[i]= self
				self:xy(value_x, menu_start + ((i-1) * 24))
			end,
			Def.BitmapText{
				Name= "val", Font= "Common Normal", Text= value_text,
				InitCommand= function(self)
					self:diffuse(Color.White)
					self:horizalign(left)
				end,
				SetCommand= function(self, param)
					self:settext(param[1])
				end
			}
		}
		if item.item_type == "list" then
			value_args[#value_args+1]= Def.Sprite{
				Texture= THEME:GetPathG("_StepsDisplayListRow","arrow"),
				InitCommand= function(self)
					self:rotationy(-180)
					self:x(-8)
					self:visible(false)
					self:playcommand("Set", {value_text})
				end,
				ShowLeftCommand= function(self) self:visible( true) end,
				HideLeftCommand= function(self) self:visible( false) end,
				PressLeftCommand= function(self) self:finishtweening():zoom(1.5):smooth(0.25):zoom(1) end
			}
			value_args[#value_args+1]= Def.Sprite{
				Texture= THEME:GetPathG("_StepsDisplayListRow","arrow"),
				InitCommand= function(self)
					self:visible(false)
					self:playcommand("Set", {value_text})
				end,
				SetCommand= function(self)
					local valw= self:GetParent():GetChild("val"):GetWidth()
					self:x(valw+8)
				end,
				ShowRightCommand= function(self) self:visible(true) end,
				HideRightCommand= function(self) self:visible(false) end,
				PressRightCommand= function(self) self:finishtweening():zoom(1.5):smooth(0.25):zoom(1) end
			}
		end
		args[#args+1]= Def.ActorFrame(value_args)
	end
end

local _height = (#menu_items) * 24
args[#args+1]= loadfile(THEME:GetPathB("_frame", "3x3"))("rounded black",474,_height) .. {
	Name= "fader", InitCommand= function(self)
		fader= self
		self:draworder(-20)
		self:xy(menu_x + 474/2, menu_start + _height/2 - 12)
		self:diffuse(Color.Black)
		self:diffusealpha(0.75)
	end
}

args[#args+1]= number_entry:create_actors()

return Def.ActorFrame(args)
