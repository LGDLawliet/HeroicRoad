
Middle_Soul_Link = class({})


LinkLuaModifier("modifier_Middle_Soul_Link", "skills/Middle_Soul_Link", LUA_MODIFIER_MOTION_NONE)

function Middle_Soul_Link:GetIntrinsicModifierName() return "modifier_Middle_Soul_Link" end
function Middle_Soul_Link:IsHiddenWhenStolen() 		return false end
function Middle_Soul_Link:IsRefreshable() 			return true  end
function Middle_Soul_Link:IsStealable() 			return true  end
function Middle_Soul_Link:IsNetherWardStealable()	return true end



modifier_Middle_Soul_Link= advanced_modifier({})

function modifier_Middle_Soul_Link:IsDebuff()			return false end
function modifier_Middle_Soul_Link:IsHidden() 			return true end
function modifier_Middle_Soul_Link:IsPurgable() 		return false end
function modifier_Middle_Soul_Link:IsPurgeException() 	return false end

function modifier_Middle_Soul_Link:OnCreated(keys)
    self.ability = self:GetAbility()

    if IsServer() then
		self:StartIntervalThink(3)
	
	end
end




function modifier_Middle_Soul_Link:OnSummonUnit(keys)
	if IsServer() then
		local unit = keys.target
		

		if self:GetCaster():GetRandomEffect(25,INT_TYPE,1) >=RandomInt(1, 100) then
			self.bonus_trigger = true
			local particle_cast_fx = ParticleManager:CreateParticle("particles/econ/items/riki/riki_immortal_ti6/riki_immortal_ti6_blinkstrike_gold_end.vpcf", PATTACH_ABSORIGIN, unit)
			local pos = unit:GetAbsOrigin()
			ParticleManager:SetParticleControl(particle_cast_fx, 1, pos)
			ParticleManager:SetParticleControlForward(particle_cast_fx, 1,unit:GetForwardVector())  --方向
			ParticleManager:SetParticleControl(particle_cast_fx, 2, pos)
			ParticleManager:SetParticleControl(particle_cast_fx, 3, pos)
			ParticleManager:ReleaseParticleIndex(particle_cast_fx)
		end
	end
end


--归置
function modifier_Middle_Soul_Link:OnSummonUnitFinished(keys)
	if IsServer() then
		self.bonus_trigger = false
	end
end



-- advanced_modifier
function modifier_Middle_Soul_Link:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_Summon_Intensity,
    }
end
function modifier_Middle_Soul_Link:Advanced_GetModifier_Summon_Intensity(keys)
	if self.bonus_trigger then
		return self.ability:GetSpecialValueFor("bonus_summon_intensity")*1.5
	end
	return self.ability:GetSpecialValueFor("bonus_summon_intensity")
end

