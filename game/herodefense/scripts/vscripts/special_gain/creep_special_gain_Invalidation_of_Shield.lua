creep_special_gain_Invalidation_of_Shield = class({})
-- LinkLuaModifier("modifier_creep_special_gain_Invalidation_of_Shield_arua", "skills/creep_special_gain_Invalidation_of_Shield", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_creep_special_gain_Invalidation_of_Shield_arua_effect", "skills/creep_special_gain_Invalidation_of_Shield", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creep_special_gain_Invalidation_of_Shield", "special_gain/creep_special_gain_Invalidation_of_Shield", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creep_special_gain_Invalidation_of_Shield_active", "special_gain/creep_special_gain_Invalidation_of_Shield", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
-- require('internal/timers')   --计时器功能
function creep_special_gain_Invalidation_of_Shield:GetIntrinsicModifierName()
	return "modifier_creep_special_gain_Invalidation_of_Shield"
end


modifier_creep_special_gain_Invalidation_of_Shield = class({})




function modifier_creep_special_gain_Invalidation_of_Shield:IsHidden() 
	return false
end
function modifier_creep_special_gain_Invalidation_of_Shield:IsPurgable() return false end
function modifier_creep_special_gain_Invalidation_of_Shield:IsDebuff() return false end
function modifier_creep_special_gain_Invalidation_of_Shield:GetEffectName() return "particles/rebuild/spell_gain/invoker_deafening_blast_disarm_ti6_debuff.vpcf" end
function modifier_creep_special_gain_Invalidation_of_Shield:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_creep_special_gain_Invalidation_of_Shield:DeclareFunctions()
	return {

		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end



function modifier_creep_special_gain_Invalidation_of_Shield:OnAttackLanded(keys)
    if not IsServer() then
        return
	end  
	
	if self:GetParent():IsIllusion() then
		return
    end
    -- if keys.target:IsMagicImmune() then
    --     return
    -- end



    if keys.attacker == self:GetParent() then 
		local ModifierStatusNegativeGain = keys.attacker:GetModifierStatusNegativeGainIndex(1)
		local StatusResistance = keys.target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
		keys.target:AddNewModifier(keys.attacker, self:GetAbility(), "modifier_creep_special_gain_Invalidation_of_Shield_active", {duration=math.max(0.01,0.3*StatusResistance)}) 


	end 
end  



modifier_creep_special_gain_Invalidation_of_Shield_active = advanced_modifier({})

function modifier_creep_special_gain_Invalidation_of_Shield_active:IsDebuff() return true end
function modifier_creep_special_gain_Invalidation_of_Shield_active:IsHidden() return false end
function modifier_creep_special_gain_Invalidation_of_Shield_active:IsPurgable() return false end
function modifier_creep_special_gain_Invalidation_of_Shield_active:IsPurgeException() return true end
-- function modifier_creep_special_gain_Invalidation_of_Shield_active:GetEffectName()	return "particles/dire_fx/dire_tower_decay.vpcf" end
-- function modifier_creep_special_gain_Invalidation_of_Shield_active:GetEffectAttachType()	return PATTACH_ABSORIGIN_FOLLOW end
-- function modifier_creep_special_gain_Invalidation_of_Shield_active:CheckState()
-- 	local state = {
-- 		[MODIFIER_STATE_BLOCK_DISABLED]=true,

-- 	}
	

-- 	return state
-- end

function modifier_creep_special_gain_Invalidation_of_Shield_active:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_TOTALBLOCK_CONSTANT_DISABLE,
	}
end


function modifier_creep_special_gain_Invalidation_of_Shield_active:Advanced_GetModifierTotalBlockConstantDisable(keys)
    return 1
end


