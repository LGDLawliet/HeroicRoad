chaotic_era_buffskill_11 = class({})

LinkLuaModifier("modifier_chaotic_era_buffskill_11", "modifier/chaotic_era_creep_buff/chaotic_era_buffskill_11", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_era_buffskill_11_buff", "modifier/chaotic_era_creep_buff/chaotic_era_buffskill_11", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_era_buffskill_11_debuff", "modifier/chaotic_era_creep_buff/chaotic_era_buffskill_11", LUA_MODIFIER_MOTION_NONE)
function chaotic_era_buffskill_11:GetIntrinsicModifierName()
	return "modifier_chaotic_era_buffskill_11"
end

modifier_chaotic_era_buffskill_11 = advanced_modifier({})

function modifier_chaotic_era_buffskill_11:IsDebuff() return false end
function modifier_chaotic_era_buffskill_11:IsHidden() return false end
function modifier_chaotic_era_buffskill_11:IsPurgable() return false end
function modifier_chaotic_era_buffskill_11:GetEffectName() return "particles/rebuild/particle_effect/attach_92/effect_lv2_buff_beams.vpcf" end
function modifier_chaotic_era_buffskill_11:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_chaotic_era_buffskill_11:OnCreated(keys)
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
	self.incoming = self.ability:GetSpecialValueFor("incoming")
	self.outgoing = self.ability:GetSpecialValueFor("outgoing")
    self.duration = self.ability:GetSpecialValueFor("duration")
end

function modifier_chaotic_era_buffskill_11:ADDeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_DEATH = {nil,self:GetParent()},
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
	return funcs
end

function modifier_chaotic_era_buffskill_11:Advanced_GetModifierIncomingDamage_Percentage() 
    return -self.incoming
end

function modifier_chaotic_era_buffskill_11:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul() 
    return self.outgoing
end

function modifier_chaotic_era_buffskill_11:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP,
	}
	return funcs
end

function modifier_chaotic_era_buffskill_11:OnDeath(keys)
	if not IsServer() then return end
    local attacker = keys.attacker
    local unit = keys.unit
    if unit ~= self.parent then return end
    if attacker and attacker:IsAlive() then
       attacker:AddNewModifier(unit, self.ability, "modifier_chaotic_era_buffskill_11_buff", {duration = self.duration, incoming = self.incoming, outgoing = self.outgoing}) 
    end
end
-- function modifier_chaotic_era_buffskill_11:OnTooltip(keys)
-- 	self._tooltip = (self._tooltip or 0) % 1 + 1
-- 	if self._tooltip == 1 then
--         if self.parent:PassivesDisabled() then
--             return 0
--         end
-- 		return  self:GetStackCount()
-- 	end
-- 	-- if self._tooltip == 2 then
--     --     if self:GetStackCount() <= 0 then
-- 	-- 	    return  self.break_incoming
--     --     end
--     --     return 0
-- 	-- end
-- end



modifier_chaotic_era_buffskill_11_buff = advanced_modifier({})

function modifier_chaotic_era_buffskill_11_buff:IsDebuff() return false end
function modifier_chaotic_era_buffskill_11_buff:IsHidden() return false end
function modifier_chaotic_era_buffskill_11_buff:IsPurgable() return false end
function modifier_chaotic_era_buffskill_11_buff:GetTexture() return "roshan_bash" end
function modifier_chaotic_era_buffskill_11_buff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_chaotic_era_buffskill_11_buff:GetEffectName() return  "particles/rebuild/particle_effect/attach_92/effect_lv2_buff_beams.vpcf" end
function modifier_chaotic_era_buffskill_11_buff:OnCreated(keys)
    self.ability = self:GetAbility()
    if IsServer() then
        self.incoming = keys.incoming
        self.outgoing = keys.outgoing
        self:SetStackCount(self.incoming)
    end
end
function modifier_chaotic_era_buffskill_11_buff:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
	return funcs
end

function modifier_chaotic_era_buffskill_11_buff:Advanced_GetModifierIncomingDamage_Percentage() 
    return -self:GetStackCount()
end
function modifier_chaotic_era_buffskill_11_buff:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul() 
    return self.outgoing
end

modifier_chaotic_era_buffskill_11_debuff = advanced_modifier({})

function modifier_chaotic_era_buffskill_11_debuff:IsDebuff() return false end
function modifier_chaotic_era_buffskill_11_debuff:IsHidden() return true end
function modifier_chaotic_era_buffskill_11_debuff:IsPurgable() return false end
