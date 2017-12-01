_G.LasersPlus = _G.LasersPlus or {}
local Lasers = Lasers or _G.LasersPlus

function WeaponFlashLight:update(unit, t, dt)
	if Lasers:IsEnabled() then
		if not self._is_npc then
	--		log("Setting own flashlight color")
			if Lasers:IsOwnFlashlightCustom() then			
				if Lasers:IsOwnFlashlightStrobeEnabled() then 
					color = Lasers:StrobeStep(Lasers:GetOwnFlashlightStrobe())
				else
					color = Lasers:GetOwnFlashlightColor()
				end
			elseif Lasers:IsOwnFlashlightVanilla() then
				color = Lasers.col_generic --todo retrieve color from gadget
			elseif Lasers:IsOwnFlashlightInvisible() then
				color = Lasers.col_invisible
			end
			self._light:set_color(color)
		else
	--		log("Setting NPC flashlight color")
			if Lasers:IsTeamFlashlightCustom() then			
				if Lasers:IsTeamFlashlightStrobeEnabled() then
					color = Lasers:StrobeStep(Lasers:GetNPCFlashlightStrobe())
				else
					color = Lasers:GetTeamFlashlightColor()
				end
			elseif Lasers:IsTeamFlashlightVanilla() then
				color = Lasers.col_generic --todo
			elseif Lasers:IsTeamFlashlightInvisible() then
				color = Lasers.col_invisible
			elseif Lasers:IsTeamFlashlightPeerColor() then
				color = Lasers.col_generic --i'll do this later probably
			end
			self._light:set_color(color)
		end
	end
end

--[[
Hooks:PostHook( WeaponFlashLight, "init", function(self, unit)
	Lasers._npc_flashlight_strobe = Lasers:init_strobe(npc_flashlight_strobe)
	Lasers._own_flashlight_strobe = Lasers:init_strobe(_own_flashlight_strobe)
end)
--]]
