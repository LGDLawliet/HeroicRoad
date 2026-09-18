creeps_spell_demon_power_terrorblade = class({})

LinkLuaModifier("modifier_creeps_spell_demon_power_terrorblade", "creeps_spell/creeps_spell_demon_power_terrorblade", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_creeps_spell_demon_power_terrorblade_debuff", "creeps_spell/creeps_spell_demon_power_terrorblade", LUA_MODIFIER_MOTION_NONE)

function creeps_spell_demon_power_terrorblade:IsHiddenWhenStolen() 		return false end
function creeps_spell_demon_power_terrorblade:IsRefreshable() 			return true end
function creeps_spell_demon_power_terrorblade:IsStealable() 				return true end
function creeps_spell_demon_power_terrorblade:IsNetherWardStealable()		return true end
function creeps_spell_demon_power_terrorblade:GetIntrinsicModifierName() return "modifier_creeps_spell_demon_power_terrorblade" end
function creeps_spell_demon_power_terrorblade:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/metamorphosis/unlock2/effect.vpcf", context )

end



modifier_creeps_spell_demon_power_terrorblade = advanced_modifier({})

function modifier_creeps_spell_demon_power_terrorblade:IsDebuff()			return false end
function modifier_creeps_spell_demon_power_terrorblade:IsHidden() 			return true end
function modifier_creeps_spell_demon_power_terrorblade:IsPurgable() 		    return false end
function modifier_creeps_spell_demon_power_terrorblade:IsPurgeException() 	return false end
function modifier_creeps_spell_demon_power_terrorblade:RemoveOnDeath()       return false end
-- function modifier_creeps_spell_demon_power_terrorblade:GetEffectName() return "particles/econ/items/shadow_demon/sd_ti7_shadow_poison/sd_ti7_golden_immortal_ambient_rebuild.vpcf" end
-- function modifier_creeps_spell_demon_power_terrorblade:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end


function modifier_creeps_spell_demon_power_terrorblade:OnCreated()
    if IsServer() then
        local caster = self:GetCaster()
        self.pfx = ParticleManager:CreateParticle("particles/rebuild/spell/metamorphosis/unlock2/effect.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControlEnt(self.pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.pfx, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.pfx, 3, caster, PATTACH_POINT_FOLLOW, "attach_wing_r1", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.pfx, 4, caster, PATTACH_POINT_FOLLOW, "attach_wing_r2", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.pfx, 5, caster, PATTACH_POINT_FOLLOW, "attach_wing_r3", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.pfx, 6, caster, PATTACH_POINT_FOLLOW, "attach_wing_l1", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.pfx, 7, caster, PATTACH_POINT_FOLLOW, "attach_wing_l2", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.pfx, 8, caster, PATTACH_POINT_FOLLOW, "attach_wing_l3", caster:GetAbsOrigin(), true)
        self:AddParticle( self.pfx, false, false, -1, true, false )
    end
end



-- advanced_modifier
function modifier_creeps_spell_demon_power_terrorblade:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE
    }
end

function modifier_creeps_spell_demon_power_terrorblade:Advanced_GetModifierAttackSpeedPercentage(keys)
	return 30
end

