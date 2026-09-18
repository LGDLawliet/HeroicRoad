chaotic_era_buffskill_3 = class({})

LinkLuaModifier("modifier_chaotic_era_buffskill_3", "modifier/chaotic_era_creep_buff/chaotic_era_buffskill_3", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_era_buffskill_3_debuff", "modifier/chaotic_era_creep_buff/chaotic_era_buffskill_3", LUA_MODIFIER_MOTION_NONE)
function chaotic_era_buffskill_3:GetIntrinsicModifierName()
	return "modifier_chaotic_era_buffskill_3"
end

modifier_chaotic_era_buffskill_3 = advanced_modifier({})

function modifier_chaotic_era_buffskill_3:IsDebuff() return false end
function modifier_chaotic_era_buffskill_3:IsHidden() return false end
function modifier_chaotic_era_buffskill_3:IsPurgable() return false end
function modifier_chaotic_era_buffskill_3:GetEffectName() return "particles/econ/items/silencer/silencer_ti6/silencer_last_word_status_ti6_ring_edge.vpcf" end
function modifier_chaotic_era_buffskill_3:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_chaotic_era_buffskill_3:OnCreated(keys)
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
	self.mana = self.ability:GetSpecialValueFor("mana")*0.01
	self.move_down = self.ability:GetSpecialValueFor("move_down")
    self.duration = self.ability:GetSpecialValueFor("duration")
end

function modifier_chaotic_era_buffskill_3:ADDeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE = {nil,self:GetParent()}
	}
	return funcs
end

function modifier_chaotic_era_buffskill_3:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP,
        MODIFIER_EVENT_ON_TAKEDAMAGE_KILLCREDIT
	}
	return funcs
end

function modifier_chaotic_era_buffskill_3:OnTakeDamageKillCredit(keys) 
    if not IsServer() then return end
    local unit = keys.target
    local attacker = keys.attacker
    if not unit:IsAlive() or unit ~= self.parent then return end
    if not IsEnemy(attacker, unit) then return end
    if not self.ability:IsCooldownReady() then return end
    if bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) == DOTA_DAMAGE_FLAG_HPLOSS then return end
	if bit.band( keys.damage_flags, DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT ) == DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT then return end
    if bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then return end
    if IsDotDamage(keys) then return end

    if not unit:PassivesDisabled() then
        local mana = attacker:GetMana()*self.mana
        attacker:Script_ReduceMana(mana, self.ability)
        SendOverheadEventMessage(attacker, OVERHEAD_ALERT_MANA_LOSS, attacker, mana, nil)
    end
	if not attacker:IsMagicImmune() then
        local ModifierStatusNegativeGain = unit:GetModifierStatusNegativeGainIndex(0.5)
        local StatusResistance = attacker:GetHDStatusResistanceIndex(0.5)*ModifierStatusNegativeGain
        local duration_f = self.duration*StatusResistance
        attacker:EmitSound("Hero_Silencer.LastWord.Target")
        attacker:AddNewModifier(unit, self.ability, "modifier_chaotic_era_buffskill_3_debuff", {duration = duration_f, move_down = self.move_down})
    end
    self.ability:UseResources(true, true, true, true)
end

-- function modifier_chaotic_era_buffskill_3:OnTooltip(keys)
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



modifier_chaotic_era_buffskill_3_debuff = advanced_modifier({})

function modifier_chaotic_era_buffskill_3_debuff:IsDebuff() return true end
function modifier_chaotic_era_buffskill_3_debuff:IsHidden() return false end
function modifier_chaotic_era_buffskill_3_debuff:IsPurgable() return true end
function modifier_chaotic_era_buffskill_3_debuff:GetEffectName() return "particles/econ/items/silencer/silencer_ti6/silencer_last_word_status_ti6_ring_edge.vpcf" end
function modifier_chaotic_era_buffskill_3_debuff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_chaotic_era_buffskill_3_debuff:OnCreated(keys)
    self.ability = self:GetAbility()
    if IsServer() then
        self.move_down = keys.move_down
        self:SetStackCount(self.move_down)
    end
end
function modifier_chaotic_era_buffskill_3_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return funcs
end

function modifier_chaotic_era_buffskill_3_debuff:GetModifierMoveSpeedBonus_Percentage() 
    if not self:GetAbility() then self:Destroy() return end
    return -self:GetStackCount()
end