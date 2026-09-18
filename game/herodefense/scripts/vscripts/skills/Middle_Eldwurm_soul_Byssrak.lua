
Middle_Eldwurm_soul_Byssrak = class({})


LinkLuaModifier("modifier_Middle_Eldwurm_soul_Byssrak", "skills/Middle_Eldwurm_soul_Byssrak", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_Eldwurm_soul_Byssrak_effect", "skills/Middle_Eldwurm_soul_Byssrak", LUA_MODIFIER_MOTION_NONE)


function Middle_Eldwurm_soul_Byssrak:GetIntrinsicModifierName() return "modifier_Middle_Eldwurm_soul_Byssrak" end
function Middle_Eldwurm_soul_Byssrak:IsHiddenWhenStolen() 		return false end
function Middle_Eldwurm_soul_Byssrak:IsRefreshable() 			return true  end
function Middle_Eldwurm_soul_Byssrak:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_void_spirit/dissimilate/void_spirit_dissimilate_exit.vpcf", context )
	-- particles/units/heroes/hero_void_spirit/dissimilate/void_spirit_dissimilate_dmg.vpcf
end




modifier_Middle_Eldwurm_soul_Byssrak= class({})

function modifier_Middle_Eldwurm_soul_Byssrak:IsDebuff()			return false end
function modifier_Middle_Eldwurm_soul_Byssrak:IsHidden() 			return true end
function modifier_Middle_Eldwurm_soul_Byssrak:IsPurgable() 		return false end
function modifier_Middle_Eldwurm_soul_Byssrak:IsPurgeException() 	return false end


function modifier_Middle_Eldwurm_soul_Byssrak:OnSummonUnit(keys)
	if IsServer() then
		local unit = keys.target
		if self:GetParent():PassivesDisabled() then
			return
		end
		
		unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_Middle_Eldwurm_soul_Byssrak_effect", {})
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



modifier_Middle_Eldwurm_soul_Byssrak_effect = advanced_modifier({})

function modifier_Middle_Eldwurm_soul_Byssrak_effect:IsDebuff() return false end
function modifier_Middle_Eldwurm_soul_Byssrak_effect:IsHidden() return false end
function modifier_Middle_Eldwurm_soul_Byssrak_effect:IsPurgable() return false end
function modifier_Middle_Eldwurm_soul_Byssrak_effect:IsPurgeException() return false end
-- function modifier_Middle_Eldwurm_soul_Byssrak_effect:GetTexture() return "soul_of_aethrak" end
function modifier_Middle_Eldwurm_soul_Byssrak_effect:OnCreated(keys)
	local ability = self:GetAbility()
	self.bonus_damage = ability:GetSpecialValueFor("bonus_damage")
	self.attack_speed_reduce = -ability:GetSpecialValueFor("attack_speed_reduce")
	if IsServer() then
		self.bonus_totaldamage = 0
		-- self.trigger = false
		-- self:SetHasCustomTransmitterData(true)
		self:StartIntervalThink(0.5)
	end
end

function modifier_Middle_Eldwurm_soul_Byssrak_effect:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,         
		MODIFIER_PROPERTY_TOOLTIP
		-- MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
	}
end
function modifier_Middle_Eldwurm_soul_Byssrak_effect:OnIntervalThink()

	self:SetStackCount(math.min(self:GetStackCount()+10,500))
	
	
end


function modifier_Middle_Eldwurm_soul_Byssrak_effect:GetModifierDamageOutgoing_Percentage()	return self.bonus_damage end
function modifier_Middle_Eldwurm_soul_Byssrak_effect:Advanced_GetModifierAttackSpeedPercentage()	return self.attack_speed_reduce end

function modifier_Middle_Eldwurm_soul_Byssrak_effect:OnTooltip()

	self._tooltip = (self._tooltip or 0) % 2 + 1
	if self._tooltip == 1 then
		return self:Advanced_GetModifierAttackSpeedPercentage()	
	elseif self._tooltip == 2 then
		return self:Advanced_GetModifierTotalDamageOutgoing_Percentage()
	end
end

-- advanced_modifier
function modifier_Middle_Eldwurm_soul_Byssrak_effect:ADDeclareFunctions()
	local funcs = {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,
    }

	return funcs

end


function modifier_Middle_Eldwurm_soul_Byssrak_effect:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
	if keys.damage_category~= DOTA_DAMAGE_CATEGORY_ATTACK then	return 0 end
	local damage = self:GetStackCount()
	if IsServer() then
		self:SetStackCount(0)
		return damage
	end	
	return damage
end
