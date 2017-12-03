_G.LasersPlus = _G.LasersPlus or {}
local Lasers = Lasers or _G.LasersPlus

Lasers._path = ModPath
Lasers._data_path = Lasers._data_path or SavePath .. "lasersplus.txt"


Lasers.settings = Lasers.settings or {
	
	enabled_mod_master = true,
	--if false, this mod does not do stuff
	--if true, this mod does stuff
	
	enabled_laser_strobes_master = false,
	--if false, this mod will not render any strobes, and will instead opt for solid-color lasers if applicable
	
	enabled_flashlight_strobes_master = false,
	--no callback yet
	
	enabled_networking = true,
--if true:
--* sends your custom laser strobe pattern to other clients
--* receives custom strobe patterns from other Lasers+ clients and displays them
--on by default

	override_speed = 1,
	--higher numbers will make lasers faster, at no additional performance cost
	
	quality = 5,
	--scale of 1 to 10, which is the frame interval at which the game updates lasers
	--lower quality number is lower/worse performance, ie bad
	--higher quality number is higher/better performance, ie gud
	
	own_laser_display_mode = 3,
	own_flashlight_display_mode = 2,
	team_laser_display_mode = 3,
	team_flashlight_display_mode = 2,
	cop_flashlight_display_mode = 2,
	world_display_mode = 3,
	turret_display_mode = 3,
	sniper_display_mode = 3,

	own_laser_strobe_enabled = true,
	own_flashlight_strobe_enabled = true,
	team_laser_strobe_enabled = false,
	team_flashlight_strobe_enabled = true,
	world_strobe_enabled = true,
	sniper_strobe_enabled = true,
	turret_strobe_enabled = true,
	npc_flashlight_strobe_enabled = true,
	
	own_laser_red = 0,
	own_laser_green = 0,
	own_laser_blue = 0,
	own_laser_alpha = 0,
	
	own_flash_red = 0,
	own_flash_green = 0,
	own_flash_blue = 0,
	own_flash_alpha = 0,

	team_laser_red = 0,
	team_laser_green = 0,
	team_laser_blue = 0,
	team_laser_alpha = 0,
	
	team_flash_red = 0,
	team_flash_green = 0,
	team_flash_blue = 0,
	team_flash_alpha = 0,
	
	npc_flash_red = 0,
	npc_flash_green = 0,
	npc_flash_blue = 0,
	npc_flash_alpha = 0,
	
	wl_red = 0,
	wl_green = 0,
	wl_blue = 0,
	wl_alpha = 0,
	
	snpr_red = 0,
	snpr_green = 0,
	snpr_blue = 0,
	snpr_alpha = 0,

	turr_att_red = 0,
	turr_att_green = 0,
	turr_att_blue = 0,
	turr_att_alpha = 0,

	turr_rld_red = 0,
	turr_rld_green = 0,
	turr_rld_blue = 0,
	turr_rld_alpha = 0,

	turr_mad_red = 0,
	turr_mad_green = 0,
	turr_mad_blue = 0,
	turr_mad_alpha = 0

}

--*****    GetSettings() functions    *****

function Lasers:GetLaserQuality()
	return Lasers.settings.quality or 5
end


function Lasers:GetOwnLaserColor()
	return Color(Lasers.settings.own_laser_red,Lasers.settings.own_laser_green,Lasers.settings.own_laser_blue):with_alpha(Lasers.settings.own_laser_alpha) or Lasers.col_generic
end
function Lasers:GetTeamLaserColor()
	return Color(Lasers.settings.team_laser_red,Lasers.settings.team_laser_green,Lasers.settings.team_laser_blue):with_alpha(Lasers.settings.team_laser_alpha) or Lasers.col_generic
end
function Lasers:GetSniperLaserColor()
	return Color(Lasers.settings.snpr_red,Lasers.settings.snpr_green,Lasers.settings.snpr_blue):with_alpha(Lasers.settings.snpr_alpha) or Lasers.col_generic
end
function Lasers:GetTurretActiveLaserColor()
	return Color(Lasers.settings.turr_att_red,Lasers.settings.turr_att_green,Lasers.settings.turr_att_blue):with_alpha(Lasers.settings.turr_att_alpha) or Lasers.col_generic
end
function Lasers:GetTurretReloadLaserColor()
	return Color(Lasers.settings.turr_rld_red,Lasers.settings.turr_rld_green,Lasers.settings.turr_rld_blue):with_alpha(Lasers.settings.turr_rld_alpha) or Lasers.col_generic
end
function Lasers:GetTurretMadLaserColor()
	return Color(Lasers.settings.turr_mad_red,Lasers.settings.turr_mad_green,Lasers.settings.turr_mad_blue):with_alpha(Lasers.settings.turr_mad_alpha) or Lasers.col_generic
end
function Lasers:GetWorldLaserColor()
	return Color(Lasers.settings.wl_red,Lasers.settings.wl_green,Lasers.settings.wl_blue):with_alpha(Lasers.settings.wl_alpha) or Lasers.col_generic
--	return Color(Lasers.settings.wl_red,Lasers.settings.wl_green,Lasers.settings.wl_blue):with_alpha(Lasers.settings.wl_alpha) or Lasers.col_generic
end

function Lasers:GetOwnFlashlightStrobe()
	if not Lasers._own_flashlight_strobe then
		Lasers._own_flashlight_strobe = Lasers:init_strobe(Lasers.own_flashlight_strobe)
	end
	return Lasers._own_flashlight_strobe
end

function Lasers:GetNPCFlashlightStrobe()
	if not Lasers._npc_flashlight_strobe then 
		Lasers._npc_flashlight_strobe = Lasers:init_strobe(Lasers.npc_flashlight_strobe)
	end
	return Lasers._npc_flashlight_strobe
end

function Lasers:GetOwnLaserStrobe()
	if not Lasers._own_laser_strobe then
		Lasers._own_laser_strobe = Lasers:init_strobe(Lasers.own_laser_strobe)
	end
	return Lasers._own_laser_strobe
end

function Lasers:GetSavedPlayerStrobe()
	if not (Lasers.settings.saved_strobe and type(Lasers.settings.saved_strobe) == "string") then 
		Lasers.settings.saved_strobe = Lasers:StrobeTableToString(Lasers.own_laser_strobe)
	end
	return Lasers.settings.saved_strobe
end

--generic team strobe if you choose to override your teammates' lasers to a custom strobe
function Lasers:GetTeamLaserStrobe()
	if not Lasers._team_laser_strobe then
		Lasers._team_laser_strobe = Lasers:init_strobe(Lasers.team_laser_strobe)
	end
	return Lasers._team_laser_strobe
end

function Lasers:GetWorldStrobe()
	if not Lasers._world_strobe then
		Lasers._world_strobe = Lasers:init_strobe(Lasers.world_strobe)
	end
	return Lasers._world_strobe
end
function Lasers:GetSniperStrobe()
	if not Lasers._sniper_strobe then
		Lasers._sniper_strobe = Lasers:init_strobe(Lasers.sniper_strobe)
	end
	return Lasers._sniper_strobe
end
function Lasers:GetTurretActiveStrobe()
	if not Lasers._turret_active_strobe then
		Lasers._turret_active_strobe = Lasers:init_strobe(Lasers.turret_active_strobe)
	end
	return Lasers._turret_active_strobe
end
function Lasers:GetTurretReloadStrobe()
	if not Lasers._turret_reload_strobe then
		Lasers._turret_reload_strobe = Lasers:init_strobe(Lasers.turret_reload_strobe)
	end
	return Lasers._turret_reload_strobe
end
function Lasers:GetTurretMadStrobe()
	if not Lasers._turret_mad_strobe then
		Lasers._turret_mad_strobe = Lasers:init_strobe(Lasers.turret_mad_strobe)
	end
	return Lasers._turret_mad_strobe
end

function Lasers:GetOwnLaserDisplayMode()
	return Lasers.settings.own_laser_display_mode == 1 and "off"
	or Lasers:IsOwnLaserStrobeEnabled() and "strobe"
	or Lasers.settings.own_laser_display_mode == 2 and "vanilla"
	or Lasers.settings.own_laser_display_mode == 3 and "custom"
end
function Lasers:GetTeamLaserDisplayMode()
	return Lasers.settings.team_laser_display_mode == 1 and "off"
	or Lasers.settings.team_laser_display_mode == 2 and "vanilla"
	or Lasers:IsTeamLaserStrobeEnabled() and "strobe"
	or Lasers.settings.team_laser_display_mode == 3 and "custom"
	or Lasers.settings.team_laser_display_mode == 4 and "Peer Color"
end
function Lasers:GetWorldDisplayMode()
	return Lasers.settings.world_display_mode == 1 and "off"
	or Lasers.settings.world_display_mode == 2 and "vanilla"
	or Lasers:IsWorldStrobeEnabled() and "strobe"
	or Lasers.settings.world_display_mode == 3 and "custom"
end
function Lasers:GetSniperDisplayMode()
	return Lasers.settings.sniper_display_mode == 1 and "off"
	or Lasers.settings.sniper_display_mode == 2 and "vanilla"
	or Lasers:IsSniperStrobeEnabled() and "strobe"
	or Lasers.settings.sniper_display_mode == 3 and "custom"
end
function Lasers:GetTurretDisplayMode()
	return Lasers.settings.turret_display_mode == 1 and "off"
	or Lasers.settings.turret_display_mode == 2 and "vanilla"
	or Lasers:IsTurretStrobeEnabled() and "strobe"
	or Lasers.settings.turret_display_mode == 3 and "custom"
end

--Enables the whole mod's effects
function Lasers:IsEnabled()
	return Lasers.settings.enabled_mod_master
end

function Lasers:IsNetworkingEnabled()
	return Lasers.settings.enabled_networking
end

function Lasers:IsMasterLaserStrobeEnabled()
	return Lasers.settings.enabled_laser_strobes_master
end

function Lasers:IsOwnLaserStrobeEnabled()
--	if Lasers.settings.own_laser_strobe_enabled then
--		log("Own Strobe is enabled!")
--	else
--		log("Own Strobe is disabled!")
--	end
	return Lasers.settings.own_laser_strobe_enabled
end
function Lasers:IsOwnFlashlightStrobeEnabled()
	return Lasers.settings.own_flashlight_strobe_enabled
end
function Lasers:IsTeamFlashlightStrobeEnabled()
	return Lasers.settings.team_flashlight_strobe_enabled
end

function Lasers:GetTeamFlashlightColor()
	return Color(Lasers.settings.team_flash_red,Lasers.settings.team_flash_green,Lasers.settings.team_flash_blue):with_alpha(Lasers.settings.team_flash_alpha) or Lasers.col_generic
end
function Lasers:GetOwnFlashlightColor()
	return Color(Lasers.settings.own_flash_red,Lasers.settings.own_flash_green,Lasers.settings.own_flash_blue):with_alpha(Lasers.settings.own_flash_alpha) or Lasers.col_generic
end

function Lasers:IsOwnLaserInvisible() 
	return Lasers.settings.own_laser_display_mode == 1
end
function Lasers:IsOwnLaserVanilla() 
	return Lasers.settings.own_laser_display_mode == 2
end
function Lasers:IsOwnLaserCustom() 
	return Lasers.settings.own_laser_display_mode == 3
end

function Lasers:IsTeamLaserInvisible() 
	return Lasers.settings.team_laser_display_mode == 1
end
function Lasers:IsTeamLaserVanilla() 
	return Lasers.settings.team_laser_display_mode == 2
end
function Lasers:IsTeamLaserCustom() 
	return Lasers.settings.team_laser_display_mode == 3
end
function Lasers:IsTeamLaserPeerColor()
	return Lasers.settings.team_laser_display_mode == 4
end
--disabled for now


function Lasers:IsOwnFlashlightInvisible() 
	return Lasers.settings.own_flashlight_display_mode == 1
end
function Lasers:IsOwnFlashlightVanilla() 
	return Lasers.settings.own_flashlight_display_mode == 2
end
function Lasers:IsOwnFlashlightCustom() 
	return Lasers.settings.own_flashlight_display_mode == 3
end

function Lasers:IsTeamFlashlightInvisible() 
	return Lasers.settings.team_flashlight_display_mode == 1
end
function Lasers:IsTeamFlashlightVanilla() 
	return Lasers.settings.team_flashlight_display_mode == 2
end
function Lasers:IsTeamFlashlightCustom() 
	return Lasers.settings.team_flashlight_display_mode == 3
end
function Lasers:IsTeamFlashlightPeerColor()
	return Lasers.settings.team_flashlight_display_mode == 4
end

function Lasers:IsTeamLaserInvisible() 
	return Lasers.settings.team_laser_display_mode == 1
end
function Lasers:IsTeamLaserVanilla() 
	return Lasers.settings.team_laser_display_mode == 2
end
function Lasers:IsTeamLaserCustom() 
	return Lasers.settings.team_laser_display_mode == 3
end
function Lasers:IsTeamLaserPeerColor()
	return Lasers.settings.team_laser_display_mode == 4
end

function Lasers:IsTeamLaserStrobeEnabled()
	return Lasers.settings.team_strobe_enabled
end
function Lasers:IsWorldStrobeEnabled()
	return Lasers.settings.world_strobe_enabled
end
function Lasers:IsSniperStrobeEnabled()
	return Lasers.settings.sniper_strobe_enabled
end
function Lasers:IsTurretStrobeEnabled()
	return Lasers.settings.turret_strobe_enabled
end

function Lasers:IsTurretInvisible() 
	return Lasers.settings.turret_display_mode == 1
end
function Lasers:IsTurretVanilla() 
	return Lasers.settings.turret_display_mode == 2
end
function Lasers:IsTurretCustom() 
	return Lasers.settings.turret_display_mode == 3
end



function Lasers:IsSniperInvisible() 
	return Lasers.settings.sniper_display_mode == 1
end
function Lasers:IsSniperVanilla() 
	return Lasers.settings.sniper_display_mode == 2
end
function Lasers:IsSniperCustom() 
	return Lasers.settings.sniper_display_mode == 3
end

function Lasers:IsWorldInvisible() 
	return Lasers.settings.world_display_mode == 1
end
function Lasers:IsWorldVanilla() 
	return Lasers.settings.world_display_mode == 2
end
function Lasers:IsWorldCustom() 
	return Lasers.settings.world_display_mode == 3
end


--[[
	function Lasers:LoadStrobes()	
		local file = io.open(self._data_path, "r")
		if (file) then
			for k, v in pairs(json.decode(file:read("*all"))) do
				self.strobes[k] = v
			end
		end
	end
	
	function Lasers:SaveStrobes()
		local file = io.open(self._data_path,"w+")
		if file then
			file:write(json.encode(self.strobes))
			file:close()
		end
	end
--]]


function Lasers:Load()
	local file = io.open(self._data_path, "r")
	if (file) then
		for k, v in pairs(json.decode(file:read("*all"))) do
			self.settings[k] = v
		end
	end
	Lasers.settings.saved_strobe = Lasers:StrobeTableToString(Lasers.own_laser_strobe)
end

function Lasers:Save()
	local file = io.open(self._data_path,"w+")
	if file then
		file:write(json.encode(self.settings))
		file:close()
	end
end

Hooks:Add("LocalizationManagerPostInit", "LocalizationManagerPostInit_LasersPlus", function( loc )
	loc:load_localization_file( Lasers._path .. "en.txt")
end)

Hooks:Add( "MenuManagerInitialize", "MenuManagerInitialize_LasersPlus", function(menu_manager)
	
	MenuCallbackHandler.callback_lp_master_enabled_toggle = function(self,item)
		local value = item:value() == 'on' and true or false
		Lasers.settings.enabled_mod_master = value
		Lasers:Save()
	end
	
	MenuCallbackHandler.callback_lp_laser_strobes_enabled_toggle = function(self,item)
		local value = item:value() == 'on' and true or false
		Lasers.settings.enabled_laser_strobes_master = value
		Lasers:Save()
	end

	MenuCallbackHandler.callback_lp_networking_enabled_toggle = function(self,item)
		local value = item:value() == 'on' and true or false
		Lasers.settings.enabled_networking = value
		Lasers:Save()
	end
	
	MenuCallbackHandler.callback_lp_own_laser_display_mode_multiplechoice = function(self,item)
		Lasers.settings.own_laser_display_mode = tonumber(item:value())
		Lasers:Save()
	end
		MenuCallbackHandler.callback_lp_own_laser_strobe_enabled_toggle = function(self,item)
			local value = item:value() == 'on' and true or false
			Lasers.settings.own_laser_strobe_enabled = value
			Lasers:Save()
		end	
		MenuCallbackHandler.callback_lp_own_laser_r_slider = function(self,item)
			Lasers.settings.own_laser_red = item:value()
			Lasers:Save()
		end
		MenuCallbackHandler.callback_lp_own_laser_g_slider = function(self,item)
			Lasers.settings.own_laser_green = item:value()
			Lasers:Save()
		end
		MenuCallbackHandler.callback_lp_own_laser_b_slider = function(self,item)
			Lasers.settings.own_laser_blue = item:value()
			Lasers:Save()
		end
		MenuCallbackHandler.callback_lp_own_laser_a_slider = function(self,item)
			Lasers.settings.own_laser_alpha = item:value()
			Lasers:Save()
		end
		
	MenuCallbackHandler.callback_lp_own_flashlight_strobe_enabled_toggle = function(self,item)
		local value = item:value() == 'on' and true or false
		Lasers.settings.own_flashlight_strobe_enabled = value
		Lasers:Save()
	end	
		MenuCallbackHandler.callback_lp_own_flashlight_display_mode_multiplechoice = function(self,item)
			Lasers.settings.own_flashlight_display_mode = tonumber(item:value())
			Lasers:Save()
		end		
		MenuCallbackHandler.callback_lp_own_flashlight_r_slider = function(self,item)
			Lasers.settings.own_flash_red = item:value()
			Lasers:Save()
		end
		MenuCallbackHandler.callback_lp_own_flashlight_g_slider = function(self,item)
			Lasers.settings.own_flash_green = item:value()
			Lasers:Save()
		end
		MenuCallbackHandler.callback_lp_own_flashlight_b_slider = function(self,item)
			Lasers.settings.own_flash_blue = item:value()
			Lasers:Save()
		end
		MenuCallbackHandler.callback_lp_own_flashlight_a_slider = function(self,item)
			Lasers.settings.own_flash_alpha = item:value()
			Lasers:Save()
		end
	
	MenuCallbackHandler.callback_lp_team_laser_display_mode_multiplechoice = function(self,item)
		Lasers.settings.team_laser_display_mode = tonumber(item:value())
		Lasers:Save()
	end
	MenuCallbackHandler.callback_lp_team_laser_strobe_enabled_toggle = function(self,item)
		local value = item:value() == 'on' and true or false
		Lasers.settings.team_laser_strobe_enabled = value
		Lasers:Save()
	end		
		MenuCallbackHandler.callback_lp_team_laser_r_slider = function(self,item)
			Lasers.settings.team_laser_red = item:value()
			Lasers:Save()
		end
		MenuCallbackHandler.callback_lp_team_laser_g_slider = function(self,item)
			Lasers.settings.team_laser_green = item:value()
			Lasers:Save()
		end
		MenuCallbackHandler.callback_lp_team_laser_b_slider = function(self,item)
			Lasers.settings.team_laser_blue = item:value()		
			Lasers:Save()
		end
		MenuCallbackHandler.callback_lp_team_laser_a_slider = function(self,item)
			Lasers.settings.team_laser_alpha = item:value()
			Lasers:Save()
		end

	MenuCallbackHandler.callback_lp_team_flashlight_strobe_enabled_toggle = function(self,item)
		local value = item:value() == 'on' and true or false
		Lasers.settings.team_flashlight_strobe_enabled = value
		Lasers:Save()
	end	
		MenuCallbackHandler.callback_lp_team_flashlight_display_mode_multiplechoice = function(self,item)
			Lasers.settings.team_flashlight_display_mode = tonumber(item:value())
			Lasers:Save()
		end		
		MenuCallbackHandler.callback_lp_team_flashlight_r_slider = function(self,item)
			Lasers.settings.team_flash_red = item:value()
			Lasers:Save()
		end
		MenuCallbackHandler.callback_lp_team_flashlight_g_slider = function(self,item)
			Lasers.settings.team_flash_green = item:value()
			Lasers:Save()
		end
		MenuCallbackHandler.callback_lp_team_flashlight_b_slider = function(self,item)
			Lasers.settings.team_flash_blue = item:value()
			Lasers:Save()
		end
		MenuCallbackHandler.callback_lp_team_flashlight_a_slider = function(self,item)
			Lasers.settings.team_flash_alpha = item:value()
			Lasers:Save()
		end
		
	MenuCallbackHandler.callback_lp_world_display_mode_multiplechoice = function(self,item)
		Lasers.settings.world_display_mode = tonumber(item:value())
		Lasers:Save()
	end
	MenuCallbackHandler.callback_lp_world_strobe_enabled_toggle = function(self,item)
		local value = item:value() == 'on' and true or false
		Lasers.settings.world_strobe_enabled = value
		Lasers:Save()
	end		
		MenuCallbackHandler.callback_lp_wl_r_slider = function(self,item)
			Lasers.settings.wl_red = item:value()
			Lasers:Save()
		end
		MenuCallbackHandler.callback_lp_wl_g_slider = function(self,item)
			Lasers.settings.wl_green = item:value()
			Lasers:Save()
		end
		MenuCallbackHandler.callback_lp_wl_b_slider = function(self,item)
			Lasers.settings.wl_blue = item:value()
			Lasers:Save()
		end
		MenuCallbackHandler.callback_lp_wl_a_slider = function(self,item)
			Lasers.settings.wl_alpha = item:value()
			Lasers:Save()
		end

	MenuCallbackHandler.callback_lp_sniper_display_mode_multiplechoice = function(self,item)
		Lasers.settings.sniper_display_mode = tonumber(item:value())
		Lasers:Save()
	end
	MenuCallbackHandler.callback_lp_sniper_strobe_enabled_toggle = function(self,item)
		local value = item:value() == 'on' and true or false
		Lasers.settings.sniper_strobe_enabled = value
		Lasers:Save()
	end		
		MenuCallbackHandler.callback_lp_snpr_r_slider = function(self,item)
			Lasers.settings.snpr_red = item:value()
			Lasers:Save()
		end
		MenuCallbackHandler.callback_lp_snpr_g_slider = function(self,item)
			Lasers.settings.snpr_green = item:value()
			Lasers:Save()
		end
		MenuCallbackHandler.callback_lp_snpr_b_slider = function(self,item)
			Lasers.settings.snpr_blue = item:value()
			Lasers:Save()
		end
		MenuCallbackHandler.callback_lp_snpr_a_slider = function(self,item)
			Lasers.settings.snpr_alpha = item:value()
			Lasers:Save()
		end

	MenuCallbackHandler.callback_lp_turret_display_mode_multiplechoice = function(self,item)
		Lasers.settings.turret_display_mode = tonumber(item:value())
		Lasers:Save()
	end
	MenuCallbackHandler.callback_lp_turret_strobe_enabled_toggle = function(self,item)
		local value = item:value() == 'on' and true or false
		Lasers.settings.turret_strobe_enabled = value
		Lasers:Save()
	end	
		MenuCallbackHandler.callback_lp_turr_att_r_slider = function(self,item)
			Lasers.settings.turr_att_red = item:value()
			Lasers:Save()
		end
		MenuCallbackHandler.callback_lp_turr_att_g_slider = function(self,item)
			Lasers.settings.turr_att_green = item:value()
			Lasers:Save()
		end
		MenuCallbackHandler.callback_lp_turr_att_b_slider = function(self,item)
			Lasers.settings.turr_att_blue = item:value()
			Lasers:Save()
		end
		MenuCallbackHandler.callback_lp_turr_att_a_slider = function(self,item)
			Lasers.settings.turr_att_alpha = item:value()
			Lasers:Save()
		end
		
		MenuCallbackHandler.callback_lp_turr_rld_r_slider = function(self,item)
			Lasers.settings.turr_rld_red = item:value()
			Lasers:Save()
		end	
		MenuCallbackHandler.callback_lp_turr_rld_g_slider = function(self,item)
			Lasers.settings.turr_rld_green = item:value()
			Lasers:Save()
		end
		MenuCallbackHandler.callback_lp_turr_rld_b_slider = function(self,item)
			Lasers.settings.turr_rld_blue = item:value()
			Lasers:Save()
		end
		MenuCallbackHandler.callback_lp_turr_rld_a_slider = function(self,item)
			Lasers.settings.turr_rld_alpha = item:value()
			Lasers:Save()
		end

		MenuCallbackHandler.callback_lp_turr_ecm_r_slider = function(self,item)
			Lasers.settings.turr_ecm_red = item:value()
			Lasers:Save()
		end
		MenuCallbackHandler.callback_lp_turr_ecm_g_slider = function(self,item)
			Lasers.settings.turr_ecm_green = item:value()
			Lasers:Save()
		end
		MenuCallbackHandler.callback_lp_turr_ecm_b_slider = function(self,item)
			Lasers.settings.turr_ecm_blue = item:value()
			Lasers:Save()
		end
		MenuCallbackHandler.callback_lp_turr_ecm_a_slider = function(self,item)
			Lasers.settings.turr_ecm_alpha = item:value()
			Lasers:Save()
		end

	MenuCallbackHandler.callback_lp_close = function(this)
		Lasers:Save()
	end
	Lasers:Load()
	MenuHelper:LoadFromJsonFile(Lasers._path .. "options.txt", Lasers, Lasers.settings)	
end)



--function Lasers:Load()

--[[

function Lasers:GetTurretActiveColor()
	return Lasers.DefaultTeamColors[3]
end
function Lasers:GetTurretReloadStrobe()
	return Lasers.DefaultTeamColors[4]
end
function Lasers:GetTurretMadStrobe()
	return Lasers.DefaultTeamColors[2]
end
function Lasers:GetPlayerGradient()--
	return Lasers.settings.selected_gradient
end

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


function lp_log(message)
	if Lasers.debugLogsEnabled then 
		log("Lasers Plus: " .. message)
	end
end
--]]