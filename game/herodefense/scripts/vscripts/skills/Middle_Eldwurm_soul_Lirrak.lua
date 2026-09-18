
Middle_Eldwurm_soul_Lirrak = class({})


LinkLuaModifier("modifier_Middle_Eldwurm_soul_Lirrak", "skills/Middle_Eldwurm_soul_Lirrak", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_Eldwurm_soul_Lirrak_effect", "skills/Middle_Eldwurm_soul_Lirrak", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_Eldwurm_soul_Lirrak_effect2", "skills/Middle_Eldwurm_soul_Lirrak", LUA_MODIFIER_MOTION_NONE)
-- require('internal/timers')   --计时器功能

function Middle_Eldwurm_soul_Lirrak:GetIntrinsicModifierName() return "modifier_Middle_Eldwurm_soul_Lirrak" end
function Middle_Eldwurm_soul_Lirrak:IsHiddenWhenStolen() 		return false end
function Middle_Eldwurm_soul_Lirrak:IsRefreshable() 			return true  end

function Middle_Eldwurm_soul_Lirrak:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/monkey_king/arcana/water/mk_arcana_spring_cast_ring_outer_pnt.vpcf", context )
	-- PrecacheResource( "particle", "particles/rebuild/spell/eldwurm_soul_slyrak/ambient/effect_kid/invoker_kid_forge_spirit_ambient.vpcf", context )
end


modifier_Middle_Eldwurm_soul_Lirrak= class({})

function modifier_Middle_Eldwurm_soul_Lirrak:IsDebuff()			return false end
function modifier_Middle_Eldwurm_soul_Lirrak:IsHidden() 			return true end
function modifier_Middle_Eldwurm_soul_Lirrak:IsPurgable() 		return false end
function modifier_Middle_Eldwurm_soul_Lirrak:IsPurgeException() 	return false end


function modifier_Middle_Eldwurm_soul_Lirrak:OnSummonUnit(keys)
	if IsServer() then
		local unit = keys.target
		if self:GetParent():PassivesDisabled() then
			return
		end
		local ability = self:GetAbility()
		-- local stack = RandomInt(ability:GetSpecialValueFor("bonus_damage_min"), ability:GetSpecialValueFor("bonus_damage_max"))
		unit:AddNewModifier(self:GetCaster(), ability, "modifier_Middle_Eldwurm_soul_Lirrak_effect", {})


			local particle_cast_fx = ParticleManager:CreateParticle("particles/econ/items/monkey_king/arcana/water/mk_arcana_spring_cast_ring_outer_pnt.vpcf", PATTACH_WORLDORIGIN , unit)
			local pos = unit:GetAbsOrigin()
			ParticleManager:SetParticleControl(particle_cast_fx, 0, pos)
			-- ParticleManager:SetParticleControlForward(particle_cast_fx, 2,unit:GetForwardVector())  --方向
			-- ParticleManager:SetParticleControl(particle_cast_fx, 1, Vector(50,0,0))
			-- ParticleManager:SetParticleControl(particle_cast_fx, 3, pos)
			ParticleManager:ReleaseParticleIndex(particle_cast_fx)
			unit:EmitSound("Hero_NagaSiren.Riptide.Cast")
		-- end
	end
end











modifier_Middle_Eldwurm_soul_Lirrak_effect = advanced_modifier({})

function modifier_Middle_Eldwurm_soul_Lirrak_effect:IsDebuff() return false end
function modifier_Middle_Eldwurm_soul_Lirrak_effect:IsHidden() return false end
function modifier_Middle_Eldwurm_soul_Lirrak_effect:IsPurgable() return false end
function modifier_Middle_Eldwurm_soul_Lirrak_effect:IsPurgeException() return false end
-- function modifier_Middle_Eldwurm_soul_Lirrak_effect:GetTexture() return "soul_of_aethrak" end
function modifier_Middle_Eldwurm_soul_Lirrak_effect:OnCreated(keys)
	local ability = self:GetAbility()
	self.bonus_health_regen = ability:GetSpecialValueFor("bonus_health_regen")
	self.bonus_attack_range = ability:GetSpecialValueFor("bonus_attack_range")

	if IsServer() then
		
		-- self:StartIntervalThink(0.1)
	end
end
function modifier_Middle_Eldwurm_soul_Lirrak_effect:OnDestroy()
	if IsServer() then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_Middle_Eldwurm_soul_Lirrak_effect2", {})

		
	end
end


function modifier_Middle_Eldwurm_soul_Lirrak_effect:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP, 
	}
end


function modifier_Middle_Eldwurm_soul_Lirrak_effect:AdvancedGetModifierConstantHealthRegen()	

	return self.bonus_health_regen
end

function modifier_Middle_Eldwurm_soul_Lirrak_effect:Advanced_GetModifierAttackRangeBonusPercentage()	
	return self.bonus_attack_range
end

function modifier_Middle_Eldwurm_soul_Lirrak_effect:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 2 + 1
	if self._tooltip == 1 then
		return  self:AdvancedGetModifierConstantHealthRegen()
	elseif self._tooltip == 2 then
		return  self:Advanced_GetModifierAttackRangeBonusPercentage()
	end

end

function modifier_Middle_Eldwurm_soul_Lirrak_effect:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		advanced_MODIFIER_PROPERTY_ATTACK_RANGE_BONUS_PERCENTAGE

    }
end


modifier_Middle_Eldwurm_soul_Lirrak_effect2 = advanced_modifier({})

function modifier_Middle_Eldwurm_soul_Lirrak_effect2:IsDebuff()			return false end
function modifier_Middle_Eldwurm_soul_Lirrak_effect2:IsHidden() 			return false end
function modifier_Middle_Eldwurm_soul_Lirrak_effect2:IsPurgable() 		    return false end
function modifier_Middle_Eldwurm_soul_Lirrak_effect2:IsPurgeException() return false end
function modifier_Middle_Eldwurm_soul_Lirrak_effect2:RemoveOnDeath() return false end


function modifier_Middle_Eldwurm_soul_Lirrak_effect2:OnCreated(keys)
	if IsServer() then
		local bonus = 4
		self:SetStackCount(bonus)
	
	end
end

function modifier_Middle_Eldwurm_soul_Lirrak_effect2:OnRefresh(keys)
	if IsServer() then
		local bonus = 4
		self:SetStackCount(math.min(bonus+self:GetStackCount(),50))
	
	end
end



function modifier_Middle_Eldwurm_soul_Lirrak_effect2:DeclareFunctions()
	return {



		MODIFIER_PROPERTY_TOOLTIP,      

	
		

	}
end


function modifier_Middle_Eldwurm_soul_Lirrak_effect2:OnTooltip()	

	return self:GetStackCount()
end


function modifier_Middle_Eldwurm_soul_Lirrak_effect2:OnSummonUnit(keys)
	if IsServer() then
		self:SetDuration(0.03, false)
	end
end


-- advanced_modifier
function modifier_Middle_Eldwurm_soul_Lirrak_effect2:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_SummonTime_Intensity,
    }
end
function modifier_Middle_Eldwurm_soul_Lirrak_effect2:Advanced_GetModifier_SummonTime_Intensity(keys)
	return self:GetStackCount()
end

