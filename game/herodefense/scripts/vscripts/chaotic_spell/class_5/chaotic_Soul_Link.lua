
chaotic_Soul_Link = class({})


LinkLuaModifier("modifier_chaotic_Soul_Link", "chaotic_spell/class_5/chaotic_Soul_Link", LUA_MODIFIER_MOTION_NONE)

function chaotic_Soul_Link:GetIntrinsicModifierName() return "modifier_chaotic_Soul_Link" end


-------------------------------------------
modifier_chaotic_Soul_Link= advanced_modifier({})

function modifier_chaotic_Soul_Link:IsDebuff()			return false end
function modifier_chaotic_Soul_Link:IsHidden() 			return false end
function modifier_chaotic_Soul_Link:IsPurgable() 		return false end
function modifier_chaotic_Soul_Link:IsPurgeException() 	return false end
function modifier_chaotic_Soul_Link:RemoveOnDeath()			return false end

function modifier_chaotic_Soul_Link:CheckState()
    if self:GetStackCount() >= self.line then
        return{[MODIFIER_STATE_LOW_ATTACK_PRIORITY]=true}
    end
    return
end

function modifier_chaotic_Soul_Link:OnCreated(keys)
    self.ability = self:GetAbility()
    self.line = self.ability:GetSpecialValueFor("awaken_line")
    self.attack_down = self.ability:GetSpecialValueFor("attack_down")
    self.spell_down = self.ability:GetSpecialValueFor("spell_down")
    self.summon = self.ability:GetSpecialValueFor("summon")
    self.summon_lvl = self.ability:GetSpecialValueFor("summon_lvl")
    self.mana_regen = self.ability:GetSpecialValueFor("mana_regen")*0.01
end

function modifier_chaotic_Soul_Link:OnSummonUnit(keys)
    self:SetStackCount(math.min(self:GetStackCount()+1, self.line))
	if IsServer() then
		local unit = keys.target
        
		local particle_cast_fx = ParticleManager:CreateParticle("particles/econ/items/riki/riki_immortal_ti6/riki_immortal_ti6_blinkstrike_gold_end.vpcf", PATTACH_ABSORIGIN, unit)
		local pos = unit:GetAbsOrigin()
		ParticleManager:SetParticleControl(particle_cast_fx, 1, pos)
		ParticleManager:SetParticleControlForward(particle_cast_fx, 1,unit:GetForwardVector())  --方向
		ParticleManager:SetParticleControl(particle_cast_fx, 2, pos)
		ParticleManager:SetParticleControl(particle_cast_fx, 3, pos)
		ParticleManager:ReleaseParticleIndex(particle_cast_fx)
	end
end

function modifier_chaotic_Soul_Link:OnSummonUnitFinished(keys)
	if IsServer() then
	end
end

function modifier_chaotic_Soul_Link:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_Summon_Intensity,
        advanced_MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS_PERCENTAGE_MUL,
        advanced_MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,

    }
end

function modifier_chaotic_Soul_Link:Advanced_GetModifierDamageOutgoing_Percentage(keys)
	return -self.attack_down
end
function modifier_chaotic_Soul_Link:Advanced_GetModifierSpellAmplifyBonusPercentageMUL(keys)
	return -self.spell_down
end

function modifier_chaotic_Soul_Link:Advanced_GetModifier_Summon_Intensity(keys)
    local summon = self.summon
    if self:GetStackCount() >= self.line then
        summon = self.summon + self.summon_lvl*self:GetParent():GetLevel()
    end
	return summon
end

function modifier_chaotic_Soul_Link:AdvancedGetModifierConstantManaRegen(keys)
    local mana_regen = 0
    if self:GetStackCount() >= self.line then
        mana_regen = self.mana_regen*self:GetParent():GetMaxMana()
    end
	return mana_regen
end



