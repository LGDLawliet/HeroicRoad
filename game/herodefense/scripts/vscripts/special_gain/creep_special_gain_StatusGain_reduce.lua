creep_special_gain_StatusGain_reduce = class({})
-- LinkLuaModifier("modifier_creep_special_gain_StatusGain_reduce_arua", "skills/creep_special_gain_StatusGain_reduce", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_creep_special_gain_StatusGain_reduce_arua_effect", "skills/creep_special_gain_StatusGain_reduce", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creep_special_gain_StatusGain_reduce", "special_gain/creep_special_gain_StatusGain_reduce", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creep_special_gain_StatusGain_reduce_active", "special_gain/creep_special_gain_StatusGain_reduce", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
-- require('internal/timers')   --计时器功能
function creep_special_gain_StatusGain_reduce:GetIntrinsicModifierName()
	return "modifier_creep_special_gain_StatusGain_reduce"
end


modifier_creep_special_gain_StatusGain_reduce = class({})




function modifier_creep_special_gain_StatusGain_reduce:IsHidden() 
	return false
end
function modifier_creep_special_gain_StatusGain_reduce:IsPurgable() return false end
function modifier_creep_special_gain_StatusGain_reduce:IsDebuff() return false end
function modifier_creep_special_gain_StatusGain_reduce:GetEffectName() return "particles/econ/items/silencer/silencer_ti10_immortal_shield/silencer_ti10_immortal_curse_debuff_body.vpcf" end
function modifier_creep_special_gain_StatusGain_reduce:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_creep_special_gain_StatusGain_reduce:DeclareFunctions()
	return {

		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end

function modifier_creep_special_gain_StatusGain_reduce:OnAttackLanded(keys)
    if not IsServer() then
        return
    end
	local ability = self:GetAbility()

    if keys.attacker == self:GetParent() and ability:IsCooldownReady() and not keys.target:IsMagicImmune() then
		if keys.attacker:PassivesDisabled() then
			return
		end
		ability:StartCooldown(25)
		local ModifierStatusNegativeGain = keys.attacker:GetModifierStatusNegativeGainIndex(1)
		local StatusResistance = keys.target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
		keys.target:AddNewModifier(keys.attacker, ability, "modifier_creep_special_gain_StatusGain_reduce_active", {duration = 7*StatusResistance})
		keys.target:EmitSound("DOTA_Item.SilverEdge.Target")



    end
   
end




modifier_creep_special_gain_StatusGain_reduce_active = advanced_modifier({})

function modifier_creep_special_gain_StatusGain_reduce_active:IsDebuff() return true end
function modifier_creep_special_gain_StatusGain_reduce_active:IsHidden() return false end
function modifier_creep_special_gain_StatusGain_reduce_active:IsPurgable() return false end
function modifier_creep_special_gain_StatusGain_reduce_active:IsPurgeException() return true end
-- function modifier_creep_special_gain_StatusGain_reduce_active:GetEffectName()	return "particles/dire_fx/dire_tower_decay.vpcf" end
-- function modifier_creep_special_gain_StatusGain_reduce_active:GetEffectAttachType()	return PATTACH_ABSORIGIN_FOLLOW end
function modifier_creep_special_gain_StatusGain_reduce_active:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_creep_special_gain_StatusGain_reduce_active:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_DurationGain,
    }
end
function modifier_creep_special_gain_StatusGain_reduce_active:Advanced_GetModifier_DurationGain(keys)
	return -35
end


