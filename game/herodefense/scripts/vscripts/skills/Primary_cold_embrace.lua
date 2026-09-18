Primary_cold_embrace = class({})

LinkLuaModifier("modifier_Primary_cold_embrace_buff", "skills/Primary_cold_embrace", LUA_MODIFIER_MOTION_NONE)
function Primary_cold_embrace:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local duration = self:GetSpecialValueFor("duration")
	target:AddNewModifier(caster, self, "modifier_Primary_cold_embrace_buff", {duration = duration})
	caster:EmitSound("Hero_Winter_Wyvern.ColdEmbrace")
	target:EmitSound("Hero_Winter_Wyvern.ColdEmbrace.Cast")
end


function Primary_cold_embrace:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_winter_wyvern/wyvern_cold_embrace_buff.vpcf", context )
end




modifier_Primary_cold_embrace_buff = advanced_modifier({})

function modifier_Primary_cold_embrace_buff:IsDebuff() return false end
function modifier_Primary_cold_embrace_buff:IsHidden() return false end
function modifier_Primary_cold_embrace_buff:IsPurgable() return false end
function modifier_Primary_cold_embrace_buff:IsPurgeException() return false end
-- function modifier_Primary_cold_embrace_buff:GetEffectName() return "particles/units/heroes/hero_oracle/oracle_fatesedict.vpcf" end
-- function modifier_Primary_cold_embrace_buff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_Primary_cold_embrace_buff:OnCreated(keys)
	if IsServer() then
		local parent = self:GetParent()
		self.nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_winter_wyvern/wyvern_cold_embrace_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
		self:AddParticle( self.nFXIndex, false, false, -1, true, false )

		self.interval = 0.25
		self:StartIntervalThink(self.interval)
		self.block = self:GetAbility():GetSpecialValueFor("bonus_block")*self:GetCaster():GetIntellect(false)

	end
end
function modifier_Primary_cold_embrace_buff:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.nFXIndex, false)
		ParticleManager:ReleaseParticleIndex(self.nFXIndex)
	end
end


-- function modifier_Primary_cold_embrace_buff:DeclareFunctions()
-- 	return {
-- 		-- MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,         --魔法抗性
-- 		-- MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK,
-- 	}
-- end
function modifier_Primary_cold_embrace_buff:OnIntervalThink()
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	local parent = self:GetParent()
	local health = (ability:GetSpecialValueFor("base_heal")+ability:GetSpecialValueFor("bonus_heal")*parent:GetMaxHealth()*0.01)*self.interval
	local healing = HealWithGain(health,caster,parent,ability)
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, parent, healing, nil)
end


-- function modifier_Primary_cold_embrace_buff:GetModifierMagicalResistanceBonus() return 100 end


-- function modifier_Primary_cold_embrace_buff:GetModifierPhysical_ConstantBlock(keys)
-- 	return math.min(keys.damage,self.block) 
-- end

function modifier_Primary_cold_embrace_buff:CheckState()
	local state = {
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_FROZEN] = true,
		[MODIFIER_STATE_SILENCED] = true,

	}
	return state

end

function modifier_Primary_cold_embrace_buff:ADDeclareFunctions()
	return {
		MODIFIER_SPECIAL_CALCULATE_TOTAL_CONSTANT_BLOCK_HIGHT_LEVEL= {nil, self:GetParent()},
	}
end
function modifier_Primary_cold_embrace_buff:AdvancedGetModifierTotal_ConstantBlock_HightLevel(keys)
	if IsClient() then
		return 0
	end
	if keys.block_disabled then
        return 0 
    end
	if keys.damage_type~=DAMAGE_TYPE_PHYSICAL  then
		return 0
	end
	return math.min(keys.damage,self.block) 

end





-- modifier_Primary_cold_embrace_debuff = class({})

-- function modifier_Primary_cold_embrace_debuff:IsDebuff() return true end
-- function modifier_Primary_cold_embrace_debuff:IsHidden() return false end
-- function modifier_Primary_cold_embrace_debuff:IsPurgable() return true end

-- function modifier_Primary_cold_embrace_debuff:CheckState()
-- 	local state = {
-- 		[MODIFIER_STATE_DISARMED] = true
-- 	}

-- 	return state
-- end