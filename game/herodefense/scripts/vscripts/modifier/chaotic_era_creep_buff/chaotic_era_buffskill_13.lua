chaotic_era_buffskill_13 = class({})

LinkLuaModifier("modifier_chaotic_era_buffskill_13", "modifier/chaotic_era_creep_buff/chaotic_era_buffskill_13", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_era_buffskill_13_buff", "modifier/chaotic_era_creep_buff/chaotic_era_buffskill_13", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_era_buffskill_13_debuff", "modifier/chaotic_era_creep_buff/chaotic_era_buffskill_13", LUA_MODIFIER_MOTION_NONE)
function chaotic_era_buffskill_13:GetIntrinsicModifierName()
	return "modifier_chaotic_era_buffskill_13"
end

modifier_chaotic_era_buffskill_13 = advanced_modifier({})

function modifier_chaotic_era_buffskill_13:IsDebuff() return false end
function modifier_chaotic_era_buffskill_13:IsHidden() return false end
function modifier_chaotic_era_buffskill_13:IsPurgable() return false end

function modifier_chaotic_era_buffskill_13:OnCreated(keys)
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
	self.line = self.ability:GetSpecialValueFor("line")
    self.duration = self.ability:GetSpecialValueFor("duration")
    if IsServer() then
        self:StartIntervalThink(0.3)
    end
end

function modifier_chaotic_era_buffskill_13:OnIntervalThink()
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

			self.parent:AddNewModifier(self.parent, self.ability, "modifier_chaotic_era_buffskill_13_buff", {duration = duration})
			self.ability:UseResources(true, true, true, true)
		end
    end
end


modifier_chaotic_era_buffskill_13_buff = advanced_modifier({})

function modifier_chaotic_era_buffskill_13_buff:IsDebuff()			return false end
function modifier_chaotic_era_buffskill_13_buff:IsHidden() 			return false end
function modifier_chaotic_era_buffskill_13_buff:IsPurgable() 		return true end
function modifier_chaotic_era_buffskill_13_buff:GetEffectName() return "particles/status_fx/status_effect_life_stealer_rage.vpcf" end
function modifier_chaotic_era_buffskill_13_buff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_chaotic_era_buffskill_13_buff:CheckState() return {[MODIFIER_STATE_MAGIC_IMMUNE] = true,} end
function modifier_chaotic_era_buffskill_13_buff:OnCreated()
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.down = self.ability:GetSpecialValueFor("down")

    if IsServer() then
		self.nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_life_stealer/life_stealer_rage.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_attack1", self.parent:GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_attack2", self.parent:GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 2, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 3, self.parent, PATTACH_ABSORIGIN_FOLLOW, nil, self.parent:GetAbsOrigin(), false )
		self:AddParticle( self.nFXIndex, false, false, -1, false, false )
		EmitSoundOn("Hero_LifeStealer.Rage", self.parent)
	end
end

function modifier_chaotic_era_buffskill_13_buff:ADDeclareFunctions() 
	return {
        advanced_MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS_PERCENTAGE
	} 
end

function modifier_chaotic_era_buffskill_13_buff:DeclareFunctions() 
	return {
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
	} 
end

function modifier_chaotic_era_buffskill_13_buff:Advanced_GetModifierPhysicalArmorBonusPercentage() return -self.down end
function modifier_chaotic_era_buffskill_13_buff:Advanced_GetModifierDamageOutgoing_Percentage() return -self.down end
function modifier_chaotic_era_buffskill_13_buff:GetModifierMagicalResistanceBonus() return 10000 end

