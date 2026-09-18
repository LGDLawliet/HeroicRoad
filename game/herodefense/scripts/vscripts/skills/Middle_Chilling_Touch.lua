Middle_Chilling_Touch = class({})

LinkLuaModifier("modifier_Middle_Chilling_Touch_attack", "skills/Middle_Chilling_Touch", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_Chilling_Touch_debuff", "skills/Middle_Chilling_Touch", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_Chilling_Touch_slow", "skills/Middle_Chilling_Touch", LUA_MODIFIER_MOTION_NONE)

function Middle_Chilling_Touch:IsHiddenWhenStolen()         return false end
function Middle_Chilling_Touch:IsStealable()                return true end
function Middle_Chilling_Touch:IsNetherWardStealable()      return true end
function Middle_Chilling_Touch:GetIntrinsicModifierName()   return "modifier_Middle_Chilling_Touch_attack" end

modifier_Middle_Chilling_Touch_attack = advanced_modifier({})

function modifier_Middle_Chilling_Touch_attack:IsPassive()          return true end
function modifier_Middle_Chilling_Touch_attack:IsBuff()				return true end
function modifier_Middle_Chilling_Touch_attack:IsPurgable()     	return false end
function modifier_Middle_Chilling_Touch_attack:IsPurgeException() 	return false end
function modifier_Middle_Chilling_Touch_attack:IsHidden()			return false end
function modifier_Middle_Chilling_Touch_attack:GetModifierProjectileName()
    if IsServer() and self:GetParent():IsApplyModifier() then
        return "particles/units/heroes/hero_ancient_apparition/ancient_apparition_chilling_touch_projectile.vpcf" 
    end	
end 

function modifier_Middle_Chilling_Touch_attack:DeclareFunctions()
	return {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_PROPERTY_PROJECTILE_NAME,
	}
end

function modifier_Middle_Chilling_Touch_attack:Advanced_GetModifierAttackRangeBonus()		
    if self:GetParent():IsRangedAttacker() then
      return self:GetAbility():GetSpecialValueFor("bonus_attack_range")
    else 
        return 0
    end
end



function modifier_Middle_Chilling_Touch_attack:OnAttackLanded(keys)
    if not IsServer() then
        return
	end  
	
	if not self:GetParent():IsAlive() or self:GetParent():IsIllusion() then
		return
    end
    if keys.target:IsMagicImmune() then
        return
    end
    if not self:GetParent():IsApplyModifier()  then
        return
    end
    local target = keys.target
    if keys.attacker == self:GetParent() then 
        local damage = self:GetAbility():GetSpecialValueFor("basic_damage")+ self:GetParent():GetIntellect(false) * self:GetAbility():GetSpecialValueFor("intelligence_index")
		local damagetable= {
            victim = target,
            attacker = keys.attacker,
            damage = damage,
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability = self:GetAbility(),
            hd_flags = HD_DAMAGE_FLAG_ICE_DAMAGE
            }
        target:ApplyMergeDamage(damagetable)
        EmitSoundOn("Hero_Ancient_Apparition.ChillingTouch.Target", target)
        local ModifierStatusNegativeGain = keys.attacker:GetModifierStatusNegativeGainIndex(1)
        local StatusResistance = target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
        target:AddNewModifier(keys.attacker, self:GetAbility(), "modifier_Middle_Chilling_Touch_slow", {duration=self:GetAbility():GetSpecialValueFor("duration")*StatusResistance}) 

        self:SetStackCount(self:GetStackCount()+1)
        if self:GetStackCount() > 3 then
            self:SetStackCount(0)
			target:AddNewModifier(keys.attacker, self:GetAbility(), "modifier_Middle_Chilling_Touch_debuff", {duration=1.5}) 
		end

	end 
end  

function modifier_Middle_Chilling_Touch_attack:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
	
    }
end



modifier_Middle_Chilling_Touch_debuff = class({})
function modifier_Middle_Chilling_Touch_debuff:IsDebuff()				return true  end
function modifier_Middle_Chilling_Touch_debuff:IsPurgable() 			return true end
function modifier_Middle_Chilling_Touch_debuff:IsPurgeException()     return true end
function modifier_Middle_Chilling_Touch_debuff:IsHidden()				return false end
function modifier_Middle_Chilling_Touch_debuff:DeclareFunctions()return {MODIFIER_PROPERTY_DISABLE_HEALING,}end
function modifier_Middle_Chilling_Touch_debuff:GetDisableHealing()	return 1 end



modifier_Middle_Chilling_Touch_slow = class({})
function modifier_Middle_Chilling_Touch_slow:IsDebuff()				return true  end
function modifier_Middle_Chilling_Touch_slow:IsPurgable() 			return true end
function modifier_Middle_Chilling_Touch_slow:IsPurgeException() 	    return true end
function modifier_Middle_Chilling_Touch_slow:IsHidden()				return false end
function modifier_Middle_Chilling_Touch_slow:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT} end
function modifier_Middle_Chilling_Touch_slow:GetModifierMoveSpeedBonus_Constant() return self.slow end

function modifier_Middle_Chilling_Touch_slow:OnCreated()
    self.slow = - self:GetAbility():GetSpecialValueFor("move_slow")
end

function modifier_Middle_Chilling_Touch_slow:OnRefresh()
    self.slow = - self:GetAbility():GetSpecialValueFor("move_slow")
end
