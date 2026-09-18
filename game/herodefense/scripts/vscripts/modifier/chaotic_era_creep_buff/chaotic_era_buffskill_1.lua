chaotic_era_buffskill_1 = class({})

LinkLuaModifier("modifier_chaotic_era_buffskill_1", "modifier/chaotic_era_creep_buff/chaotic_era_buffskill_1", LUA_MODIFIER_MOTION_NONE)

function chaotic_era_buffskill_1:GetIntrinsicModifierName()
	return "modifier_chaotic_era_buffskill_1"
end

modifier_chaotic_era_buffskill_fix = advanced_modifier({})

function modifier_chaotic_era_buffskill_fix:IsDebuff() return false end
function modifier_chaotic_era_buffskill_fix:IsHidden() return true end
function modifier_chaotic_era_buffskill_fix:IsPurgable() return false end
function modifier_chaotic_era_buffskill_fix:OnCreated()
	if IsServer() then
		self:StartIntervalThink(3)
		self:SetStackCount(0)
	end
end
function modifier_chaotic_era_buffskill_fix:CheckState()
	if self:GetStackCount() == 1 then
		return{
			[MODIFIER_STATE_STUNNED] = true,
			[MODIFIER_STATE_SILENCED] = true,
			[MODIFIER_STATE_DISARMED] = true,
			[MODIFIER_STATE_ROOTED] = true,
		}
	end
end
function modifier_chaotic_era_buffskill_fix:OnIntervalThink()
	local parent = self:GetParent()
	if (parent and not parent:IsNull()) and (parent:GetHealth() <= 0 ) then
		self:SetStackCount(1)
		parent:Kill(nil,nil)
		-- if parent and not parent:IsNull() and parent:IsAlive() then
		-- 	parent:ModifyHealth(0, nil, true, 0)
		-- end
	end
end
modifier_chaotic_era_buffskill_1 = advanced_modifier({})

function modifier_chaotic_era_buffskill_1:IsDebuff() return false end
function modifier_chaotic_era_buffskill_1:IsHidden() return false end
function modifier_chaotic_era_buffskill_1:IsPurgable() return false end
function modifier_chaotic_era_buffskill_1:GetEffectName() return "particles/units/heroes/hero_medusa/medusa_mana_shield.vpcf" end

function modifier_chaotic_era_buffskill_1:OnCreated(keys)
    self.ability = self:GetAbility()
	self.break_incoming = self.ability:GetSpecialValueFor("break_incoming")
	self.start_incoming = self.ability:GetSpecialValueFor("start_incoming")
    self.each = self.ability:GetSpecialValueFor("each")
    self:SetStackCount(self.start_incoming)
end

function modifier_chaotic_era_buffskill_1:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_TAKEDAMAGE = {nil,self:GetParent()}
	}
	return funcs
end

function modifier_chaotic_era_buffskill_1:Advanced_GetModifierIncomingDamage_Percentage() 
    if self:GetStackCount() > 0 then
        return -self:GetStackCount()*self.each
    end
    return self.break_incoming
end

function modifier_chaotic_era_buffskill_1:OnTakeDamage(keys)
	if not IsServer() then
		return
	end
	local unit = keys.unit
    if unit ~= self:GetParent() then return end
	
	if bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) == DOTA_DAMAGE_FLAG_HPLOSS then return end
	if bit.band( keys.damage_flags, DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT ) == DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT then return end

    if unit:PassivesDisabled() then
        self:SetStackCount(math.max(self:GetStackCount()-self.each*9, 0))
    end
	self:SetStackCount(math.max(self:GetStackCount()-self.each, 0))

end

function modifier_chaotic_era_buffskill_1:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP
	}
	return funcs
end

function modifier_chaotic_era_buffskill_1:OnTooltip(keys)
	self._tooltip = (self._tooltip or 0) % 2 + 1
	if self._tooltip == 1 then
		return  self:GetStackCount()*self.each
	end
	if self._tooltip == 2 then
        if self:GetStackCount() <= 0 then
		    return  self.break_incoming
        end
        return 0
	end
end



