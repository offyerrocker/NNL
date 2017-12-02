_G.LasersPlus = _G.LasersPlus or {}
local Lasers = Lasers or _G.LasersPlus

Lasers._path = ModPath
Lasers._data_path = Lasers._data_path or SavePath .. "lasersplus.txt"

--*****    Internal Values    *****
--Things that should not be changed
Lasers.LuaNetID = "lasersplus"
Lasers.LegacyID = "nncpl"
Lasers.LegacyID2 = "gmcpwlc"
Lasers.LegacyID3 = "nncpl_gr_v1" 
Lasers.last_peer_mode = {
	[1] = "none", --pizza with left beef
	[2] = "none",
	[3] = "none",
	[4] = "none"
	}
Lasers.last_mode = {
	["self"] = "none",
	["cop_turret"] = "none",
	["cop_sniper"] = "none"
}
Lasers.last_turret_mode = "none"
Lasers.last_sniper_mode = "none"
--can be any turret theme_type

Lasers.SavedTeamStrobes = Lasers.SavedTeamStrobes or {}
Lasers.SavedTeamColors = Lasers.SavedTeamColors or {}
Lasers.SavedTeamFlashlights = Lasers.SavedTeamFlashlights or {}
--[[
Lasers last peer mode[peerid_num] and secondary peer_display_type can be:
"none" (triggers init)
"color" (
"peer"


--]]

--*****    Default Settings    *****
--Default entries for settings

Lasers.debug_logs = true

Lasers.default_max_colors = 120 
--should it be a power of 2? but it's time based so idk, probably 120, assuming 30-60 fps.
--small differences would only affect length and performance on init anyway, and people don't generally mind a small hitch at the start(?)
--change this at your own risk

Lasers.low_quality_strobes = false
--local option, does not affect what others see. instant switch instead of slow gradients. overrides default_max_colors
--not currently implemented 

Lasers.default_speed = 1
--not currently implemented


--*****    Advanced Settings    *****
--[[
advanced settings definitions go here
--]]

--*****    UTILS    *****
function lp_log(message)
	if Lasers.debug_logs then
		log("Lasers+: " .. message)
	end
end


--Usage: init strobe( [Correctly formatted table of: table colors, and integer max_colors],[int max_colors or false])
--Used on initiate, at heist start, or at first instance of laser turning on,
--to generate a table of [max_colors] length, rather than generating it live every time you turn on a laser.
--that was horribly inefficient and i don't know why i did that.
--regrets.lua

--[[
design for init strobe and strobe step


when using strobe step, will it use that strobes's color_count?
or will it depend on the maximum_colors value determined in init strobe?

when using init strobe, will maximum_colors value be determined by settings or custom color?
how will it react to differing settings.maximum_color and strobe_table.color_count values?

A:
settings.maximum_color is the last word in how long a laser's strobe can be
lasers can be shorter than that but not longer
so generation in init strobe should always overwrite strobe_table.color_count to math.min(strobe_table.color_count,settings.maximum_color)
and thus,
display in strobe step should always use the value of strobe_table.color_count
and use the same color_count value in [t % maximum_colors]
since there is now no conflict between strobe_table.color_count and settings.maximum_colors
--]]


--this function interpolates colors from a list of data parameters, and outputs those colors to a table from 1-(max number of colors)
--the maximum number of colors should be kept in mind when creating desired gradients,
--as creating an ultra-complex gradient with many colors will run poorly, display beautifully, and send poorly
function Lasers:init_strobe(des_table,max_colors_override)
--	local input_strobe = (IsStrobeValid(des_table) and des_table) or Lasers.default_strobe
	local input_strobe = des_table or Lasers.default_strobe
--	lp_log("--------------------------------------------------------------------------------------------")
	local maximum_colors = max_colors_override or (input_strobe.duration and math.min(input_strobe.duration,Lasers.default_max_colors)) or Lasers.default_max_colors
	lp_log("Generating strobe with duration = " .. tostring(maximum_colors))
	local output_strobe = {
		colors = {},
		color_count = input_strobe.color_count,
		duration = maximum_colors
	}
	local r3, g3, b3, a3, col_1, col_2, r_diff, g_diff, b_diff, a_diff

	
	
	local num_colors = input_strobe.color_count
--	local c_ratio = maximum_colors / num_colors
--[[	
	local a, b

	log("*************")
	for z = 1, maximum_colors do
	
		a = 1 + (math.floor(z / (maximum_colors / num_colors)) % num_colors)
		b = 1 + (math.floor((z + (maximum_colors/num_colors)) / (maximum_colors / num_colors)) % num_colors)

	
---		y = math.floor(z * (maximum_colors/num_colors))	
--		a = z % num_colors
--		b = (a + 1) % num_colors
			
--		a = 1 + math.floor(z) % num_colors
--		b = 1 + math.floor(z + 1) % num_colors
		lp_log(tostring(z) .. ":" .. tostring(a) .. "/" .. tostring(b))
	end
	log("*************")
--]]
	
	for i = 0, maximum_colors do

--		if col_1.a and col_2.a then 
--			do_alpha = true
--		end
		
--		lp_log("******************************************************************")
--		lp_log("Generating strobe. i = " .. tostring(i))
		
		--determining current color and next color
		local h1 = 1 + (math.floor(i / (maximum_colors / num_colors)) % num_colors)
		local h2 = 1 + (math.floor( (i + (maximum_colors / num_colors) ) / (maximum_colors / num_colors)) % num_colors) 
--		lp_log("Generating strobe: h1/h2 = " .. tostring(h1) .. "/" .. tostring(h2))
		col_1 = input_strobe.colors[h1]
		col_2 = input_strobe.colors[h2]
--		lp_log("Generating strobe. color1 = " .. LuaNetworking:ColourToString(col_1) .. ", color2 = " .. LuaNetworking:ColourToString(col_2))

		r_diff = col_2.red - col_1.red
		g_diff = col_2.green - col_1.green
		b_diff = col_2.blue - col_1.blue
		a_diff = col_2.alpha - col_1.alpha

--		local j = i-1
		
		local a = (i / (maximum_colors / num_colors)) % 1
--		lp_log("a = " .. tostring(a))
		
		
		r3 = col_1.red + (r_diff * a)
		g3 = col_1.green + (g_diff * a)
		b3 = col_1.blue + (b_diff * a)
		
		a3 = col_1.alpha + (a_diff * a)
		
		
--		lp_log("Progress: " .. tostring(i) .. "/" .. tostring(maximum_colors) .. " = " .. tostring(i/maximum_colors))
--		lp_log("color_count = " .. tostring(input_strobe.color_count))
		
--		lp_log("Generating strobe. delta rgba = " .. tostring(r_diff) .. "/" .. tostring(g_diff) .. "/" .. tostring(b_diff) .. "/" .. tostring(a_diff))
--		lp_log("Generating strobe. new color raw = " .. tostring(r3) .. "/" .. tostring(g3) .. "/" .. tostring(b3) .. "/" .. tostring(a3))
		local new_col = Color(r3,g3,b3):with_alpha(a3)
--		lp_log("Generating strobe. Color = " .. LuaNetworking:ColourToString(new_col))
		output_strobe.colors[i] = new_col
	end
	
	return output_strobe
end


--this function is called in update, and is used to display the correct laser color in a strobe from a pre-generated list
--speed can be overridden if you gotta go fast. minimum speed of 1% normal (1/100), no max speed set,
--though it should probably stay below Lasers.default_max_colors for your own good
--Usage: strobe step( [valid formatted table containing: table colors, int color_count], float override_speed or false)
function Lasers:StrobeStep(input_table,override_speed)
	if not input_table or not type(input_table) == "table" then 
		lp_log("Invalid input table")
		return Lasers.default_strobe
	end
	if not (override_speed and type(override_speed) == "number") then 
		override_speed = input_table.override_speed or 1
	end
	
	if not input_table.color_count then
		lp_log("StrobeStep Invalid color count!")
		input_table.color_count = 1
	end
	if not input_table.colors then
--		lp_log("StrobeStep Invalid colors!")
	end
--	lp_log("Color count is " .. tostring(input_table.color_count))
--	lp_log("t = " .. tostring(t))
--	lp_log("override_speed is " .. tostring(override_speed))
--	if input_table.duration then
--		lp_log("duration: " .. tostring(input_table.duration))
--	end
	
	input_table._t2 = input_table._t2 or 1
--	Lasers._t = Lasers._t or 1
--	Lasers._t = math.max((Lasers._t + (override_speed)) % (input_table.duration or input_table.color_count),1)
--	log("_t = " .. tostring(Lasers._t))
	
--	Lasers._t2 = math.floor(Lasers._t + override_speed) % (input_table.duration or input_table.color_count)
	
	input_table._t2 = input_table._t2 + (override_speed or 1)

	local strobe_t = input_table._t2 % (input_table.duration or input_table.color_count)
--	lp_log("stage 1: strobe_t is " .. tostring(strobe_t))
	
--	lp_log("stage 2: strobe_t is " .. tostring(strobe_t))
	strobe_t = math.floor(math.max(strobe_t,1)) --just in case, because somehow it managed to be a non-int and crashed before

--	lp_log("t is now" .. tostring(t))
--	lp_log("strobe t is " .. tostring(strobe_t))
--	lp_log("color is now " .. LuaNetworking:ColourToString(input_table.colors[strobe_t]))
	return input_table.colors[strobe_t]
--	return Lasers.col_generic --input_table.colors[strobe_t]
end


--used to get things like rainbow, randomized, or other presets
--Usage: SpecialLaser( string override_type, [t], float override_speed)
function SpecialLaser(override_type,override_speed)
	if override_type == "rainbow" then
		local r = math.sin(135 * t + 0) / 2 + 0.5
        local g = math.sin(140 * t + 60) / 2 + 0.5
        local b = math.sin(145 * t + 120) / 2 + 0.5
		
		color = Color(r,g,b):with_alpha(Lasers.col_default.alpha)
	elseif override_type == "random" then
		local r
--		for i = 0, 3 do 
--			r[i] = math.random(255)-1 / 256
--		end
		r[0] = math.random(255) - 1 / 256
		r[1] = math.random(255) - 1 / 256
		r[2] = math.random(255) - 1 / 256

	
		color = Color(r[0],r[1],r[2]):with_alpha(r[3])
--	elseif override_type == 
	else 
		lp_log("Couldn't find Laser Preset type [" .. tostring(override_type) .. "]!")
		return false
	end
	return color
end

function Lasers:StrobeTableToString(data)
	if not type(data) == "table" then
		return false
	end --replace this with IsStrobeValid() ?
		
--	local colors = {}
	local duration = data.duration or Lasers.default_max_colors		
	local color_count = data.color_count or 1

	local output = "l" .. duration
	
	for k,v in ipairs(data.colors) do
		output = output .. "c" .. LuaNetworking:ColourToString(v)
	end
	
	return output
end
	
	
function Lasers:StringToStrobeTable(data)
	if not type(data) == "string" then 
		lp_log("Error! Item to convert to table is not a string!")
		return
	end
	
	local output = {
		colors = {},
		duration = Lasers.default_max_colors,
		color_count = 0
	}
	
	local split_strobe = string.split(data, "c")
	
--	lp_log("StringToStrobeTable: logging split_strobe")
--	recursive_table_log(split_strobe)
	
	output.duration = tonumber(split_strobe[1]) or output.duration
	for k,v in ipairs(split_strobe) do
		lp_log("k = [" .. tostring(k) .. "], v = [" .. tostring(v) .. "]")
		if not k == 1 then
			output.color_count = k-1
			output.colors[output.color_count] = LuaNetworking:StringToColour(split_strobe[v])
		end
	end

	lp_log("Logging output StringToStrobeTable")
	recursive_table_log(output)	
	return output
end



function Lasers:GetCriminalNameFromLaserUnit( laser )

	if not self._laser_units_lookup then
		self._laser_units_lookup = {}
	end

	local laser_key = nil
	if laser._unit then
		laser_key = laser._unit:key()
	end
	if laser_key and self._laser_units_lookup[laser_key] ~= nil then
		return self._laser_units_lookup[laser_key]
	end

	local criminals_manager = managers.criminals
	if not criminals_manager then
		return
	end

	for id, character in pairs(criminals_manager._characters) do
		if alive(character.unit) and character.unit:inventory() and character.unit:inventory():equipped_unit() then

			local weapon_base = character.unit:inventory():equipped_unit():base()
--			lp_log("Starting Recursive Log.")
--			recursive_table_log(weapon_base)
			if Lasers:CheckWeaponForLasers( weapon_base, laser_key ) then
				self._laser_units_lookup[laser_key] = character.name
				return
			end

			if weapon_base._second_gun then
				if Lasers:CheckWeaponForLasers( weapon_base._second_gun:base(), laser_key ) then
					self._laser_units_lookup[laser_key] = character.name
					return
				end
			end

		end
	end

	if laser_key then
		self._laser_units_lookup[laser_key] = false
	end
	return nil

end

function recursive_table_log(table_id)
	local iter = iter or 1
	
	if type(table_id) == "table" then 
		for k,v in ipairs(table_id) do
			log("Advancing in nested table logging for table " .. tostring(k) .. ". Degree: " .. tostring(iter)) 
			iter = iter + 1
			recursive_table_log(k) --or v?
		end
		
	else
		log("Logging nested tables. Degrees: [" .. tostring(iter) .. "] | Result:" .. tostring(table_id))
	end

--	recursive_table_log(new_table)

end

function Lasers:CheckWeaponForLasers( weapon_base, key )
--todo get custom color table from this
	
	if weapon_base and weapon_base._factory_id and weapon_base._blueprint then

		local gadgets = managers.weapon_factory:get_parts_from_weapon_by_type_or_perk("gadget", weapon_base._factory_id, weapon_base._blueprint)
		if gadgets then
			for _, i in ipairs(gadgets) do
				if not weapon_base._parts[i].unit then 
					lp_log("CheckWeaponForLasers: No weapon part found for unit")
					break
				else
					local gadget_key = weapon_base._parts[i].unit:key()
					if gadget_key == key then
						return true
					end
				end
			end
		end

	end
	return false

end


	
	
--*****    Strobe Definitions    *****
--Lasers.world = Lasers:GetWorldLaserColor()
Lasers.col_generic = Color(0.4,0,0)--:with_alpha(1)
Lasers.col_default = Color(0,0.2,0):with_alpha(0.4)
Lasers.col_invisible = Color(0,0,0):with_alpha(0)

Lasers.default_strobe = {
	colors = {
		[1] = Color(1,0,0):with_alpha(0.3),
		[2] = Color(0,1,0):with_alpha(0.3),
		[3] = Color(0,0,1):with_alpha(0.3)
	},
	duration = 30,
	color_count = 3
}
lp_log("Initiating strobe from mod...")
Lasers.own_laser_strobe = Lasers.own_laser_strobe or {
	colors = {
		[1] = Color(0,0,1):with_alpha(0.7),
		[2] = Color(0,1,1):with_alpha(0.7),
		[3] = Color(0,1,0):with_alpha(0.7)
	},
	duration = 30,
	color_count = 3
}
Lasers.own_flashlight_strobe = Lasers.own_flashlight_strobe or {
	colors = {
		[1] = Color(0,1,1):with_alpha(0.7),
		[2] = Color(1,1,1):with_alpha(0.7),
		[3] = Color(1,0,1):with_alpha(0.7),
		[4] = Color(1,1,1):with_alpha(0.7),
		[5] = Color(1,1,0):with_alpha(0.7),
		[6] = Color(1,1,1):with_alpha(0.7)
	},
	duration = 120,
	color_count = 4
}
Lasers.npc_flashlight_strobe = Lasers.npc_flashlight_strobe or {
	colors = {
		[1] = Color(1,0,0):with_alpha(0.7),
		[2] = Color(1,1,1):with_alpha(0.7),
		[3] = Color(0,0,1):with_alpha(0.7),
		[4] = Color(1,1,1):with_alpha(0.7),
	},
	duration = 120,
	color_count = 4
}
Lasers.turret_active_strobe = Lasers.turret_active_strobe or {
	colors = {
		[1] = Color(1,0,0):with_alpha(0.3),
		[2] = Color(1,0.5,0):with_alpha(0.3),
		[3] = Color(1,0.9,0):with_alpha(0.3)
	},
	duration = 30,
	color_count = 3
}
Lasers.turret_reload_strobe = Lasers.turret_reload_strobe or {
	colors = {
		[1] = Color(1,1,0):with_alpha(0.5),
		[2] = Color(1,0.4,0):with_alpha(0.5),
		[3] = Color(1,0.9,0):with_alpha(0.5)
	},
	duration = 30,
	color_count = 3
}
Lasers.turret_mad_strobe = Lasers.turret_mad_strobe or {
	colors = {
		[1] = Color(0,1,1):with_alpha(0.5),
		[2] = Color(0,1,0.4):with_alpha(0.5),
		[3] = Color(0,0.4,1):with_alpha(0.5)
	},
	duration = 30,
	color_count = 3
}
Lasers.sniper_strobe = Lasers.sniper_strobe or {
	colors = {
		[1] = Color(1,0,0):with_alpha(1),
		[2] = Color(1,1,0):with_alpha(0.7)
	},
	duration = 15,
	color_count = 2
}
Lasers.world_strobe = Lasers.world_strobe or {
	colors = {
		[1] = Color(1,0,0):with_alpha(0.6),
		[2] = Color(0,1,0):with_alpha(0.4),
		[3] = Color(0,0,1):with_alpha(0.6),
		[4] = Color(1,0,1):with_alpha(0.3)
	},
	duration = 30,
	color_count = 4
}
Lasers.peer_strobe = {
[1] = {},
[2] = {},
[3] = {},
[4] = {}
}


Lasers.DefaultTeamColors = Lasers.DefaultTeamColors or {
	[1] = Color(0.19,0.93,0.31):with_alpha(Lasers.DefaultOpacity),--Color("00ffdd"),
	[2] = Color(0.2,0.3,1):with_alpha(Lasers.DefaultOpacity),
	[3] = Color(1,0.15,0.35):with_alpha(Lasers.DefaultOpacity),
	[4] = Color(0.85,0.55,0.1):with_alpha(Lasers.DefaultOpacity),
	[5] = Lasers.col_generic
}
--[[
default strobe definitions go here
user-customised ones are written into settings
--]]
--write callback menu code for custom lasers colors




--*****    Get() functions    *****

--this is probably obsolete
function Lasers:GetPeerLaserColor(criminal_name)
	local id = managers.criminals:character_peer_id_by_name( criminal_name )
	if not id then 
		id = 5
		lp_log("No id found in GetPeerLaserColor. Spoofing to 5")
	end
	local color = Lasers.DefaultTeamColors[id] or Lasers.col_default
	return color
end

--not used
function Lasers:GetPeerStrobe(num)
	return Lasers.peer_strobe[num] --already initiated with init strobe(data) at this point
end



--[[
Get() functions go here
for colors:
* Player
* Teammates
* Sniper
* Turret
* Turret 2
* Turret 3
* World
x 2 (strobe)
--]]


--*****    GetSettings() functions    *****

function Lasers:GetMaxColors()
	return Lasers.default_max_colors
end


	function Lasers:UpdateLaser( laser, unit, t, dt )

	
--		log("NNL: Color is now " .. LuaNetworking:ColourToString(laser:color() or Color(1,1,1):with_alpha(1)))
			--log("t = " .. tostring(t))
			--log("dt = " .. tostring(dt))
			local refresh_rate = Lasers:GetLaserQuality()
		Lasers._t = Lasers._t or 1
		Lasers._t = math.floor(Lasers._t + 1) % Lasers.default_max_colors
		if math.floor(Lasers._t)/refresh_rate ~= math.floor(Lasers._t/refresh_rate) then
--			lp_log("Taking a break this frame.")
			return
		end
		if not Lasers:IsEnabled() then
		--also get original color
			return
		end

		local color
		
		
		if (laser:theme_type() == "turret_module_active" or laser:theme_type() == "turret_module_rearming" or laser:theme_type() == "turret_module_mad") and Lasers:IsTurretCustom() then		
			if Lasers.last_mode["cop_turret"] == Lasers:GetTurretDisplayMode() and Lasers.last_turret_mode == laser:theme_type() and not (Lasers.last_mode["cop_turret"] == "strobe") then
--				lp_log("No need to update turret lasers. Quitting UpdateLaser early")
				return
			else
				if Lasers.last_mode["cop_turret"] == "none" then 
					lp_log("Initiating Turret Strobes...")
					Lasers._turret_active_strobe = Lasers:init_strobe(Lasers.turret_active_strobe,false)
					Lasers._turret_reload_strobe = Lasers:init_strobe(Lasers.turret_reload_strobe,false)
					Lasers._turret_mad_strobe = Lasers:init_strobe(Lasers.turret_mad_strobe,false)
					Lasers.last_mode["cop_turret"] = "strobe"
				end
			
			
			--do refresh of color. 
			--todo add this to a function so that it can be called by the laser refresh button?
			
				Lasers.last_turret_mode = laser:theme_type()
				
				if laser:theme_type() == "turret_module_active" then
					if Lasers:IsTurretStrobeEnabled() and Lasers:IsTurretCustom() then
						color = Lasers:StrobeStep(Lasers:GetTurretActiveStrobe(),false)
						Lasers.last_mode["cop_turret"] = "strobe"
						laser:set_color(color)
					elseif Lasers:IsTurretCustom() then
						color = Lasers:GetTurretActiveLaserColor()
						Lasers.last_mode["cop_turret"] = "color"
						laser:set_color(color)
					else
						Lasers.last_mode["cop_turret"] = "disabled"
					end

					return
				elseif laser:theme_type() == "turret_module_rearming" then
						if Lasers:IsTurretStrobeEnabled() and Lasers:IsTurretCustom() then
						color = Lasers:StrobeStep(Lasers:GetTurretReloadStrobe(),false)
						Lasers.last_mode["cop_turret"] = "strobe"
						laser:set_color(color)
					elseif Lasers:IsTurretCustom() then
						color = Lasers:GetTurretReloadLaserColor()
						Lasers.last_mode["cop_turret"] = "color"
						laser:set_color(color)
					else
						Lasers.last_mode["cop_turret"] = "disabled"
					end

					return
				elseif laser:theme_type() == "turret_module_mad" then
					if Lasers:IsTurretStrobeEnabled() and Lasers:IsTurretCustom() then
						color = Lasers:StrobeStep(Lasers:GetTurretMadStrobe(),false)
						Lasers.last_mode["cop_turret"] = "strobe"
						laser:set_color(color)
					elseif Lasers:IsTurretCustom() then
						color = Lasers:GetTurretMadLaserColor()
						Lasers.last_mode["cop_turret"] = "color"
						laser:set_color(color)
					else
						Lasers.last_mode["cop_turret"] = "disabled"
					end

					return
				end
			end
		elseif laser:theme_type() == "cop_sniper" and Lasers:IsSniperCustom() then
			if Lasers.last_mode["cop_sniper"] == "none" then 
				lp_log("Initiating Sniper Strobe...")
				Lasers.sniper_strobe = Lasers:init_strobe(Lasers.sniper_strobe,false)
				Lasers.last_mode["cop_sniper"] = "strobe"
			end
			if (Lasers.last_mode["cop_sniper"] == Lasers:GetSniperDisplayMode()) and not (Lasers:GetSniperDisplayMode() == "strobe") then
--				lp_log("No need to update sniper lasers. Quitting UpdateLaser early")
				return
			end
			if laser:theme_type() == "cop_sniper" then
				if Lasers:IsSniperStrobeEnabled() and Lasers:IsSniperCustom() then
					color = Lasers:StrobeStep(Lasers:GetSniperStrobe(),false)
					Lasers.last_mode["cop_sniper"] = "strobe"
					laser:set_color(color)
				elseif Lasers:IsSniperCustom() then
					color = Lasers:GetSniperLaserColor()
					Lasers.last_mode["cop_turret"] = "color"
					laser:set_color(color)
				else
					Lasers.last_mode["cop_turret"] = "disabled"
				end

				return
			end
		end

		if laser._is_npc then

			local this_criminal
			local criminal_name = Lasers:GetCriminalNameFromLaserUnit( laser )
			if not criminal_name then
				return
			end
			peerid_num = managers.criminals:character_peer_id_by_name( criminal_name )
			criminal_username = LuaNetworking:GetNameFromPeerID( peerid_num ) or "Noone"
			if false then
--			if (Lasers:GetTeamLaserDisplayMode() == Lasers.last_peer_mode[peerid_num]) and not (Lasers.last_peer_mode[peerid_num] == "strobe") then
				lp_log("No need to update peer lasers. Quitting UpdateLaser early")
				return
			end
			
			if Lasers.last_peer_mode[peerid_num] == "none" then 
				lp_log("Initiating Strobe for player id " .. tostring(peerid_num))
				Lasers.peer_strobe[peerid_num] = Lasers:init_strobe(Lasers.default_strobe)
				Lasers.last_peer_mode[peerid_num] = "strobe"
			end			
			
			local net_strobe = Lasers.SavedTeamStrobes[criminal_name] or Lasers.SavedTeamColors[criminal_name]
			--todo: log contents of net strobe
			if not net_strobe then 
				lp_log("no saved table for criminal " .. tostring(criminal_name))
			end
			if Lasers:IsNetworkingEnabled() and net_strobe then
				lp_log("Entering team network loop")
				
				if type(net_strobe) == "string" then
					lp_log("Found net_strobe is string")
					color = SpecialLaser(net_strobe,false)
					if color then 
						laser:set_color(color)
						return
					else 
						lp_log("String parse failed for type " .. color)
					end
				end --this is pointedly not else-exclusive with the rest of the function
				
				if type(net_strobe) == "table" and Lasers:IsMasterLaserStrobeEnabled() and Lasers:IsTeamLaserStrobeEnabled() then
					lp_log("Using NPC player UpdateLaser() of id " .. tostring(peerid_num))
					color = Lasers:StrobeStep(net_strobe)
					Lasers.last_peer_mode[peerid_num] = "strobe"
					laser:set_color(color)
					return
				--legacy color support if you still have old nnl for some reason, i guess
				elseif not (type(net_strobe) == "table") then
					lp_log("Type of netstrobe is not a table")
					--assume it's type color, since networking input would filter out other types
					color = net_strobe
					Lasers.last_peer_mode[peerid_num] = "color"
					laser:set_color(color)
					return
				else
					lp_log("Failed update to strobestep check and update to networked laser check. Check data type(net_strobe) ?")
					recursive_table_log(net_strobe)
				end
			else
				lp_log("No viable networked settings found. Entering local custom team laser override loop.")
			--override or if no netcolor found
				if Lasers:IsTeamLaserPeerColor() then
						Lasers.last_peer_mode[peerid_num] = "peer"
						color = Lasers:GetPeerLaserColor(criminal_name)
				elseif Lasers:IsTeamLaserCustom() then
					if Lasers:IsMasterLaserStrobeEnabled() and Lasers:IsTeamLaserStrobeEnabled() then
						Lasers.last_peer_mode[peerid_num] = "strobe"
	--					color = Lasers:GetPeerStrobe(peerid_num)
						color = Lasers:GetTeamLaserStrobe()
					else
						Lasers.last_peer_mode[peerid_num] = "custom"
						color = Lasers:GetTeamLaserColor()
					end
				elseif Lasers:IsTeamLaserVanilla() then
					Lasers.last_peer_mode[peerid_num] = "vanilla"
					return
				elseif Lasers:IsTeamLaserInvisible() then 
					Lasers.last_peer_mode[peerid_num] = "off"
					color = Lasers.col_invisible
				else
					lp_log("ERROR: Somehow skipped every peer laser option in UpdateLaser!\ncriminal_name = " .. tostring(criminal_name))
				end
				laser:set_color(color)
				return
			end
			if Lasers.last_peer_mode[peerid_num] == "strobe" then
				lp_log("CAUSE THIS IS FILLER, FILLER NIGHT")
			end
			lp_log("Reached the end of team lasers loop. Something went wrong!")
		else
			local a = Lasers:GetCriminalNameFromLaserUnit( laser )
--			lp_log("Entered player loop!")
--[[			if Lasers.last_peer_mode["self"] == "none" and Lasers:GetOwnLaserDisplayMode() == "strobe" then
				lp_log("Initiating player strobe in player loop...")
				Lasers._own_laser_strobe = Lasers:init_strobe(Lasers.own_laser_strobe,false)
				Lasers.last_peer_mode["self"] = "strobe"
			end--]]
--			log("Display Mode: " .. tostring(Lasers:GetOwnLaserDisplayMode()))
			if (Lasers.last_mode["self"] == Lasers:GetOwnLaserDisplayMode()) and Lasers:GetOwnLaserDisplayMode() ~= "strobe" then
--				lp_log("Playermode is " .. tostring(Lasers:GetOwnLaserDisplayMode()))
--				lp_log("player strobe is " .. tostring(Lasers:IsOwnLaserStrobeEnabled()))
--				lp_log("master strobe is " .. tostring(Lasers:IsMasterLaserStrobeEnabled()))
				return
			end
			if Lasers:IsOwnLaserInvisible() then
--				lp_log("Making laser invisible")
				Lasers.last_mode["self"] = "off"
				laser:set_color(Lasers.col_invisible)
				return
			end
			if Lasers:IsOwnLaserVanilla() then
				Lasers.last_mode["self"] = "vanilla"
--				lp_log("Making lasers vanilla!")
				return --get weapon part's color if possible
			end			
			if Lasers:IsOwnLaserCustom() then
				if Lasers:IsOwnLaserStrobeEnabled() and Lasers:IsMasterLaserStrobeEnabled() then
--					lp_log("Doing strobe calc")
--					if not Lasers.derp then
--						Lasers.derp = true
--						Lasers.foo = Lasers:init_strobe(Lasers:StringToStrobeTable((Lasers:GetSavedPlayerStrobe())))
--						return
--					end
--					color = Lasers:StrobeStep(Lasers.foo)
					color = Lasers:StrobeStep(Lasers:GetOwnLaserStrobe(),false)
				else
--					lp_log("Doing own laser solid color")
					color = Lasers:GetOwnLaserColor()
				end
				
				if color then
--					lp_log("Setting color to " .. LuaNetworking:ColourToString(color))
					laser:set_color(color)
					return
				else
--					lp_log("Could not set invalid color!")
					return
				end
			end
		end
	end
	

	Hooks:Add("WeaponLaserUpdate", "WeaponLaserUpdate_lasersplus", function(laser, unit, t, dt)
		Lasers:UpdateLaser(laser, unit, t, dt)
	end)

	Hooks:Add("WeaponLaserInit", "WeaponLaserInit_", function(laser, unit)
		lp_log("Generating player strobe in Init.")
		Lasers._own_laser_strobe = Lasers:init_strobe(Lasers.own_laser_strobe,false)	
		Lasers:UpdateLaser(laser, unit, 0, 0)
		-- *****    Send Data    *****
--		if Lasers:IsMasterLaserStrobeEnabled() and Lasers:IsOwnLaserStrobeEnabled() then
--		local strobe_string = StrobeTableToString(Lasers.own_laser_strobe)
--		lp_log("Completed table to string conversion. Result: " .. strobe_string)
--		end
		
--		if Lasers:IsNetworkingEnabled() then
--			LuaNetworking:SendToPeers( Lasers.LuaNetID, LuaNetworking:ColourToString(Lasers:GetOwnLaserColor()))
--			LuaNetworking:SendToPeers( Lasers.LuaNetID, strobe_string)
--		end
		
	end)

	

	-- *****    Set On    *****
	Hooks:Add("WeaponLaserSetOn", "WeaponLaserSetOn_", function(laser)
		local own_strobe = Lasers:GetSavedPlayerStrobe() 
		LuaNetworking:SendToPeers( Lasers.LuaNetID, LuaNetworking:ColourToString(Lasers:GetOwnLaserColor()))
		LuaNetworking:SendToPeers( Lasers.LuaNetID, own_strobe)
		lp_log("Starting recursive log in laser set on of compressed string strobe, of data type " .. type(own_strobe))
		local c_t = Lasers:StringToStrobeTable(own_strobe)
		lp_log("after conversion, is now " .. type(c_t))
		
		
		--		recursive_table_log(Lasers:StringtoStrobeTable(Lasers:GetSavedPlayerStrobe()))
--[[
		if laser._is_npc or not Lasers:IsNetworkingEnabled() then
			return
		end
		local criminals_manager = managers.criminals
		if not criminals_manager then
			return
		end

		local local_name = criminals_manager:local_character_name()
		local laser_name = Lasers:GetCriminalNameFromLaserUnit(laser)
		if laser_name == nil or local_name == laser_name then
			return
		end
		--]]
	end)
	
	
	-- *****    Receive Data    *****
	Hooks:Add("NetworkReceivedData", "NetworkReceivedData_", function(sender, message, data)
		if message == Lasers.LuaNetID or message == Lasers.LegacyID then
			local criminals_manager = managers.criminals
			if not criminals_manager then
				return
			end
			if message == Lasers.LegacyID and sender then 
				lp_log("Sender with peerid [" .. sender .. "] is running legacy Networked Lasers!")
				--should we... decode it?
			elseif message == Lasers.LuaNetID and sender then 
				if type(data) ~= "string" then
					lp_log("Wrong data type received!")
					--this shouldn't ever happen anyway, luanetworking only sends strings
					return
				end
			end

			local char = criminals_manager:character_name_by_peer_id(sender)
			local col = data
			
			if string.find(data, "l") then
				lp_log("Successfully received and parsed strobe data.")
				col = Lasers:init_strobe(Lasers:StringToStrobeTable(data))
				if char then
					Lasers.SavedTeamStrobes[char] = col
					lp_log("Saved a team strobe to the table")
					return
				end
			elseif data ~= "nil" then
				lp_log("Did not find data.")
				col = LuaNetworking:StringToColour(data)
				return
			end
			
			if char then
				Lasers.SavedTeamColors[char] = col
				lp_log("received from char " .. tostring(char))
				return
			end
		end

	end)
--************FLASHLIGHTS************

--[[
function WeaponFlashLight:update(unit, t, dt)
	color = StrobeStep(Lasers:GetOwnFlashlightStrobe())
	self._light:set_color(color)
end

local WeaponFlashLight__Check_State_Original = WeaponFlashLight._check_state
function WeaponFlashLight:_check_state()
    self._unit:set_extension_update_enabled(Idstring("base"), self._on)
    return WeaponFlashLight__Check_State_Original(self)
end

--]]







	
--[[


		{
			"hook_id" : "lib/managers/menumanager",
			"script_path" : "menumanager.lua"
		},


	Hooks:Add("WeaponLaserUpdate", "WeaponLaserUpdate_Rainbow_", function(laser, unit, t, dt)
		Lasers:UpdateLaser(laser, unit, t, dt)
	end)

	
local r_threshold = 0.5
--max amount of red in a laser before it's blocked

local g_b_threshold = 0.5
--min amount of g/b in a laser with 0.5+ red in it for it not to be blocked

local last_mode["self"] = "none"
--last_modes used for optimization to avoid calculating gradients over and over
local last_mode["peer_1"] = "none"
local last_mode["peer_2"] = "none"
local last_mode["peer_3"] = "none"
local last_mode["peer_4"] = "none"
local last_mode["npc_sniper"] = "none"
local last_mode["npc_turret"] = "none"
local last_mode["world_laser"] = "none"
--modes include gradient, solidcolor
--create a button to reset lasers
--create a button to reset laser options
--changing menu items calls the reset lasers to recalculate gradients and colors in case of change from previous options

if not last_mode[player] or last_mode[player] = current_mode then
--do main laser calculation here
--if gradient then initialise gradient 	
if team_strobes_enabled and networked_strobe[x] then 
	lasers:strobe step(t,networked_strobe[x])
	last_mode["peer_x"] = "strobe"
else 
end

--color filter
if colorfilter and Color.red > redthreshold and (Color.green + Color.blue > redthreshold) and (Color.green + Color.blue > redthreshold) 
--]]