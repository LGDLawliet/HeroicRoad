
Primary_Eldwurm_soul_Indrak = class({})


LinkLuaModifier("modifier_Primary_Eldwurm_soul_Indrak", "skills/Primary_Eldwurm_soul_Indrak", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Primary_Eldwurm_soul_Indrak_effect", "skills/Primary_Eldwurm_soul_Indrak", LUA_MODIFIER_MOTION_NONE)
require('internal/timers')   --计时器功能

function Primary_Eldwurm_soul_Indrak:GetIntrinsicModifierName() return "modifier_Primary_Eldwurm_soul_Indrak" end
function Primary_Eldwurm_soul_Indrak:IsHiddenWhenStolen() 		return false end
function Primary_Eldwurm_soul_Indrak:IsRefreshable() 			return true  end

function Primary_Eldwurm_soul_Indrak:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/static_field_aoe/lighting_aoe.vpcf", context )
	-- PrecacheResource( "particle", "particles/rebuild/spell/eldwurm_soul_slyrak/ambient/effect_kid/invoker_kid_forge_spirit_ambient.vpcf", context )
end


modifier_Primary_Eldwurm_soul_Indrak= class({})

function modifier_Primary_Eldwurm_soul_Indrak:IsDebuff()			return false end
function modifier_Primary_Eldwurm_soul_Indrak:IsHidden() 			return true end
function modifier_Primary_Eldwurm_soul_Indrak:IsPurgable() 		return false end
function modifier_Primary_Eldwurm_soul_Indrak:IsPurgeException() 	return false end


function modifier_Primary_Eldwurm_soul_Indrak:OnSummonUnit(keys)
	if IsServer() then
		local unit = keys.target
		if self:GetParent():PassivesDisabled() then
			return
		end
		unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_Primary_Eldwurm_soul_Indrak_effect", {})
		local particle_cast_fx = ParticleManager:CreateParticle("particles/rebuild/spell/static_field_aoe/lighting_aoe.vpcf", PATTACH_WORLDORIGIN , unit)
		local pos = unit:GetAbsOrigin()
		ParticleManager:SetParticleControl(particle_cast_fx, 0, pos)
		ParticleManager:SetParticleControl(particle_cast_fx, 2,Vector(200,0,0))  
		ParticleManager:ReleaseParticleIndex(particle_cast_fx)

		unit:EmitSound("Hero_Zuus.StaticField")

	end
end












modifier_Primary_Eldwurm_soul_Indrak_effect = advanced_modifier({})

function modifier_Primary_Eldwurm_soul_Indrak_effect:IsDebuff() return false end
function modifier_Primary_Eldwurm_soul_Indrak_effect:IsHidden() return false end
function modifier_Primary_Eldwurm_soul_Indrak_effect:IsPurgable() return false end
function modifier_Primary_Eldwurm_soul_Indrak_effect:IsPurgeException() return false end
-- function modifier_Primary_Eldwurm_soul_Indrak_effect:GetTexture() return "soul_of_aethrak" end
function modifier_Primary_Eldwurm_soul_Indrak_effect:OnCreated(keys)
	local ability = self:GetAbility()
	self.bonus = ability:GetSpecialValueFor("bonus_attack_speed")

end


function modifier_Primary_Eldwurm_soul_Indrak_effect:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_TOOLTIP,
		
		

	}
end
function modifier_Primary_Eldwurm_soul_Indrak_effect:OnTooltip()
	return self:Advanced_GetModifierAttackSpeedPercentage()
end

-- advanced_modifier
function modifier_Primary_Eldwurm_soul_Indrak_effect:Advanced_GetModifierAttackSpeedPercentage()	return self.bonus end


function modifier_Primary_Eldwurm_soul_Indrak_effect:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,
    }

	return funcs

end
