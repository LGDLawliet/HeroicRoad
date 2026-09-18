modifier_hd_endless_tired = advanced_modifier({})

function modifier_hd_endless_tired:IsDebuff() return true end
function modifier_hd_endless_tired:IsHidden() return self:GetStackCount() < 0 end
function modifier_hd_endless_tired:IsPurgable() return false end
function modifier_hd_endless_tired:IsPurgeException() return false end
function modifier_hd_endless_tired:RemoveOnDeath() return false end
function modifier_hd_endless_tired:DestroyOnExpire() return false end
function modifier_hd_endless_tired:GetTexture() return "axe_battle_hunger" end
function modifier_hd_endless_tired:OnCreated()
    --开始显示出来/开始扣属性的时间点
    self.tired_time = 300

    --每秒丢失的全属性
    self.lost_atb = 2
    self.lost_cd = 0.5
    self.lost_outgoing = 0.5
    self.lost_incoming = 0.5
    self.lost_profic = 0.5
    self:SetStackCount(-1)
end

function modifier_hd_endless_tired:OnIntervalThink()
    if not IsServer() then return end
    if self:GetRemainingTime() <= self.tired_time then
        self:SetStackCount(self:GetStackCount() +1)
        if self:GetStackCount() >= self.tired_time then
            self:GetParent():ForceKill(true)
        end
    end
end

function modifier_hd_endless_tired:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,

        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_TALENT_EFFECT_GAIN,
        advanced_MODIFIER_PROPERTY_COOLDOWN_REDUCTION,
	}
end

function modifier_hd_endless_tired:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_TOOLTIP,
	}
end

function modifier_hd_endless_tired:Advanced_GetModifierBonusStats_Strength()
	return -self:GetStackCount() *self.lost_atb
end
function modifier_hd_endless_tired:Advanced_GetModifierBonusStats_Agility()
    return -self:GetStackCount() *self.lost_atb
end
function modifier_hd_endless_tired:Advanced_GetModifierBonusStats_Intellect()
	return -self:GetStackCount() *self.lost_atb
end
function modifier_hd_endless_tired:Advanced_GetModifierTotalDamageOutgoing_Percentage()
	return -self:GetStackCount() *self.lost_outgoing
end
function modifier_hd_endless_tired:Advanced_GetModifierIncomingDamage_Percentage()
	return self:GetStackCount() *self.lost_incoming
end
function modifier_hd_endless_tired:Advanced_GetModifier_TalentEffectGain()
	return -self:GetStackCount() *self.lost_profic
end
function modifier_hd_endless_tired:Advanced_GetModifierCooldownReduction()
	return -self:GetStackCount() *self.lost_cd
end

function modifier_hd_endless_tired:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 5 + 1
    if self._tooltip == 1 then
        return self:Advanced_GetModifierBonusStats_Strength()
    end
    if self._tooltip == 2 then
        return self:Advanced_GetModifierTotalDamageOutgoing_Percentage()
    end
    if self._tooltip == 3 then
        return self:Advanced_GetModifierIncomingDamage_Percentage()
    end
    if self._tooltip == 4 then
        return self:Advanced_GetModifier_TalentEffectGain()
    end
    if self._tooltip == 5 then
        return self:Advanced_GetModifierCooldownReduction() 
    end
end