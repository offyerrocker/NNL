_G.LaserTeam = _G.LaserTeam or {}
local Lasers = Lasers or _G.LaserTeam
Lasers._path = ModPath
Lasers._data_path = Lasers._data_path or SavePath .. "nnlasers.txt"
Lasers._data = Lasers._data or Lasers.settings or {}

	Lasers.default_settings = Lasers.default_settings or {
		enabled_gradients_master = "enabled", 
--Player/self
		enabled_own_gradients = "enabled",		
		own_red = 0.9,
		own_green = 0.2,
		own_blue = 0.15,
		own_alpha = 0.08,
		
--team/other players
		enabled_team_gradients = "enabled",
		team_red = 0.8,
		team_green = 0.1,
		team_blue = 0.25,
		team_alpha = 0.04,
		
--police snipers
		enabled_snpr_gradients = "enabled",
		snpr_red = 1,
		snpr_green = 0.2,
		snpr_blue = 0.2,
		snpr_alpha = 0.5,
				
--world lasers/vault lasers (go bank, big bank, murky station, golden grin etc)
		enabled_wl_gradients = "enabled",
		wl_red = 0.8,
		wl_green = 0.5,
		wl_blue = 0.15,
		wl_alpha = 0.8,

--swat turrets
	--turret normal attack
		enabled_turr_gradients = "enabled",
		turr_att_red = 1,
		turr_att_green = 0.4,
		turr_att_blue = 0.1,
		turr_att_alpha = 0.4,
	--turret reloading
		turr_rld_red = 0.7,
		turr_rld_green = 0.7,
		turr_rld_blue = 0.4,
		turr_rld_alpha = 0.25,
	--turret ecm (friendly)
		turr_ecm_red = 0.2,
		turr_ecm_green = 0.8,
		turr_ecm_blue = 1,
		turr_ecm_alpha = 0.4,

--NL view settings
	--team laser display mode
		--[[
		1 : Custom (User-set)
		2 : Uniform (Same as Peer Color - ie. Green if Host, Blue if P2, Red if P3, Yellow if P4)
		3 : Networked (Uses the other client's laser color through Lua Networking. Cool, right?)
		4 : Turned Off
		;)  ^ classy amirite
		--]]
		display_team_lasers = 3,
	--network my lasers, on by default. Why else would you have downloaded this mod?
		networked_lasers = "enabled"
	}
		
	Lasers.settings = Lasers.settings or Lasers.default_settings
	
	Lasers._data = Lasers._data or Lasers.settings or {}

	function Lasers:Load()
		self.settings = self.settings or self.default_settings
		
		local file = io.open(self._data_path, "r")
		if (file) then
			for k, v in pairs(json.decode(file:read("*all"))) do
				self.settings[k] = v
			end
		end
	end
	
	function Lasers:Save()
		local file = io.open(self._data_path,"w+")
		if file then
			file:write(json.encode(self.settings))
			file:close()
		end
	end
	--[[
	function Lasers:getCompleteTable()
		local tbl = {}
		for i, v in pairs (Lasers.settings) do
			if not i == nil then
				tbl[i] = v + 1
			end
		end
		return tbl
	end
	--]]
	function Lasers:Reset()
		Lasers.settings = Lasers.default_settings
		--i might be going to programmer's hell for this
	end

	--[[
	function setPR (this, item)
		if not Lasers.settings[own_red] then 
			Lasers:Load()
		end
	end
	--]]

	Hooks:Add("LocalizationManagerPostInit", "LocalizationManagerPostInit_NewNetworkedLasers", function( loc )
		loc:load_localization_file( Lasers._path .. "en.txt")
	end)
	
	Hooks:Add( "MenuManagerInitialize", "MenuManagerInitialize_NewNetworkedLasers", function(menu_manager)
	
		MenuCallbackHandler.callback_own_r_slider = function(self,item)
			Lasers.settings.own_red = item:value()
			Lasers:Save()
		end
		
		MenuCallbackHandler.callback_own_g_slider = function(self,item)
			Lasers.settings.own_green = item:value()
			Lasers:Save()
		end
	
		MenuCallbackHandler.callback_own_b_slider = function(self,item)
			Lasers.settings.own_blue = item:value()
			Lasers:Save()
		end
		
		MenuCallbackHandler.callback_own_a_slider = function(self,item)
			Lasers.settings.own_alpha = item:value()
			Lasers:Save()
		end
		
		
		
		
		MenuCallbackHandler.callback_team_r_slider = function(self,item)
			Lasers.settings.team_red = item:value()
			Lasers:Save()
		end
		
		MenuCallbackHandler.callback_team_g_slider = function(self,item)
			Lasers.settings.team_green = item:value()
			Lasers:Save()
		end
		
		MenuCallbackHandler.callback_team_b_slider = function(self,item)
			Lasers.settings.team_blue = item:value()		
			Lasers:Save()
		end
		
		MenuCallbackHandler.callback_team_a_slider = function(self,item)
			Lasers.settings.team_alpha = item:value()
			Lasers:Save()
		end

		
		
		
		MenuCallbackHandler.callback_snpr_r_slider = function(self,item)
			Lasers.settings.snpr_red = item:value()
			Lasers:Save()
		end
		
		MenuCallbackHandler.callback_snpr_g_slider = function(self,item)
			Lasers.settings.snpr_green = item:value()
			Lasers:Save()
		end
		
		MenuCallbackHandler.callback_snpr_b_slider = function(self,item)
			Lasers.settings.snpr_blue = item:value()
			Lasers:Save()
		end

		MenuCallbackHandler.callback_snpr_a_slider = function(self,item)
			Lasers.settings.snpr_alpha = item:value()
			Lasers:Save()
		end
		
		
		
		
		
		MenuCallbackHandler.callback_wl_r_slider = function(self,item)
			Lasers.settings.wl_red = item:value()
			Lasers:Save()
		end
				
		MenuCallbackHandler.callback_wl_g_slider = function(self,item)
			Lasers.settings.wl_green = item:value()
			Lasers:Save()
		end

		MenuCallbackHandler.callback_wl_b_slider = function(self,item)
			Lasers.settings.wl_blue = item:value()
			Lasers:Save()
		end
				
		MenuCallbackHandler.callback_wl_a_slider = function(self,item)
			Lasers.settings.wl_alpha = item:value()
			Lasers:Save()
		end
		
		
		
		
		MenuCallbackHandler.callback_turr_att_r_slider = function(self,item)
			Lasers.settings.turr_att_red = item:value()
			Lasers:Save()
		end
				
		MenuCallbackHandler.callback_turr_att_g_slider = function(self,item)
			Lasers.settings.turr_att_green = item:value()
			Lasers:Save()
		end

		MenuCallbackHandler.callback_turr_att_b_slider = function(self,item)
			Lasers.settings.turr_att_blue = item:value()
			Lasers:Save()
		end
				
		MenuCallbackHandler.callback_turr_att_a_slider = function(self,item)
			Lasers.settings.turr_att_alpha = item:value()
			Lasers:Save()
		end

		
		
		
		MenuCallbackHandler.callback_turr_rld_r_slider = function(self,item)
			Lasers.settings.turr_rld_red = item:value()
			Lasers:Save()
		end
				
		MenuCallbackHandler.callback_turr_rld_g_slider = function(self,item)
			Lasers.settings.turr_rld_green = item:value()
			Lasers:Save()
		end

		MenuCallbackHandler.callback_turr_rld_b_slider = function(self,item)
			Lasers.settings.turr_rld_blue = item:value()
			Lasers:Save()
		end
				
		MenuCallbackHandler.callback_turr_rld_a_slider = function(self,item)
			Lasers.settings.turr_rld_alpha = item:value()
			Lasers:Save()
		end
		
		
		
		
		MenuCallbackHandler.callback_turr_ecm_r_slider = function(self,item)
			Lasers.settings.turr_ecm_red = item:value()
			Lasers:Save()
		end
				
		MenuCallbackHandler.callback_turr_ecm_g_slider = function(self,item)
			Lasers.settings.turr_ecm_green = item:value()
			Lasers:Save()
		end

		MenuCallbackHandler.callback_turr_ecm_b_slider = function(self,item)
			Lasers.settings.turr_ecm_blue = item:value()
			Lasers:Save()
		end
				
		MenuCallbackHandler.callback_turr_ecm_a_slider = function(self,item)
			Lasers.settings.turr_ecm_alpha = item:value()
			Lasers:Save()
		end
		
		MenuCallbackHandler.callback_team_lasers_display_multiplechoice = function(self,item)
			Lasers.settings.display_team_lasers = tonumber(item:value())
			Lasers:Save()
		end
		
		MenuCallbackHandler.callback_networked_lasers_toggle = function(self,item)
			local value = item:value() == 'on' and true or false -- == not value --"true" and true or false --"disabled"
			Lasers.settings.networked_lasers = value
			Lasers:Save()
		end
		
		MenuCallbackHandler.callback_master_gradients_toggle = function(self,item)
			local value = item:value() == 'on' and true or false -- == not value --"true" and true or false --"disabled"
			Lasers.settings.enabled_gradients_master = value
			Lasers:Save()
		end
		
		MenuCallbackHandler.callback_own_gradients_toggle = function(self,item)
			local value = item:value() == 'on' and true or false -- == not value --"true" and true or false --"disabled"
			Lasers.settings.enabled_own_gradients = value
			Lasers:Save()
		end
		
		MenuCallbackHandler.callback_team_gradients_toggle = function(self,item)
			local value = item:value() == 'on' and true or false -- == not value --"true" and true or false --"disabled"
			Lasers.settings.enabled_team_gradients = value
			Lasers:Save()
		end
		
		MenuCallbackHandler.callback_sniper_gradients_toggle = function(self,item)
			local value = item:value() == 'on' and true or false -- == not value --"true" and true or false --"disabled"
			Lasers.settings.enabled_snpr_gradients = value
			Lasers:Save()
		end
		
		MenuCallbackHandler.callback_world_gradients_toggle = function(self,item)
			local value = item:value() == 'on' and true or false -- == not value --"true" and true or false --"disabled"
			Lasers.settings.enabled_wl_gradients = value
			Lasers:Save()
		end
	
		MenuCallbackHandler.callback_turret_gradients_toggle = function(self,item)
			local value = item:value() == 'on' and true or false -- == not value --"true" and true or false --"disabled"
			Lasers.settings.enabled_turr_gradients = value
			Lasers:Save()
		end
		
		MenuCallbackHandler.callback_nnl_close = function(this)
			Lasers:Save()
		end
		
		Lasers:Load()
		MenuHelper:LoadFromJsonFile(Lasers._path .. "options.txt", Lasers, Lasers.settings)
--		MenuHelper:LoadFromJsonFile(LaserTeam._path .. "options.txt", LaserTeam, LaserTeam:getCompleteTable())
		
	end )