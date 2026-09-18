item_hd_satanic = class({})

LinkLuaModifier("modifier_item_hd_satanic", "items/item_hd_satanic", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_satanic_disarm", "items/item_hd_satanic", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_satanic_active_lifesteal", "items/item_hd_satanic", LUA_MODIFIER_MOTION_NONE)

-- Item Passive
function item_hd_satanic:GetIntrinsicModifierName()
	return "modifier_item_hd_satanic"
end


function item_hd_satanic:OnSpellStart()
	local duration = self:GetSpecialValueFor("duration")
	local target = self:GetCursorTarget()
	local caster = self:GetCaster()
	local ModifierStatusGain = caster:GetModifierDurationGainIndex(1)
	EmitSoundOn("DOTA_Item.Satanic.Activate", self:GetCaster())
	caster:Purge(false, true, false, false, false)
	caster:AddNewModifier(caster, self, "modifier_item_hd_satanic_active_lifesteal", {duration = duration*ModifierStatusGain})
end

modifier_item_hd_satanic = advanced_modifier({})

function modifier_item_hd_satanic:IsDebuff() return false end
function modifier_item_hd_satanic:IsHidden() return true end
function modifier_item_hd_satanic:IsPurgable() return false end


function modifier_item_hd_satanic:OnCreated(keys)
    self.ability = self:GetAbility()
	self.bonus_str = self.ability:GetSpecialValueFor("bonus_str")
	self.bonus_life_steal = self.ability:GetSpecialValueFor("bonus_life_steal")
	self.bonus_active_life_steal = self.ability:GetSpecialValueFor("active_life_steal")
	self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")
end



function modifier_item_hd_satanic:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,           --力量
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,            --攻击力

	}
end


function modifier_item_hd_satanic:GetModifierBonusStats_Strength()
	return self.bonus_str
end
function modifier_item_hd_satanic:GetModifierPreAttack_BonusDamage() return self.bonus_damage end
function modifier_item_hd_satanic:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_LifeSteal_AttackDamage,
    }
end

function modifier_item_hd_satanic:Advanced_GetModifier_LifeSteal_AttackDamage(keys)
	if self:GetParent():HasModifier("modifier_item_hd_satanic_active_lifesteal") then
		return self.bonus_active_life_steal
	end
	return self.bonus_life_steal
end




modifier_item_hd_satanic_active_lifesteal=class({})

function modifier_item_hd_satanic_active_lifesteal:GetTexture()return "item_satanic" end
function modifier_item_hd_satanic_active_lifesteal:IsDebuff() 			return false  end
function modifier_item_hd_satanic_active_lifesteal:IsHidden() 			return false  end
function modifier_item_hd_satanic_active_lifesteal:IsPurgable() 			 return false end
function modifier_item_hd_satanic_active_lifesteal:IsPurgeException() 	    return true end
function modifier_item_hd_satanic_active_lifesteal:GetEffectAttachType() 	    return PATTACH_CENTER_FOLLOW end
function modifier_item_hd_satanic_active_lifesteal:GetEffectName() 	  return "particles/generic_gameplay/rune_bounty_glow.vpcf" end
function modifier_item_hd_satanic_active_lifesteal:RemoveOnDeath()    return true end