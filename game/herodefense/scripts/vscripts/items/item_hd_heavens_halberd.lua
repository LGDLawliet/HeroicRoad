item_hd_heavens_halberd = class({})

LinkLuaModifier("modifier_item_hd_heavens_halberd", "items/item_hd_heavens_halberd", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_heavens_halberd_disarm", "items/item_hd_heavens_halberd", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
function item_hd_heavens_halberd:GetIntrinsicModifierName()
	return "modifier_item_hd_heavens_halberd"
end


function item_hd_heavens_halberd:OnSpellStart()
	local duration = self:GetSpecialValueFor("duration")
	local target = self:GetCursorTarget()
	local caster = self:GetCaster()
	local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
	local StatusResistance = target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
	target:EmitSound("DOTA_Item.HeavensHalberd.Activate")
	target:AddNewModifier(caster, self, "modifier_item_hd_heavens_halberd_disarm", {duration = duration*StatusResistance})
end

modifier_item_hd_heavens_halberd = advanced_modifier({})

function modifier_item_hd_heavens_halberd:IsDebuff() return false end
function modifier_item_hd_heavens_halberd:IsHidden() return true end
function modifier_item_hd_heavens_halberd:IsPurgable() return false end
-- function modifier_item_hd_heavens_halberd:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end



function modifier_item_hd_heavens_halberd:OnCreated(keys)
    local ability = self:GetAbility()
    local caster = self:GetCaster()
    local parent = self:GetParent()
	self.bonus_str = ability:GetSpecialValueFor("bonus_str")
	self.bonus_status_resistance = ability:GetSpecialValueFor("bonus_status_resistance")
	self.bonus_regeneration_amplification = ability:GetSpecialValueFor("bonus_regeneration_amplification")
	self.bonus_evasion = ability:GetSpecialValueFor("bonus_evasion")

end



function modifier_item_hd_heavens_halberd:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_EVASION_CONSTANT,
	}
end

function modifier_item_hd_heavens_halberd:GetModifierBonusStats_Strength()
	return self.bonus_str
end


function modifier_item_hd_heavens_halberd:AdvancedGetModifierConstantHealthRegenAmpPercentage()
	return self.bonus_regeneration_amplification
end


-- function modifier_item_hd_heavens_halberd:GetModifierMPRegenAmplify_Percentage()
-- 	return self.bonus_Mana_regeneration
-- end

function modifier_item_hd_heavens_halberd:GetModifierEvasion_Constant() return self.bonus_evasion end

-- advanced_modifier
function modifier_item_hd_heavens_halberd:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_LifeSteal_Intensity,
		advanced_MODIFIER_PROPERTY_HEALTH_REGEN_AMP_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_StatusResistance
    }
end
function modifier_item_hd_heavens_halberd:Advanced_GetModifier_LifeSteal_Intensity(keys)
	return self.bonus_regeneration_amplification
end


function modifier_item_hd_heavens_halberd:Advanced_GetModifier_StatusResistance(keys)
	return self.bonus_status_resistance
end



modifier_item_hd_heavens_halberd_disarm=class({})

function modifier_item_hd_heavens_halberd_disarm:GetTexture()return "item_heavens_halberd" end
function modifier_item_hd_heavens_halberd_disarm:IsDebuff() 			return true  end
function modifier_item_hd_heavens_halberd_disarm:IsHidden() 			return false  end
function modifier_item_hd_heavens_halberd_disarm:IsPurgable() 			 return false end
function modifier_item_hd_heavens_halberd_disarm:IsPurgeException() 	    return true end
function modifier_item_hd_heavens_halberd_disarm:GetEffectAttachType() 	    return PATTACH_OVERHEAD_FOLLOW end
function modifier_item_hd_heavens_halberd_disarm:GetEffectName() 	  return "particles/generic_gameplay/generic_disarm.vpcf" end
function modifier_item_hd_heavens_halberd_disarm:RemoveOnDeath()    return true end
function modifier_item_hd_heavens_halberd_disarm:CheckState()
    return 
    {
        [MODIFIER_STATE_DISARMED] = true,
    }
end