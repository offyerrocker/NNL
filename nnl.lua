--This mod is not affiliated or involved in any way with RoosterTeeth
--Seriously you guys I just wanted to make a bad play on words

_G.LaserTeam = _G.LaserTeam or {}
local Lasers = Lasers or _G.LaserTeam
Lasers._path = ModPath
Lasers._data_path = Lasers._data_path or SavePath .. "nnlasers.txt"
Lasers._data = Lasers._data or Lasers.settings or {}

-- hidden settings not found in user-accessible settings menu

	--[[
	# # NEW: Custom laser gradients ##
		[Check the README.md for a slightly more in-depth explanation.]
	
	* Below, in the table "my_gradient" you can set your own color-changing preset. Lasers are always rendered as a line of one color, not a "true" gradient,
	however the color can shift over time.
	* This system uses a system approximately equivalent to the 'color stops' system used by applications or programs such as 
	CSS gradients, or Adobe Photoshop's gradients tool.
	* However, the 'locations' measure duration of that color instead of physical length in a gradient. Experiment some for yourself.
	****** Here's a brief guide to color stops: https://www.quirksmode.org/css/images/colorstops.html ******
	* Although there's no upper limit to the number of colors you can have,
	successive locations should always be greater than the last.
	* For the sake of stability, I would suggest no more than 10 locations, though you can have as few as two (2). 
	* You should also have exactly as many locations as you do colors.
	* If you have an inequal amount of colors to lasers,
	you may experience bugs or crashes.
	* Colors should ideally include the alpha level 
	by using "with_alpha" at the end of your color. 
	* Ideally, your locations should be within 0-100, and may cause bugs if not obeying these guidelines.

	# TL;DR:
	* Set colors in R/G/B format like shown in "example_gradient."
	* Set locations, or at what time the gradient displays after the previous one.
	--]]
	--todo put my_gradient in settings so it's not overwritten by updates
	Lasers.my_gradient = Lasers.my_gradient or {
		colors = {
			[1] = Color(1,0.6,0):with_alpha(Lasers.settings.turr_att_alpha),
			[2] = Color(1,0,0):with_alpha(Lasers.settings.turr_att_alpha),
			[3] = Color(1,0.6,0):with_alpha(Lasers.settings.turr_att_alpha),
			[4] = Color(1,0,0):with_alpha(Lasers.settings.turr_att_alpha),
			[5] = Color(1,0.6,0):with_alpha(Lasers.settings.turr_att_alpha),
			[6] = Color(1,0,0):with_alpha(Lasers.settings.turr_att_alpha),
			[7] = Color(1,0.6,0):with_alpha(Lasers.settings.turr_att_alpha),
			[8] = Color(1,0,0):with_alpha(Lasers.settings.turr_att_alpha),
			[9] = Color(1,0.6,0):with_alpha(Lasers.settings.turr_att_alpha),
			[10] = Color(1,0,0):with_alpha(Lasers.settings.turr_att_alpha),
			[11] = Color(1,0.6,0):with_alpha(Lasers.settings.turr_att_alpha)
		},
		locations = {
			[1] = 0,
			[2] = 10,
			[3] = 20,
			[4] = 30,
			[5] = 40,
			[6] = 50,
			[7] = 60,
			[8] = 70,
			[9] = 80,
			[10] = 90,
			[11] = 99
		}
	} or Lasers.example_gradient
	
	Lasers.team_gradient = Lasers.my_gradient
	--todo
	
	Lasers.mode_list = {
		[1] = Lasers.example_gradient, --disabled
		[2] = Lasers.example_gradient, --custom, fetches type instead
		[3] = Lasers.rainbow, --rainbow
		[4] = Lasers.siren, --siren
		[5] = Lasers.example_gradient -- crazy, override color instead
	}
	
	Lasers.player_mode_list = {
		[1] = "crazy",
		[2] = "crazy",
		[3] = "rainbow",
		[4] = "siren",
		[5] = "crazy"
	}
	
	Lasers.gradient_list = {
		[0] = Lasers.default_gradient,
		[1] = Lasers.my_gradient,
		[2] = Lasers.team_gradient,
		[3] = Lasers.sniper_gradient,
		[4] = Lasers.world_gradient,
		[5] = Lasers.turret_gradient_1,
		[6] = Lasers.turret_gradient_2,
		[7] = Lasers.turret_gradient_3
	}
	
--******************************************************************
--******************************************************************

	Lasers.LuaNetID = "nncpl"
	--"new networked custom player lasers"
	--borderline absurd acronym in order to keep it unlikely for another mod to share its id

	Lasers.LegacyID = "gmcpwl"
	--legacy support for the 0.00000002% of players still using GoonMod somehow

	Lasers.LuaNetID_gradient = "nncpl_gr_v1" 
	--"new networked custom player lasers- gradient - version one"
	--for advanced users- creates a gradient between two or more colors. 

	Lasers.DefaultOpacity = 0.35
	--default opacity for lasers

	Lasers.update_interval = 1
	--default rate of update on lasers. lower looks better. greatly affects performance! set to 0 for maximum performance (unlimited)
	--currently broken. do not change from 1

	Lasers.default_gradient_speed = 20
	--rate of laser change between color locations- higher is faster. no additional effect on performance.

	Lasers.lowquality_gradients = false
	--local option, does not affect what others see. instant switch instead of slow gradients

	Lasers.debugLogsEnabled = false

	Lasers.generic_color = Color(0,0.2,0):with_alpha(0.4)
	
	Lasers.col_white = Color(1,1,1):with_alpha(1)
	
	Lasers.last_grad = Color(0,0,0):with_alpha(0)

	Lasers.legacy_clients = Lasers.legacy_clients or {}

	Lasers.SavedTeamColors = Lasers.SavedTeamColors or {}

	Lasers.sniper_gradient = {
		colors = {
			[1] = Color(1,0,0):with_alpha(Lasers.settings.snpr_alpha),
			[2] = Color(1,0,0.5):with_alpha(Lasers.settings.snpr_alpha/4),
			[3] = Color(1,0,0):with_alpha(Lasers.settings.snpr_alpha),
			[4] = Color(1,0,0.5):with_alpha(Lasers.settings.snpr_alpha/4),
			[5] = Color(1,0,0):with_alpha(Lasers.settings.snpr_alpha),
			[6] = Color(1,0,0.5):with_alpha(Lasers.settings.snpr_alpha/4),
			[7] = Color(1,0,0):with_alpha(Lasers.settings.snpr_alpha),
			[8] = Color(1,0,0.5):with_alpha(Lasers.settings.snpr_alpha/4),
			[9] = Color(1,0,0):with_alpha(Lasers.settings.snpr_alpha),
			[10] = Color(1,0,0.5):with_alpha(Lasers.settings.snpr_alpha/4),
			[11] = Color(1,0,0):with_alpha(Lasers.settings.snpr_alpha)
		},
		locations = {
			[1] = 0,
			[2] = 10,
			[3] = 20,
			[4] = 30,
			[5] = 40,
			[6] = 50,
			[7] = 60,
			[8] = 70,
			[9] = 80,
			[10] = 90,
			[11] = 99
		}
	}
	
	Lasers.turret_gradient_1 = {
		colors = {
			[1] = Color(1,0.5,0):with_alpha(Lasers.settings.turr_att_alpha),
			[2] = Color(1,0,0):with_alpha(Lasers.settings.turr_att_alpha),
			[3] = Color(1,0.5,0):with_alpha(Lasers.settings.turr_att_alpha),
			[4] = Color(1,0,0):with_alpha(Lasers.settings.turr_att_alpha),
			[5] = Color(1,0.5,0):with_alpha(Lasers.settings.turr_att_alpha),
			[6] = Color(1,0,0):with_alpha(Lasers.settings.turr_att_alpha),
			[7] = Color(1,0.5,0):with_alpha(Lasers.settings.turr_att_alpha),
			[8] = Color(1,0,0):with_alpha(Lasers.settings.turr_att_alpha),
			[9] = Color(1,0.5,0):with_alpha(Lasers.settings.turr_att_alpha),
			[10] = Color(1,0,0):with_alpha(Lasers.settings.turr_att_alpha),
			[11] = Color(1,0.5,0):with_alpha(Lasers.settings.turr_att_alpha)
		},
		locations = {
			[1] = 0,
			[2] = 10,
			[3] = 20,
			[4] = 30,
			[5] = 40,
			[6] = 50,
			[7] = 60,
			[8] = 70,
			[9] = 80,
			[10] = 90,
			[11] = 99
		}
	}	

		
	Lasers.turret_gradient_2 = {
		colors = {
			[1] = Color(1,0.6,0):with_alpha(Lasers.settings.turr_rld_alpha),
			[2] = Color(0.8,0.3,0):with_alpha(Lasers.settings.turr_rld_alpha),
			[3] = Color(1,0.6,0):with_alpha(Lasers.settings.turr_rld_alpha),
			[4] = Color(0.8,0.3,0):with_alpha(Lasers.settings.turr_rld_alpha),
			[5] = Color(1,0.6,0):with_alpha(Lasers.settings.turr_rld_alpha),
			[6] = Color(0.8,0.3,0):with_alpha(Lasers.settings.turr_rld_alpha),
			[7] = Color(1,0.6,0):with_alpha(Lasers.settings.turr_rld_alpha),
			[8] = Color(0.8,0.3,0):with_alpha(Lasers.settings.turr_rld_alpha),
			[9] = Color(1,0.6,0):with_alpha(Lasers.settings.turr_rld_alpha),
			[10] = Color(0.8,0.3,0):with_alpha(Lasers.settings.turr_rld_alpha),
			[11] = Color(1,0.6,0):with_alpha(Lasers.settings.turr_rld_alpha)
		},
		locations = {
			[1] = 0,
			[2] = 10,
			[3] = 20,
			[4] = 30,
			[5] = 40,
			[6] = 50,
			[7] = 60,
			[8] = 70,
			[9] = 80,
			[10] = 90,
			[11] = 99
		}
	}	
	
	Lasers.turret_gradient_3 = {
		colors = {
			[1] = Color(0,1,0.8):with_alpha(Lasers.settings.turr_ecm_alpha),
			[2] = Color(0,0.6,1):with_alpha(Lasers.settings.turr_ecm_alpha),
			[3] = Color(0,1,0.8):with_alpha(Lasers.settings.turr_ecm_alpha),
			[4] = Color(0,0.6,1):with_alpha(Lasers.settings.turr_ecm_alpha),
			[5] = Color(0,1,0.8):with_alpha(Lasers.settings.turr_ecm_alpha),
			[6] = Color(0,0.6,1):with_alpha(Lasers.settings.turr_ecm_alpha),
			[7] = Color(0,1,0.8):with_alpha(Lasers.settings.turr_ecm_alpha),
			[8] = Color(0,0.6,1):with_alpha(Lasers.settings.turr_ecm_alpha),
			[9] = Color(0,1,0.8):with_alpha(Lasers.settings.turr_ecm_alpha),
			[10] = Color(0,0.6,1):with_alpha(Lasers.settings.turr_ecm_alpha),
			[11] = Color(0,1,0.8):with_alpha(Lasers.settings.turr_ecm_alpha)
		},
		locations = {
			[1] = 0,
			[2] = 10,
			[3] = 20,
			[4] = 30,
			[5] = 40,
			[6] = 50,
			[7] = 60,
			[8] = 70,
			[9] = 80,
			[10] = 90,
			[11] = 99
		}
	}
	
	
	Lasers.world_gradient = {
		colors = {
			[1] = Color(1,0,0):with_alpha(Lasers.settings.wl_alpha),
			[2] = Color(1,0,0):with_alpha(0),
			[3] = Color(1,1,0):with_alpha(Lasers.settings.wl_alpha),
			[4] = Color(1,1,0):with_alpha(0),
			[5] = Color(1,0,0):with_alpha(Lasers.settings.wl_alpha),			
			[6] = Color(1,0,0):with_alpha(0),
			[7] = Color(1,1,0):with_alpha(Lasers.settings.wl_alpha),
			[8] = Color(1,1,0):with_alpha(0),
			[9] = Color(1,0,0):with_alpha(Lasers.settings.wl_alpha)
		},
		locations = {
			[1] = 0,
			[2] = 14,
			[3] = 28,
			[4] = 42,
			[5] = 56,
			[6] = 70,
			[7] = 84,
			[8] = 98,
			[9] = 99
		}
	}	
	
	Lasers.rainbow = {
		colors = {
			[1] = Color(1,0,0):with_alpha(Lasers.DefaultOpacity),
			[2] = Color(0,1,0):with_alpha(Lasers.DefaultOpacity),
			[3] = Color(0,0,1):with_alpha(Lasers.DefaultOpacity),
			[4] = Color(1,0,0):with_alpha(Lasers.DefaultOpacity)
		},
		locations = {
			[1] = 0,
			[2] = 33,
			[3] = 66,
			[4] = 99
		
		}
	}
	
	Lasers.example_gradient = Lasers.example_gradient or {
		colors = {
			[1] = Color(1,0,1):with_alpha(0.3),
			[2] = Color(0,1,0):with_alpha(0.3),
			[3] = Color(0,0,1):with_alpha(0.3)
		},
		locations = {
			[1] = 0,
			[2] = 33,
			[3] = 66
		}
	}

	Lasers.siren = {
		colors = {
			[1] = Color(1,0,0):with_alpha(1),
			[2] = Color(1,0,0):with_alpha(0),
			[3] = Color(1,1,1):with_alpha(1),
			[4] = Color(1,1,1):with_alpha(0),
			[5] = Color(0,0,1):with_alpha(1),
			[6] = Color(0,0,1):with_alpha(0),
			[7] = Color(1,0,0):with_alpha(1)
		},
		locations = {
			[1] = 0,
			[2] = 33,
			[3] = 34,
			[4] = 66,
			[5] = 67,
			[6] = 98,
			[7] = 99
		}
	}
	
	Lasers.my_gradient = Lasers.my_gradient or Lasers.rainbow
	
	Lasers.DefaultTeamColors = Lasers.DefaultTeamColors or {
		[1] = Color(0,1,0.5):with_alpha(Lasers.DefaultOpacity),--Color("00ffdd"),
		[2] = Color(0.2,0.3,1):with_alpha(Lasers.DefaultOpacity),
		[3] = Color(1,0.15,0.35):with_alpha(Lasers.DefaultOpacity),
		[4] = Color(0.85,0.55,0.1):with_alpha(Lasers.DefaultOpacity),
		[5] = Color("ffffff"):with_alpha(1)
	}

	function nnl_log (message)
		if Lasers.debugLogsEnabled then
			log("NNL: " .. message)
		end
	end

	function Lasers:IsEnabled()
		return true
	end

	function Lasers:IsRainbow()
		return false
	end
--[[
	function Lasers:GetGradientFromModeNumber(modenum)
		if (type(modenum) ~= "number" or modenum < 0 or modenum > 5) then 
			return Lasers.default_gradient
		end
		return Lasers.gradient_list[modenum]
	end
--]]
	function Lasers:GetPlayerLaserColor()
		return Color(Lasers.settings.own_red,Lasers.settings.own_green,Lasers.settings.own_blue):with_alpha(Lasers.settings.own_alpha) or Color(0,1,0):with_alpha(1)
	end

	function Lasers:GetTeamLaserColor()
		return Color(Lasers.settings.team_red,Lasers.settings.team_green,Lasers.settings.team_blue):with_alpha(Lasers.settings.team_alpha) or Color(0,0.5,1):with_alpha(1)
	end
	
	function Lasers:GetSniperLaserColor()
		return Color(Lasers.settings.snpr_red,Lasers.settings.snpr_green,Lasers.settings.snpr_blue):with_alpha(Lasers.settings.snpr_alpha) or Color(1,0,0):with_alpha(Lasers.DefaultOpacity)
	end
	
	function Lasers:GetTurretActiveColor()
		return Color(Lasers.settings.turr_att_red,Lasers.settings.turr_att_green,Lasers.settings.turr_att_blue):with_alpha(Lasers.settings.turr_att_alpha) or Color(1,0,0):with_alpha(Lasers.DefaultOpacity)
	end
	
	function Lasers:GetTurretReloadColor()
		return Color(Lasers.settings.turr_rld_red,Lasers.settings.turr_rld_green,Lasers.settings.turr_rld_blue):with_alpha(Lasers.settings.turr_rld_alpha) or Color(1,1,0):with_alpha(Lasers.DefaultOpacity)
	end
	
	function Lasers:GetTurretMadColor()
		return Color(Lasers.settings.turr_mad_red,Lasers.settings.turr_mad_green,Lasers.settings.turr_mad_blue):with_alpha(Lasers.settings.turr_mad_alpha) or Color(0,1,1):with_alpha(Lasers.DefaultOpacity)
	end
	
	function Lasers:GetWorldLaserColor()
		return Color(Lasers.settings.wl_red,Lasers.settings.wl_green,Lasers.settings.wl_blue):with_alpha(Lasers.settings.wl_alpha) or Color(1,0,1):with_alpha(Lasers.DefaultOpacity)
	end
	
	function Lasers:IsTeamNetworked()
		return Lasers.settings.networked_lasers
	end

	function Lasers:IsMasterGradientEnabled()
		return Lasers.settings.enabled_gradients_master
	end

	function Lasers:IsOwnGradientEnabled()
		return Lasers.settings.own_gradients_mode ~= 1
--		return Lasers.settings.enabled_own_gradients
	end
	
	function Lasers:IsTeamGradientEnabled()
		return Lasers.settings.team_gradients_mode ~= 1
--		return Lasers.settings.enabled_team_gradients
	end
	
	function Lasers:IsSniperGradientEnabled()
		return Lasers.settings.snpr_gradients_mode ~= 1
--		return Lasers.settings.enabled_snpr_gradients
	end

	function Lasers:IsWorldGradientEnabled()
		return Lasers.settings.wl_gradients_mode ~= 1
--		return Lasers.settings.enabled_wl_gradients
	end

	function Lasers:IsTurretGradientEnabled()
		return Lasers.settings.turr_gradients_mode ~= 1
--		return Lasers.settings.enabled_turr_gradients
	end

	--should check for each four? but that's like 16 functions
	function Lasers:GetOwnGradientMode()
		return Lasers.settings.own_gradients_mode
	end
	
	function Lasers:GetTeamGradientMode()
		return Lasers.settings.team_gradients_mode
	end
	
	function Lasers:GetSniperGradientMode()
		return Lasers.settings.snpr_gradients_mode
	end
	
	function Lasers:GetWorldGradientMode()
		return Lasers.settings.wl_gradients_mode
	end
	
	function Lasers:GetTurretGradientMode()
		return Lasers.settings.turr_gradients_mode
	end
	
	function Lasers:IsTeamCustom()
		return Lasers.settings.display_team_lasers == 1
	end

	function Lasers:IsTeamUniform()
		return Lasers.settings.display_team_lasers == 2
	end

	function Lasers:IsTeamVanilla()
		return Lasers.settings.display_team_lasers == 3
	end

	function Lasers:IsTeamDisabled()
		return Lasers.settings.display_team_lasers == 4
	end

	function Lasers:GetPeerColor(criminal_name)
		local id = managers.criminals:character_peer_id_by_name( criminal_name )
		if not id then 
			id = 1
			nnl_log("No id found in GetPeerColor. Spoofing to 1")
		end
		local color = Lasers.DefaultTeamColors[id]
		color = color or Color(1,1,1):with_alpha(1)
		return color
	end
	
	function log_table(table_name)
	--untested
		if not table_name then 
			log("Logged table is empty")
			return
		end
		local log_str = "Logging table..." 
		local log_k,log_v
		for k,v in pairs(table_name) do
			if not k or not v then
				log("Logged table is empty")
				return --break
			end
			log_str = (log_str .. "|" .. k .. "=" .. v .."|")			
		end
		log(log_str)
	end

	function RandEightBit()
		return math.floor(math.random(0,255))
	end
	
	function Lasers:GradientTableToString(gradient_table) --splits a table's contents into a string
		local g_colors = gradient_table.colors
		local g_locations = gradient_table.locations
		local col_sep = "%$" --color separator; this is dumb
		local loc_sep = "^" --location separator; these are dumb. should change format
		local loc_bgn = "l:"
		local data_string = "" --formerly c: but not necessary anymore
		local this_col,this_loc --and that's when i realised loc/col are mirrored words
		for k,v in ipairs(g_colors) do 
			nnl_log("Colors for loop:" .. LuaNetworking:ColourToString(v) .. " at #" .. k)
			this_col = LuaNetworking:ColourToString(v) --takes the current color from the table
			data_string = data_string .. this_col .. col_sep
		end
		data_string = data_string .. loc_bgn
		
		for k,v in ipairs(g_locations) do
			nnl_log("Locations for loop:" .. v .. ", " .. k)
			this_loc = v
			data_string = data_string .. this_loc .. loc_sep
		end
		nnl_log("New gradient string created, called [" .. data_string .. "]")
		return data_string
	end

	function Lasers:StringToGradientTable(gradient_string)
	--given a formatted gradient-string and a criminal number,
	--unpacks the gradient and writes it directly to the storage table, returning the table
		local gradient_data = {
			colors = {},
			locations = {}
		}

		local split_gradient = string.split( gradient_string, "l:")
		local colors = string.split( split_gradient[1], "%$")
		local locations = string.split( split_gradient[2], "%^")
		
		for k,v in ipairs(colors) do
			gradient_data.colors[k] = LuaNetworking:StringToColour(v)
		end
		
		for k,v in ipairs(locations) do 
			nnl_log("location " .. k .. " is " .. v)
			gradient_data.locations[k] = tonumber(v)
		end
		return gradient_data
	end
		
	function Lasers:GetColor(alpha)
	--unused
		return Lasers.DefaultTeamColors[LuaNetworking:LocalPeerID()]:with_alpha(0.07) --Lasers.Color:GetColor( alpha )
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

	function Lasers:CheckWeaponForLasers( weapon_base, key )

		if weapon_base and weapon_base._factory_id and weapon_base._blueprint then

			local gadgets = managers.weapon_factory:get_parts_from_weapon_by_type_or_perk("gadget", weapon_base._factory_id, weapon_base._blueprint)
			if gadgets then
				for _, i in ipairs(gadgets) do
					if not weapon_base._parts[i].unit then 
						nnl_log("CheckWeaponForLasers: No weapon part found for unit")
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

	function Lasers:UpdateLaser( laser, unit, t, dt )
		local color, select_gradient
		if not Lasers:IsEnabled() then
			return
		end
		
		if laser:theme_type() then 
			if laser:theme_type() == "cop_sniper" then 
				if Lasers:IsSniperGradientEnabled() then
					if Lasers:GetSniperGradientMode() == 2 then 
						select_gradient = Lasers.sniper_gradient
					else 
						select_gradient = Lasers.mode_list[Lasers:GetSniperGradientMode()]
					end					
					color = GradientStep(t,select_gradient, Lasers.default_gradient_speed)
					laser:set_color( color )
					return
				else 
					laser:set_color(Lasers:GetSniperLaserColor())
					return
				end
			elseif laser:theme_type() == "turret_module_active" then
				if Lasers:IsTurretGradientEnabled() then 
					if Lasers:GetTurretGradientMode() == 2 then 
						select_gradient = Lasers.turret_gradient_1
					else 
						select_gradient = Lasers.mode_list[Lasers:GetTurretGradientMode()]
					end							
					color = GradientStep(t,select_gradient, Lasers.default_gradient_speed)					
					laser:set_color( color )
					return
				else
					laser:set_color(Lasers:GetTurretActiveColor())
					return
				end
			elseif laser:theme_type() == "turret_module_rearming" then
				if Lasers:IsTurretGradientEnabled() then 
					if Lasers:GetTurretGradientMode() == 2 then 
						select_gradient = Lasers.turret_gradient_2
					else 
						select_gradient = Lasers.mode_list[Lasers:GetTurretGradientMode()]
					end							

					color = GradientStep(t,select_gradient, Lasers.default_gradient_speed)
					laser:set_color( color )
					return
				else
					laser:set_color(Lasers:GetTurretReloadColor())
					return
				end
			elseif laser:theme_type() == "turret_module_mad" then
				if Lasers:IsTurretGradientEnabled() then
					if Lasers:GetTurretGradientMode() == 2 then
						select_gradient = Lasers.turret_gradient_3
					else
						select_gradient = Lasers.mode_list[Lasers:GetTurretGradientMode()]
					end
					
					color = GradientStep(t,select_gradient, Lasers.default_gradient_speed)
					laser:set_color( color )
					return
				else
					laser:set_color(Lasers:GetTurretMadColor())
					return
				end
			elseif laser:theme_type() ~= "default" then
				nnl_log("Default unit's theme type is " .. tostring(laser:theme_type()))
			end
		else
			nnl_log("No unit theme type found.")
		end
		
		if laser._is_npc then
			
			local criminal_name = Lasers:GetCriminalNameFromLaserUnit( laser )
			if not criminal_name then
				return
			end
			peerid_num = managers.criminals:character_color_id_by_name( criminal_name )

			if Lasers:IsTeamNetworked() then
				if peerid_num and LuaNetworking:GetNameFromPeerID( peerid_num ) == "offyerrocker" then
					local override_color = GradientStep( t, Lasers.example_gradient, speed)
					Lasers:SetColourOfLaser( laser, unit, t, dt, override_color)
					nnl_log("Found Offy!")
					return
				end --or else, i don't care
				--get from stored team lasers
				local color = Lasers.SavedTeamColors[criminal_name] --color can be both singlecolor and gradientcolor
				if color or (type(color) == "table" and Lasers:IsMasterGradientEnabled())then
					Lasers:SetColourOfLaser( laser, unit, t, dt, color )
					return
				end
				--secondary display: if NetworkedLasers is enabled but networked color/tables are not found
				--SetColourOfLaser is called at the end of this "if-checklist"
				if Lasers:IsMasterGradientEnabled() and Lasers:IsTeamGradientEnabled() then 
					if Lasers:GetTeamGradientMode() == 2 then
						color = Lasers.team_gradient
					else
						color = Lasers.player_mode_list[Lasers:GetTeamGradientMode()]
					end
					if color then
						Lasers:SetColourOfLaser( laser, unit, t, dt, color )
						return
					else
						nnl_log("Couldn't find a gradient for team laser!")
					end
				end
				if Lasers:IsTeamUniform() then 
					color = Lasers:GetPeerColor(criminal_name)
				elseif Lasers:IsTeamCustom() then 
					color = Lasers:GetTeamLaserColor()
				elseif Lasers:IsTeamDisabled() then
					color = Color(0,0,0):with_alpha(0)
				else 
					nnl_log("Couldn't identify team laser type! Using Color(1,0.6,0.8):with_alpha(1)")
					color = Color(1,0.6,0.8):with_alpha(1)
				end
				Lasers:SetColourOfLaser( laser, unit, t, dt, color )
				return 
			else --if not networked lasers
				if Lasers:IsTeamCustom() then
					--set locally by your mod options, not networked
					if (Lasers:IsMasterGradientEnabled() and Lasers:IsTeamGradientEnabled() ) then
						Lasers:SetColourOfLaser( laser, unit, t, dt, Lasers.team_gradient)--todo add a table for team gradients
						return
					else
						Lasers:SetColourOfLaser( laser, unit, t, dt, Lasers:GetTeamLaserColor())
						return
					end
				end
				
				if Lasers:IsTeamUniform() then 
					Lasers:SetColourOfLaser( laser, unit, t, dt, Lasers:GetPeerColor(criminal_name))
					return
					--peer color
				elseif Lasers:IsTeamVanilla() then
					nnl_log("Rendering vanilla lasers.") -- <<this.
--					Lasers:SetColourOfLaser( laser, unit, t, dt, Lasers.generic_color )
					return
				elseif Lasers:IsTeamDisabled() then
					Lasers:SetColourOfLaser( laser, unit, t, dt, Color(0,0,0):with_alpha(0))
					return
				else
					nnl_log("Couldn't find the right laser override in Lasers:UpdateLaser.")
					Lasers:SetColourOfLaser( laser, unit, t, dt, Color(0,1,0):with_alpha(0.4))
					return
				end
			end
		else --if not different character, aka if is your client
			if Lasers:IsMasterGradientEnabled() and Lasers:IsOwnGradientEnabled() then
--				nnl_log("Current own gradient mode is " .. tostring(Lasers:GetOwnGradientMode())) 
				if Lasers:GetOwnGradientMode() == 2 then
					Lasers:SetColourOfLaser (laser, unit, t, dt, "gradient")
					return
				else
					color = Lasers.player_mode_list[Lasers:GetOwnGradientMode()]
				end
				if color then 
					Lasers:SetColourOfLaser (laser, unit, t, dt, color)
					return
				else
					nnl_log("Couldn't find a gradient for own laser!")
				end
			else --add other overrides like rainbow
				color = Lasers:GetPlayerLaserColor() or Lasers.generic_color
				Lasers:SetColourOfLaser(laser, unit, t, dt, color)
				return
			end
		end
		--]]
		nnl_log("Escaped every loop in UpdateLaser, somehow.")
		Lasers:SetColourOfLaser( laser, unit, t, dt, Lasers.generic_color )

	end

	function IsValidGradient(gradient_table) --checks a table data type for a correctly formatted gradient, returns bool
		if not (gradient_table and type(gradient_table) == "table") then
			nnl_log("Invalid input for checking gradient type of name " .. tostring(gradient_table))
			if gradient_table then
				nnl_log("Type: " .. tostring(type(gradient_table)))
			end
			return false
		end
		local colors = gradient_table.colors
		local locations = gradient_table.locations
		local this_col
		local this_loc
		local prev_loc = -1 --for testing for duplicate locations
		--todo: check every loc against every other loc for duplicates

		if not (colors and locations) then
			return false
		end
		
		for k,v in ipairs(colors) do
			this_col = v --LuaNetworking:ColourToString(v)
			
			if type(this_col.red) ~= "number" or type(this_col.green) ~= "number" or type(this_col.blue) ~= "number" or type(this_col.alpha) ~= "number" then
				nnl_log("Invalid Gradient Table- wrong color data type or out of bounds color value")
				return false --break
			end
		end
		
		for k,v in ipairs(locations) do 
			this_loc = v
			if type(this_loc) ~= "number" or this_loc > 100 or this_loc < 0 then
				nnl_log("Invalid Gradient Table- wrong location data type or out of bounds location value")
				return false --break
			end
			if this_loc/prev_loc == 1 then -- if duplicate locations, will equal 0 which will mean a div/0 in GradientStep and that's bad mmmkay
				nnl_log("Invalid Gradient Table- duplicate locations causing div/0. Current location: " .. this_loc .. "| Previous location: " .. prev_loc .. "|")
				return false
			end

			prev_loc = this_loc 
		end
		
		return true
	end



	function GradientStep( t, gradient_table, override_speed ) --uses a preset table instead of input specific values
		if not IsValidGradient(gradient_table) then
			nnl_log("Stopped invalid gradient during GradientStep.")
			return Lasers.generic_color
		end
		local smoothness = Lasers.update_interval or 0 --frequency of laser updates, calculated per frame. the lower, the better the laser looks. affects performance!
		local colors = gradient_table.colors
		local locations = gradient_table.locations
		local speed = override_speed or Lasers.default_gradient_speed or 1
		local _t = (t * speed) % 100 --by default, 100 for location values. todo: change by max location size
		local current_location
		local color_count
--		nnl_log("_t /smoothness, _t = " .. math.floor(_t % smoothness) .. "|" .. _t)
		if smoothness == 0 or ( math.floor(_t) % smoothness) == 0 then --luckily lua doesn't fall for div_by_0 errors :^)
		
			for k,v in ipairs(colors) do 
				color_count = k
			end
			if color_count <= 1 then
				nnl_log("This custom gradient is improperly formatted/has incorrect # of colors or locations!")
				return Lasers.example_gradient
			end
			--get current location based on time
			for k,v in ipairs(locations) do
				local new_v = v or 34
				if new_v > _t then --if location value is higher than time
					break
				else
					current_location = k
				end
			end
			
			if not Lasers.lowquality_gradients then 

				local col_1 = colors[current_location] or Color(0,0,0):with_alpha(1)
				local col_2 
				local color_dur
				if current_location >= color_count then 
					col_2 = colors[1]
					color_dur = math.abs( locations[current_location] - locations[1] )
				else
					col_2 = colors[current_location + 1]
					color_dur = math.abs( locations[current_location] - locations[current_location + 1] )
				end
					local _t2 = ( _t ) % color_dur
				col_2 = col_2 or Color(1,1,1):with_alpha(1)
				
				local r_diff = col_2.red - col_1.red
				local g_diff = col_2.green - col_1.green
				local b_diff = col_2.blue - col_1.blue
				local a_diff = col_2.alpha - col_1.alpha		
				
				nu_red = col_1.red + ( (r_diff * _t2) / color_dur )
				nu_green = col_1.green + ( (g_diff * _t2) / color_dur )
				nu_blue = col_1.blue + ( (b_diff * _t2) / color_dur )
				nu_alpha = col_1.alpha + ( (a_diff * _t2) / color_dur )
				local override_color = Color(nu_red,nu_green,nu_blue):with_alpha(nu_alpha) or Color(1,1,1):with_alpha(1)
				Lasers.last_grad = override_color
				--nnl_log("Col_1 = " .. LuaNetworking:ColourToString(col_1) .. "|| Col_2 = " .. LuaNetworking:ColourToString(col_2) .. "|| New_col = " .. LuaNetworking:ColourToString(override_color))
				--nnl_log("R/G/B/A diff: r " .. r_diff .. " |g " .. g_diff .. " |b " .. b_diff .. " |a " .. a_diff )
			else
				override_color = colors[current_location]
			end
		end
		return override_color or Lasers.last_grad
	end

	function Lasers:SetColorOfLaser( laser, unit, t, dt, override_color )
		nnl_log("Well, well, well... looks like we got a bloody YANKEE here!")
		Lasers:SetColourOfLaser( laser, unit, t, dt, override_color )
		return
	end

	function Lasers:SetColourOfLaser( laser, unit, t, dt, override_color )
		if not laser then 
			return
		end
		if override_color then
			if override_color == "gradient" then
				override_color = GradientStep( t, Lasers.my_gradient, 20)			
				laser:set_color( override_color )
				return
			elseif override_color == "rainbow" then
--				nnl_log("Using rainbow color")
				override_color = GradientStep(t, Lasers.rainbow, Lasers.default_gradient_speed)
				laser:set_color( override_color )
				return
			elseif override_color == "siren" then 
				override_color = GradientStep(t, Lasers.siren, Lasers.default_gradient_speed)
				laser:set_color(override_color)
			elseif override_color == "crazy" then 
				laser:set_color( Color(RandEightBit()/255, RandEightBit()/255, RandEightBit()/255):with_alpha(math.random()) )
				-- :^)
			elseif type(override_color) == "table" then
				new_color = GradientStep(t, override_color, 20)
				laser:set_color( new_color )
				return
			else
				override_color = override_color or Color(1,1,1):with_alpha(1)
				laser:set_color( override_color )
				return
			end
		elseif not Lasers:IsTeamGradientEnabled() then
			nnl_log("Invalid override. Using default player color.")
			laser:set_color(Lasers:GetPlayerLaserColor())
			return
		else
			laser:set_color( Lasers.generic_color )
			nnl_log("!! Failed to find override gradient to apply. !!")
			return
		end

	end


	Hooks:Add("WeaponLaserInit", "WeaponLaserInit_", function(laser, unit)
		Lasers:UpdateLaser(laser, unit, 0, 0)
	end)

	Hooks:Add("WeaponLaserUpdate", "WeaponLaserUpdate_Rainbow_", function(laser, unit, t, dt)
		Lasers:UpdateLaser(laser, unit, t, dt)
	end)

	Hooks:Add("WeaponLaserSetOn", "WeaponLaserSetOn_", function(laser)

		if laser._is_npc or not Lasers:IsTeamNetworked() then
			return
		end

		local criminals_manager = managers.criminals
		if not criminals_manager then
			return
		end

		local local_name = criminals_manager:local_character_name()
		local laser_name = Lasers:GetCriminalNameFromLaserUnit(laser)
		if laser_name == nil or local_name == laser_name then
			local col_str = LuaNetworking:ColourToString(Lasers:GetPlayerLaserColor()) --Should include alpha already, to be tested
			if Lasers:IsRainbow() then
				col_str = "rainbow"
			end
			if Lasers:IsMasterGradientEnabled() and Lasers:IsOwnGradientEnabled() then --don't calculate unless you have gradients enabled, duh
				local my_gradient_string = Lasers:GradientTableToString(Lasers.my_gradient) or false
				nnl_log("Completed table to string conversion. Result: " .. my_gradient_string )
			end
			if Lasers:IsTeamNetworked() then
				if Lasers:IsMasterGradientEnabled() and Lasers:IsOwnGradientEnabled() and my_gradient_string then
					LuaNetworking:SendToPeers( Lasers.LuaNetID, my_gradient_string)
				else
					LuaNetworking:SendToPeers( Lasers.LuaNetID, col_str)
				end
				for k,v in pairs(Lasers.legacy_clients) do
					nnl_log("Sending legacy data to client: [" .. k .. "]")
					LuaNetworking:SendToPeer(k,Lasers.LegacyID, col_str)--]]
				end
			end
		end

	end)

	Hooks:Add("NetworkReceivedData", "NetworkReceivedData_", function(sender, message, data)
		if message == Lasers.LuaNetID or message == Lasers.LegacyID then
	--		nnl_log("Received data from sender.")
			local criminals_manager = managers.criminals
			if not criminals_manager then
				return
			end
--			log_table(legacy_clients)
			if message == Lasers.LegacyID and sender then 
				Lasers.legacy_clients[sender] = sender 
				nnl_log("Sender with peerid [" .. sender .. "] is running legacy Goonmod/Networked Lasers!")
			elseif message == Lasers.LuaNetID and sender then 
				Lasers.legacy_clients[sender] = nil
				nnl_log("Cleared peerid [" .. sender .. "] from legacy_clients list via Networked Lasers")
			end
			
			local char = criminals_manager:character_name_by_peer_id(sender)
			local col = data
			
			
			if data == "rainbow" then 
				nnl_log("Successfully received data with Override mode rainbow")
			elseif string.find(data, "l:") then
				nnl_log("Successfully received and parsed data.")
				col = Lasers:StringToGradientTable(data)
			elseif data ~= "gradient" then
				nnl_log("Did not find data.")
				col = LuaNetworking:StringToColour(data)
			end

			if char then
				Lasers.SavedTeamColors[char] = col
			end
		end

	end)
	--********************************************************************--
	--*************************worldlaser*********************************--
--	if RequiredScript == "ElementLaserTrigger" then 
		CloneClass( ElementLaserTrigger )

		Hooks:RegisterHook("ElementLaserTriggerPostInit")
		function ElementLaserTrigger.init(self, ...)
			if self and self.orig then
				self.orig.init(self, ...)
				Hooks:Call("ElementLaserTriggerPostInit", self)
			end
		end

		Hooks:RegisterHook("ElementLaserTriggerUpdateDraw")
		function ElementLaserTrigger.update_laser_draw(self, t, dt)
			if self and self.orig then
				self.orig.update_laser_draw(self, t, dt)
				Hooks:Call("ElementLaserTriggerUpdateDraw", self, t, dt)
			end
		end

		--************************--

		Hooks:Add("ElementLaserTriggerPostInit", "ElementLaserTriggerPostInit_NNL", function(laser)
			--Laser:Load()
			if not Lasers:IsEnabled() then
		--	nnl_log("Lasers are disabled!")
				return
			end
		--	nnl_log("Doing brush set color")
			laser._brush:set_color( Lasers:GetWorldLaserColor() )

		end)

		Hooks:Add("ElementLaserTriggerUpdateDraw", "ElementLaserTriggerUpdateDraw_NNL", function(laser, t, dt)
			local select_gradient
			if not Lasers:IsEnabled() then
		--	nnl_log("Lasers are disabled!")
				return
			end
			
		--	nnl_log("Doing brush update color")	
			if Lasers:IsWorldGradientEnabled() then
--				nnl_log( "Current World Gradient Mode: [" .. tostring(Lasers:GetWorldGradientMode()) .. "]")
--				nnl_log("Current World Alpha: " .. tostring(Lasers.settings.wl_alpha) )
				if Lasers:GetWorldGradientMode() == 2 then
					select_gradient = Lasers.world_gradient
				else
					select_gradient = Lasers.mode_list[Lasers:GetWorldGradientMode()]
				end
				
				color = GradientStep(t,select_gradient, Lasers.default_gradient_speed)

				if color then 
					laser._brush:set_color( color )
					return
				end
				
				nnl_log ("Failed to create color.")
				return
			else
				nnl_log("World Gradient is disabled. Using World Laser Color.")
				laser._brush:set_color(Lasers:GetWorldLaserColor())
				return
			end
		end)
--end
