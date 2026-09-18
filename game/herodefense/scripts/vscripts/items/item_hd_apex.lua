item_hd_apex = class({})

LinkLuaModifier("modifier_item_hd_apex", "items/item_hd_apex", LUA_MODIFIER_MOTION_NONE)


function item_hd_apex:GetIntrinsicModifierName()
	return "modifier_item_hd_apex"
end



modifier_item_hd_apex = advanced_modifier({})

function modifier_item_hd_apex:IsDebuff() return false end
function modifier_item_hd_apex:IsHidden() return true end
function modifier_item_hd_apex:IsPurgable() 		return false end
function modifier_item_hd_apex:IsPurgeException() 	return false end
function modifier_item_hd_apex:RemoveOnDeath()  return false end


function modifier_item_hd_apex:OnCreated(keys)
    self.ability = self:GetAbility()
    local parent = self:GetParent()
	self.bonus_str = self.ability:GetSpecialValueFor("bonus_str")
	self.bonus_agi = self.ability:GetSpecialValueFor("bonus_agi")
	self.bonus_int = self.ability:GetSpecialValueFor("bonus_int")
	self.cd_reduce = self.ability:GetSpecialValueFor("cd_reduce")
	self.posi_down = self.ability:GetSpecialValueFor("posi_down")
    if IsServer() then
		self:SetStackCount(parent:GetPrimaryAttribute())
		self:StartIntervalThink(0.1)
	end
end

function modifier_item_hd_apex:OnIntervalThink()
	if IsServer() then
		local overcharge = self:GetParent():FindAbilityByName("Primary_overcharge") or self:GetParent():FindAbilityByName("Middle_overcharge") or self:GetParent():FindAbilityByName("Advanced_overcharge")
		if overcharge and overcharge: IsCooldownReady() then
			overcharge:OnSpellStart()
			overcharge:UseResources(true, true, true, true)
		end		
	end
end

function modifier_item_hd_apex:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷
		advanced_MODIFIER_PROPERTY_DurationGain,
		advanced_MODIFIER_PROPERTY_COOLDOWN_REDUCTION,
	}
end
function modifier_item_hd_apex:Advanced_GetModifierCooldownReduction()	
	return self.cd_reduce
end
function modifier_item_hd_apex:Advanced_GetModifier_DurationGain()
	if self:GetParent():FindAbilityByName("Primary_overcharge") or self:GetParent():FindAbilityByName("Middle_overcharge") or self:GetParent():FindAbilityByName("Advanced_overcharge") then
		return -self.posi_down
	end
	return 0
end
function modifier_item_hd_apex:Advanced_GetModifierBonusStats_Strength()	
	if self:GetStackCount()==DOTA_ATTRIBUTE_ALL  then
		return self.bonus_str*0.45
	end
	return self:GetStackCount()==0 and self.bonus_str or 0 
end
function modifier_item_hd_apex:Advanced_GetModifierBonusStats_Intellect()	
	if self:GetStackCount()==DOTA_ATTRIBUTE_ALL  then
		return self.bonus_int*0.45
	end
	return self:GetStackCount()==2 and self.bonus_int or 0 
end

function modifier_item_hd_apex:Advanced_GetModifierBonusStats_Agility()	
	if self:GetStackCount()==DOTA_ATTRIBUTE_ALL  then
		return self.bonus_agi*0.45
	end
	return self:GetStackCount()==1 and self.bonus_agi or 0 
end
