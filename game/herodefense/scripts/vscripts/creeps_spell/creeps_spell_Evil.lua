creeps_spell_Evil = class({})

LinkLuaModifier("modifier_creeps_spell_Evil", "creeps_spell/creeps_spell_Evil", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Evil_debuff", "creeps_spell/creeps_spell_Evil", LUA_MODIFIER_MOTION_NONE)

function creeps_spell_Evil:IsHiddenWhenStolen() 		return false end
function creeps_spell_Evil:IsRefreshable() 			return true end
function creeps_spell_Evil:IsStealable() 				return true end
function creeps_spell_Evil:IsNetherWardStealable()		return true end
function creeps_spell_Evil:GetIntrinsicModifierName() return "modifier_creeps_spell_Evil" end


modifier_creeps_spell_Evil = class({})

function modifier_creeps_spell_Evil:IsDebuff()			return false end
function modifier_creeps_spell_Evil:IsHidden() 			return true end
function modifier_creeps_spell_Evil:IsPurgable() 		    return false end
function modifier_creeps_spell_Evil:IsPurgeException() 	return false end
function modifier_creeps_spell_Evil:RemoveOnDeath()       return false end

function modifier_creeps_spell_Evil:DeclareFunctions()
    return 
    {MODIFIER_EVENT_ON_DEATH ,} 
end

function modifier_creeps_spell_Evil:OnDeath(keys)
    if not IsServer() then
        return
    end

    if keys.unit == self:GetParent() then
        if not keys.attacker then
            return
        end
        keys.attacker:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_creeps_spell_Evil_debuff", {duration = 12})

    end
   
end



modifier_creeps_spell_Evil_debuff = advanced_modifier({})

function modifier_creeps_spell_Evil_debuff:IsDebuff()			return true end
function modifier_creeps_spell_Evil_debuff:IsHidden() 			return false end
function modifier_creeps_spell_Evil_debuff:IsPurgable() 			return true end
function modifier_creeps_spell_Evil_debuff:IsPurgeException() 	return true end
function modifier_creeps_spell_Evil_debuff:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE} end
function modifier_creeps_spell_Evil_debuff:GetModifierMoveSpeedBonus_Percentage() 
    return self.move_slow
end
function modifier_creeps_spell_Evil_debuff:Advanced_GetModifierIncomingDamage_Percentage()
    return self.damage_increase
end
--GetTexture(  )
function modifier_creeps_spell_Evil_debuff:GetTexture()
    return "bane_enfeeble"
end

function modifier_creeps_spell_Evil_debuff:OnCreated(table)
    self.move_slow = -self:GetAbility():GetSpecialValueFor("move_slow")
    self.damage_increase = self:GetAbility():GetSpecialValueFor("damage_increase")
end


function modifier_creeps_spell_Evil_debuff:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end
