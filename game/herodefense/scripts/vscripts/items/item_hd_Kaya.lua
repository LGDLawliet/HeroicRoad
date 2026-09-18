item_hd_Kaya = class({})

LinkLuaModifier("modifier_item_hd_Kaya_active", "items/item_hd_Kaya", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_Kaya", "items/item_hd_Kaya", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
function item_hd_Kaya:GetIntrinsicModifierName()
	return "modifier_item_hd_Kaya"
end



modifier_item_hd_Kaya = advanced_modifier({})

function modifier_item_hd_Kaya:IsDebuff() return false end
function modifier_item_hd_Kaya:IsHidden() return true end
function modifier_item_hd_Kaya:IsPurgable() return false end



function modifier_item_hd_Kaya:OnCreated(keys)
    local ability = self:GetAbility()
	self.bonus_int = ability:GetSpecialValueFor("bonus_int")
	self.duration = ability:GetSpecialValueFor("duration")
	self.bonus_spell_amp = ability:GetSpecialValueFor("bonus_spell_amp")
	self.bonus_heal_amp = ability:GetSpecialValueFor("bonus_heal_amp")
	self.bonus_cast_speed = ability:GetSpecialValueFor("bonus_cast_speed")
end


function modifier_item_hd_Kaya:Advanced_GetModifierBonusStats_Intellect()
	return self.bonus_int
end
function modifier_item_hd_Kaya:Advanced_GetModifierSpellAmplifyBonus()
    return self.bonus_spell_amp
end
function modifier_item_hd_Kaya:Advanced_GetModifierHealAMP_Percentage(keys)
	return self.bonus_heal_amp 
end
function modifier_item_hd_Kaya:Advanced_GetModifier_CastPoint(keys)
	return self.bonus_cast_speed 
end

-- advanced_modifier
function modifier_item_hd_Kaya:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        advanced_MODIFIER_PROPERTY_HEAL_AMP_BONUS_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_CastPoint,
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
		MODIFIER_EVENT_ON_DEATH = {self:GetParent(),nil}
    }
end

function modifier_item_hd_Kaya:OnDeath(keys)
	if IsServer() then
		keys.attacker:AddNewModifier(keys.attacker, self:GetAbility(), "modifier_item_hd_Kaya_active", {duration = self.duration})
	end
end


modifier_item_hd_Kaya_active = advanced_modifier({})

function modifier_item_hd_Kaya_active:IsDebuff() return false end
function modifier_item_hd_Kaya_active:IsHidden() return true end
function modifier_item_hd_Kaya_active:IsPurgable() return false end



function modifier_item_hd_Kaya_active:OnCreated(keys)
    local ability = self:GetAbility()
	self.bonus_Mana_regeneration = (self:GetParent():GetMaxMana()-self:GetParent():GetMana()) *ability:GetSpecialValueFor("active")*0.01--已损失魔法值的5% by车佬
	self:StartIntervalThink(0.5)
end
function modifier_item_hd_Kaya_active:OnRefresh(keys)
    local ability = self:GetAbility()
	self.bonus_Mana_regeneration = (self:GetParent():GetMaxMana()-self:GetParent():GetMana()) *ability:GetSpecialValueFor("active")*0.01--已损失魔法值的5% by车佬
end
function modifier_item_hd_Kaya_active:OnIntervalThink()
	print(self.bonus_Mana_regeneration)
end

function modifier_item_hd_Kaya_active:AdvancedGetModifierConstantManaRegen()
	
	return self.bonus_Mana_regeneration
end

-- advanced_modifier
function modifier_item_hd_Kaya_active:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
    }
end


