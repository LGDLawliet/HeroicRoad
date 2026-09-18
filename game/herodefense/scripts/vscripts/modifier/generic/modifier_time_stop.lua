
chaotic_time_stop = class({})

LinkLuaModifier("modifier_time_stop_debuff",  "modifier/generic/modifier_time_stop", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_time_stop_ban",  "modifier/generic/modifier_time_stop", LUA_MODIFIER_MOTION_NONE)




modifier_time_stop_aura = advanced_modifier({})
function modifier_time_stop_aura:IsHidden() return false end
function modifier_time_stop_aura:IsPurgable() return false end
function modifier_time_stop_aura:IsDebuff() return false end
function modifier_time_stop_aura:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_time_stop/effect_target/effect.vpcf", context )

end
function modifier_time_stop_aura:OnCreated(keys)
	if IsServer() then
		local sound_cast = "Hero_FacelessVoid.Chronosphere.MaceOfAeons"    
		EmitGlobalSound(sound_cast) 
		-- local ability = self:GetAbility()
		local pfx_name = "particles/rebuild/chaotic_spell/chaotic_time_stop/effect_main/effect.vpcf"
		local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(pfx, 1, Vector(20000,5000,5000))
		ParticleManager:SetParticleShouldCheckFoW(pfx, false)
		self:AddParticle(pfx, false, false, 16, false, false)
	end
end



function modifier_time_stop_aura:IsAura() return true end
function modifier_time_stop_aura:GetAuraDuration() return 3 end
function modifier_time_stop_aura:GetModifierAura() return "modifier_time_stop_ban" end
function modifier_time_stop_aura:GetAuraRadius() return 99999 end
function modifier_time_stop_aura:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end
function modifier_time_stop_aura:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_BOTH end
function modifier_time_stop_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BUILDING + DOTA_UNIT_TARGET_BASIC end
function modifier_time_stop_aura:GetAuraEntityReject(unit)
	local parent = self:GetParent()
	if parent==unit then
		return true
	end
	if unit:IsRealHero() then
		return true
	end
	if unit:IsControllableByAnyPlayer() then
		return true
	end
	return false
end


function modifier_time_stop_aura:SetEndCallback( func )
	self.endCallback = func
end

function modifier_time_stop_aura:OnDestroy()
	if not IsServer() then return end
	if self.endCallback then
		self.endCallback()
	end
end







modifier_time_stop_debuff = class({})
function modifier_time_stop_debuff:IsHidden() 			return true end
function modifier_time_stop_debuff:IsPurgable() 			return false end
function modifier_time_stop_debuff:IsPurgeException() 	return false end
function modifier_time_stop_debuff:GetPriority() return MODIFIER_PRIORITY_SUPER_ULTRA end
function modifier_time_stop_debuff:IsDebuff() return true end
function modifier_time_stop_debuff:IsStunDebuff()	return true end
function modifier_time_stop_debuff:IsMotionController() return true end
function modifier_time_stop_debuff:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_HIGHEST end
function modifier_time_stop_debuff:GetStatusEffectName() return "particles/status_fx/status_effect_faceless_chronosphere.vpcf" end
function modifier_time_stop_debuff:StatusEffectPriority() return 16 end
function modifier_time_stop_debuff:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_DISARMED] = true, 
		[MODIFIER_STATE_INVISIBLE] = false, 
		[MODIFIER_STATE_FROZEN] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = true
	}
end


function modifier_time_stop_debuff:OnDestroy()
	if IsServer() then
		local parent = self:GetParent()
		if not parent:IsAlive() then
			parent:StartGestureWithFadeAndPlaybackRate(ACT_DOTA_DIE, 0, 0.9, 0.1)
		end
		
	end

end







modifier_time_stop_ban = modifier_time_stop_ban or advanced_modifier({})

function modifier_time_stop_ban:IsHidden() 			return true end
function modifier_time_stop_ban:IsPurgable() 			return false end
function modifier_time_stop_ban:IsPurgeException() 	return false end
function modifier_time_stop_ban:GetPriority() return MODIFIER_PRIORITY_SUPER_ULTRA end
function modifier_time_stop_ban:IsDebuff() return true end
function modifier_time_stop_ban:IsStunDebuff()	return true end
function modifier_time_stop_ban:IsMotionController() return true end
function modifier_time_stop_ban:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_HIGHEST end
function modifier_time_stop_ban:GetStatusEffectName() return "particles/status_fx/status_effect_faceless_chronosphere.vpcf" end
function modifier_time_stop_ban:StatusEffectPriority() return 16 end

function modifier_time_stop_ban:CheckState()
	local state = {
		-- [MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		-- [MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_FROZEN] = true,
		-- [MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_DISARMED] = true, 
		[MODIFIER_STATE_INVISIBLE] = false, 
	}

	return state
end

function modifier_time_stop_ban:DeclareFunctions()
    return 
    {
		MODIFIER_PROPERTY_DISABLE_HEALING
    }
end
function modifier_time_stop_ban:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL
    }
end
function modifier_time_stop_ban:GetDisableHealing(keys)
	return 1
end
function modifier_time_stop_ban:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)
	return -50
end