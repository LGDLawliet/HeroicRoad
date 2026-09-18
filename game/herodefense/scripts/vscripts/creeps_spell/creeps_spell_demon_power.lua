creeps_spell_demon_power = class({})

LinkLuaModifier("modifier_creeps_spell_demon_power", "creeps_spell/creeps_spell_demon_power", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_demon_power_debuff", "creeps_spell/creeps_spell_demon_power", LUA_MODIFIER_MOTION_NONE)

function creeps_spell_demon_power:IsHiddenWhenStolen() 		return false end
function creeps_spell_demon_power:IsRefreshable() 			return true end
function creeps_spell_demon_power:IsStealable() 				return true end
function creeps_spell_demon_power:IsNetherWardStealable()		return true end
function creeps_spell_demon_power:GetIntrinsicModifierName() return "modifier_creeps_spell_demon_power" end



modifier_creeps_spell_demon_power = advanced_modifier({})

function modifier_creeps_spell_demon_power:IsDebuff()			return false end
function modifier_creeps_spell_demon_power:IsHidden() 			return true end
function modifier_creeps_spell_demon_power:IsPurgable() 		    return false end
function modifier_creeps_spell_demon_power:IsPurgeException() 	return false end
function modifier_creeps_spell_demon_power:RemoveOnDeath()       return false end
function modifier_creeps_spell_demon_power:GetEffectName() return "particles/econ/items/shadow_demon/sd_ti7_shadow_poison/sd_ti7_golden_immortal_ambient_rebuild.vpcf" end
function modifier_creeps_spell_demon_power:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end


function modifier_creeps_spell_demon_power:OnCreated()
    if IsServer() then
        self:GetParent():AddActivityModifier('run_fast')
        self:GetParent():AddActivityModifier('odachi')
        -- GameRules:AttachWearable(self:GetParent(),"models/heroes/slardar/slardar.vmdl","particles/econ/items/juggernaut/armor_of_the_favorite/juggernaut_favorite_body_ambient.vpcf")
    end
end



function modifier_creeps_spell_demon_power:DeclareFunctions()
	return {
        MODIFIER_EVENT_ON_DEATH,                            --死亡
	}
end


function modifier_creeps_spell_demon_power:Advanced_GetModifierAttackSpeedPercentage()	return self:GetParent():GetHealthPercent()<=50 and 50 or 0 end

function modifier_creeps_spell_demon_power:OnDeath(keys)
    if not IsServer() then
        return
    end

    if keys.attacker == self:GetParent() then
        keys.unit:EmitSound("Hero_DoomBringer.Devour")
        local particle_cast_fx = ParticleManager:CreateParticle("particles/econ/items/doom/doom_ti8_immortal_arms/doom_ti8_immortal_devour.vpcf", PATTACH_ABSORIGIN, keys.attacker)
        ParticleManager:SetParticleControl(particle_cast_fx, 1, keys.attacker:GetAbsOrigin()+Vector(0,0,64))
        ParticleManager:SetParticleControl(particle_cast_fx, 0, keys.unit:GetAbsOrigin()+Vector(0,0,64))
        ParticleManager:ReleaseParticleIndex(particle_cast_fx)

    end
   
end

function modifier_creeps_spell_demon_power:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,
    }

	return funcs

end
