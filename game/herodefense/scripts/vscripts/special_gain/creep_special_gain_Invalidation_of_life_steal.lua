creep_special_gain_Invalidation_of_life_steal = class({})
-- LinkLuaModifier("modifier_creep_special_gain_Invalidation_of_life_steal_arua", "skills/creep_special_gain_Invalidation_of_life_steal", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_creep_special_gain_Invalidation_of_life_steal_arua_effect", "skills/creep_special_gain_Invalidation_of_life_steal", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creep_special_gain_Invalidation_of_life_steal", "special_gain/creep_special_gain_Invalidation_of_life_steal", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creep_special_gain_Invalidation_of_life_steal_active", "special_gain/creep_special_gain_Invalidation_of_life_steal", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
-- require('internal/timers')   --计时器功能
function creep_special_gain_Invalidation_of_life_steal:GetIntrinsicModifierName()
	return "modifier_creep_special_gain_Invalidation_of_life_steal"
end


modifier_creep_special_gain_Invalidation_of_life_steal = class({})




function modifier_creep_special_gain_Invalidation_of_life_steal:IsHidden() 
	return false
end
function modifier_creep_special_gain_Invalidation_of_life_steal:IsPurgable() return false end
function modifier_creep_special_gain_Invalidation_of_life_steal:IsDebuff() return false end
function modifier_creep_special_gain_Invalidation_of_life_steal:GetEffectName() return "particles/rebuild/econ/items/invoker/invoker_ti6/invoker_deafening_blast_disarm_ti6_debuff.vpcf" end
function modifier_creep_special_gain_Invalidation_of_life_steal:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_creep_special_gain_Invalidation_of_life_steal:DeclareFunctions()
	return {

		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end



function modifier_creep_special_gain_Invalidation_of_life_steal:OnAttackLanded(keys)
    if not IsServer() then
        return
	end  
	
	if self:GetParent():IsIllusion() then
		return
    end
    if keys.target:IsMagicImmune() then
        return
    end



    if keys.attacker == self:GetParent() then 
		self:IncrementStackCount()
		if self:GetStackCount()>=4 then
			self:SetStackCount(0)
			local ModifierStatusNegativeGain = keys.attacker:GetModifierStatusNegativeGainIndex(1)
			local StatusResistance = keys.target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
			keys.target:AddNewModifier(keys.attacker, self:GetAbility(), "modifier_creep_special_gain_Invalidation_of_life_steal_active", {duration=1*StatusResistance}) 
	
		end


	end 
end  



modifier_creep_special_gain_Invalidation_of_life_steal_active = advanced_modifier({})

function modifier_creep_special_gain_Invalidation_of_life_steal_active:IsDebuff() return true end
function modifier_creep_special_gain_Invalidation_of_life_steal_active:IsHidden() return false end
function modifier_creep_special_gain_Invalidation_of_life_steal_active:IsPurgable() return false end
function modifier_creep_special_gain_Invalidation_of_life_steal_active:IsPurgeException() return true end
-- advanced_modifier
function modifier_creep_special_gain_Invalidation_of_life_steal_active:ADDeclareFunctions()
    return 
    {
        
		advanced_MODIFIER_PROPERTY_LifeSteal_Intensity
    }
end


function modifier_creep_special_gain_Invalidation_of_life_steal_active:Advanced_GetModifier_LifeSteal_Intensity(keys)
	return -1000
end


