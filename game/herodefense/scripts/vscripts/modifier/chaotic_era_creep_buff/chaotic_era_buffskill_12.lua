chaotic_era_buffskill_12 = class({})

LinkLuaModifier("modifier_chaotic_era_buffskill_12", "modifier/chaotic_era_creep_buff/chaotic_era_buffskill_12", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_era_buffskill_12_buff", "modifier/chaotic_era_creep_buff/chaotic_era_buffskill_12", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_era_buffskill_12_debuff", "modifier/chaotic_era_creep_buff/chaotic_era_buffskill_12", LUA_MODIFIER_MOTION_NONE)
function chaotic_era_buffskill_12:GetIntrinsicModifierName()
	return "modifier_chaotic_era_buffskill_12"
end

modifier_chaotic_era_buffskill_12 = advanced_modifier({})

function modifier_chaotic_era_buffskill_12:IsDebuff() return false end
function modifier_chaotic_era_buffskill_12:IsHidden() return false end
function modifier_chaotic_era_buffskill_12:IsPurgable() return false end

function modifier_chaotic_era_buffskill_12:OnCreated(keys)
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
	self.line = self.ability:GetSpecialValueFor("line")
    self.duration = self.ability:GetSpecialValueFor("duration")
    if IsServer() then
        self:StartIntervalThink(0.3)
    end
end

function modifier_chaotic_era_buffskill_12:OnIntervalThink()
    if self.parent:IsAlive() then
		if self.ability:IsCooldownReady() and self.parent:GetHealthPercent() <= self.line then
			local Gain = self.parent:GetModifierDurationGainIndex(0.7)
            local duration = self.duration*Gain
			if self:GetCaster():PassivesDisabled() then
				duration = duration*0.7
			end
			if self:GetCaster():IsSilenced() then
				duration = duration*0.5
			end

			self.parent:AddNewModifier(self.parent, self.ability, "modifier_chaotic_era_buffskill_12_buff", {duration = duration})
			self.ability:UseResources(true, true, true, true)
		end
    end
end


modifier_chaotic_era_buffskill_12_buff = advanced_modifier({})

function modifier_chaotic_era_buffskill_12_buff:IsDebuff()			return false end
function modifier_chaotic_era_buffskill_12_buff:IsHidden() 			return false end
function modifier_chaotic_era_buffskill_12_buff:IsPurgable() 		return true end
function modifier_chaotic_era_buffskill_12_buff:GetEffectName() return "particles/units/heroes/hero_pugna/pugna_decrepify.vpcf" end
function modifier_chaotic_era_buffskill_12_buff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_chaotic_era_buffskill_12_buff:CheckState() return {[MODIFIER_STATE_ATTACK_IMMUNE] = true,} end
function modifier_chaotic_era_buffskill_12_buff:OnCreated()
    self.ability = self:GetAbility()
    self.down = self.ability:GetSpecialValueFor("down")
end

function modifier_chaotic_era_buffskill_12_buff:DeclareFunctions() 
	return {
	    MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	} 
end

function modifier_chaotic_era_buffskill_12_buff:ADDeclareFunctions() 
	return {
        advanced_MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
	} 
end

function modifier_chaotic_era_buffskill_12_buff:GetAbsoluteNoDamagePhysical() return 1 end
function modifier_chaotic_era_buffskill_12_buff:GetModifierMagicalResistanceBonus() return -self.down end
function modifier_chaotic_era_buffskill_12_buff:Advanced_GetModifierDamageOutgoing_Percentage() return -self.down end


