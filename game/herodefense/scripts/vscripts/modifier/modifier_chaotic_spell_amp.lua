modifier_chaotic_spell_amp = advanced_modifier({})

function modifier_chaotic_spell_amp:IsDebuff() return false end
function modifier_chaotic_spell_amp:IsHidden() return true end
function modifier_chaotic_spell_amp:IsPurgable() return false end
function modifier_chaotic_spell_amp:RemoveOnDeath() return false end
function modifier_chaotic_spell_amp:OnCreated()
	self.parent = self:GetParent()
    self.index = 7
	self.spell_amp = 0
    if IsServer() then
        self:StartIntervalThink(1)
        self:SetStackCount(self.spell_amp)
        self:OnIntervalThink()
    end
end

function modifier_chaotic_spell_amp:OnIntervalThink()
    if self.parent:GetPrimaryAttribute() == DOTA_ATTRIBUTE_INTELLECT then
        self.index = 9
    else
        self.index = 7
    end
	self.spell_amp = self.parent:HDGetPrimaryStatValue()*self.index
    self:SetStackCount(self.spell_amp)
end

function modifier_chaotic_spell_amp:ADDeclareFunctions()
	local funcs = {
        advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS
	}
	return funcs
end

function modifier_chaotic_spell_amp:Advanced_GetModifierSpellAmplifyBonus()
	return self:GetStackCount()*0.01
end