creeps_spell_Biting = class({})

LinkLuaModifier("modifier_creeps_spell_Biting", "creeps_spell/creeps_spell_Biting", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Biting_debuff", "creeps_spell/creeps_spell_Biting", LUA_MODIFIER_MOTION_NONE)

function creeps_spell_Biting:IsHiddenWhenStolen() 		return false end
function creeps_spell_Biting:IsRefreshable() 			return true end
function creeps_spell_Biting:IsStealable() 				return true end
function creeps_spell_Biting:IsNetherWardStealable()		return true end
function creeps_spell_Biting:GetIntrinsicModifierName() return "modifier_creeps_spell_Biting" end



modifier_creeps_spell_Biting = class({})

function modifier_creeps_spell_Biting:IsDebuff()			return false end
function modifier_creeps_spell_Biting:IsHidden() 			return true end
function modifier_creeps_spell_Biting:IsPurgable() 		    return false end
function modifier_creeps_spell_Biting:IsPurgeException() 	return false end
function modifier_creeps_spell_Biting:RemoveOnDeath()       return false end





function modifier_creeps_spell_Biting:DeclareFunctions()
	return {MODIFIER_EVENT_ON_ATTACK_LANDED,}
end


function modifier_creeps_spell_Biting:OnAttackLanded(keys)

	if not IsServer() or keys.attacker ~= self:GetParent() then
		return
	end
    if self:GetParent():PassivesDisabled() then
        return
    end
	if not keys.target:IsMagicImmune() and  self:GetAbility():GetSpecialValueFor("chance") >= RandomInt(1, 100) then
        local ModifierStatusNegativeGain = self:GetParent():GetModifierStatusNegativeGainIndex(1)
        local StatusResistance = keys.target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
        keys.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_creeps_spell_Biting_debuff", {duration = self:GetAbility():GetSpecialValueFor("duration")*StatusResistance})
    end
end


modifier_creeps_spell_Biting_debuff = class({})

function modifier_creeps_spell_Biting_debuff:IsDebuff()			   return true end
function modifier_creeps_spell_Biting_debuff:IsHidden() 			return false end
function modifier_creeps_spell_Biting_debuff:IsPurgable() 		    return true end
function modifier_creeps_spell_Biting_debuff:IsPurgeException() 	return true end
function modifier_creeps_spell_Biting_debuff:RemoveOnDeath()       return false end

function modifier_creeps_spell_Biting_debuff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_creeps_spell_Biting_debuff:DeclareFunctions()   return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT} end
function modifier_creeps_spell_Biting_debuff:GetModifierMoveSpeedBonus_Percentage() 
        return self.move_slow
end
function modifier_creeps_spell_Biting_debuff:GetModifierAttackSpeedBonus_Constant() 
        return self.attack_slo
end

function modifier_creeps_spell_Biting_debuff:OnCreated(table)
    self.attack_slow = -self:GetAbility():GetSpecialValueFor("attack_slow")
    self.move_slow = -self:GetAbility():GetSpecialValueFor("move_slow")
    if not IsServer()   then
        return
    end
    self.damage = self:GetAbility():GetSpecialValueFor("damage")
    self:StartIntervalThink(1)
    local StatusResistance = 1 - self:GetParent():GetStatusResistance()
	self:SetDuration(self:GetRemainingTime()*StatusResistance,true)
end

function modifier_creeps_spell_Biting_debuff:OnIntervalThink()
    if not IsServer()   then
        return
    end
    local ability = self:GetAbility()
    if not ability or ability:IsNull() then
        return
    end

    local damageTable = {
        victim = self:GetParent(),
        attacker = ability:GetCaster(),
        damage = self:GetParent():GetHealth()*self.damage *0.01,
        damage_type = self:GetAbility():GetAbilityDamageType(),
        damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
        ability = ability, --Optional.
        }
     ApplyDamage(damageTable)
end

