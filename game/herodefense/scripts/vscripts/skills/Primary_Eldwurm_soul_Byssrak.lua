
Primary_Eldwurm_soul_Byssrak = class({})


LinkLuaModifier("modifier_Primary_Eldwurm_soul_Byssrak", "skills/Primary_Eldwurm_soul_Byssrak", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Primary_Eldwurm_soul_Byssrak_effect", "skills/Primary_Eldwurm_soul_Byssrak", LUA_MODIFIER_MOTION_NONE)


function Primary_Eldwurm_soul_Byssrak:GetIntrinsicModifierName() return "modifier_Primary_Eldwurm_soul_Byssrak" end
function Primary_Eldwurm_soul_Byssrak:IsHiddenWhenStolen() 		return false end
function Primary_Eldwurm_soul_Byssrak:IsRefreshable() 			return true  end
function Primary_Eldwurm_soul_Byssrak:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_void_spirit/dissimilate/void_spirit_dissimilate_exit.vpcf", context )
end




modifier_Primary_Eldwurm_soul_Byssrak= class({})

function modifier_Primary_Eldwurm_soul_Byssrak:IsDebuff()			return false end
function modifier_Primary_Eldwurm_soul_Byssrak:IsHidden() 			return true end
function modifier_Primary_Eldwurm_soul_Byssrak:IsPurgable() 		return false end
function modifier_Primary_Eldwurm_soul_Byssrak:IsPurgeException() 	return false end


function modifier_Primary_Eldwurm_soul_Byssrak:OnSummonUnit(keys)
	if IsServer() then
		local unit = keys.target
		if self:GetParent():PassivesDisabled() then
			return
		end
		
		unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_Primary_Eldwurm_soul_Byssrak_effect", {})
		local particle_cast_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/dissimilate/void_spirit_dissimilate_exit.vpcf", PATTACH_WORLDORIGIN , unit)
		local pos = unit:GetOrigin() + Vector(0,0,128)
		ParticleManager:SetParticleControl(particle_cast_fx, 0, pos)
		ParticleManager:ReleaseParticleIndex(particle_cast_fx)
		for i = 1, 5, 1 do
			local particle_cast_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/dissimilate/void_spirit_dissimilate_exit.vpcf", PATTACH_WORLDORIGIN , unit)
			local new_pos = pos + Vector(RandomInt(-100, 100),RandomInt(-100, 100),RandomInt(-50, 200))
			ParticleManager:SetParticleControl(particle_cast_fx, 0, new_pos)
			ParticleManager:ReleaseParticleIndex(particle_cast_fx)
		end
		-- Timers:CreateTimer(0.5, function()
		-- 	ParticleManager:DestroyParticle(particle_cast_fx, false)
		-- 	ParticleManager:ReleaseParticleIndex(particle_cast_fx)
		-- end)

		unit:EmitSound("Hero_Enigma.Malefice")
	end
end



modifier_Primary_Eldwurm_soul_Byssrak_effect = advanced_modifier({})

function modifier_Primary_Eldwurm_soul_Byssrak_effect:IsDebuff() return false end
function modifier_Primary_Eldwurm_soul_Byssrak_effect:IsHidden() return false end
function modifier_Primary_Eldwurm_soul_Byssrak_effect:IsPurgable() return false end
function modifier_Primary_Eldwurm_soul_Byssrak_effect:IsPurgeException() return false end
-- function modifier_Primary_Eldwurm_soul_Byssrak_effect:GetTexture() return "soul_of_aethrak" end
function modifier_Primary_Eldwurm_soul_Byssrak_effect:OnCreated(keys)
	local ability = self:GetAbility()
	self.bonus_damage = ability:GetSpecialValueFor("bonus_damage")
	self.attack_speed_reduce = -ability:GetSpecialValueFor("attack_speed_reduce")
end

function modifier_Primary_Eldwurm_soul_Byssrak_effect:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,      

	}
end


function modifier_Primary_Eldwurm_soul_Byssrak_effect:GetModifierDamageOutgoing_Percentage()	return self.bonus_damage end
function modifier_Primary_Eldwurm_soul_Byssrak_effect:Advanced_GetModifierAttackSpeedPercentage()	return self.attack_speed_reduce end

function modifier_Primary_Eldwurm_soul_Byssrak_effect:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE
    }
end
