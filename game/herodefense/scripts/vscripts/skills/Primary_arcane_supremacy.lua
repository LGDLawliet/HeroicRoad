LinkLuaModifier( "modifier_Primary_arcane_supremacy", "skills/Primary_arcane_supremacy", LUA_MODIFIER_MOTION_NONE )

Primary_arcane_supremacy = class({})

function Primary_arcane_supremacy:GetIntrinsicModifierName()
	return "modifier_Primary_arcane_supremacy"
end
---------------------------------------------------------------------


modifier_Primary_arcane_supremacy = advanced_modifier({})
function modifier_Primary_arcane_supremacy:IsDebuff() return false end
function modifier_Primary_arcane_supremacy:IsHidden() return true end
function modifier_Primary_arcane_supremacy:IsPurgable() return false end

function modifier_Primary_arcane_supremacy:OnCreated(params)
	local parent = self:GetParent()
	self.bonus_pri = self:GetAbility():GetSpecialValueFor("bonus_pri")

	if IsServer() then
		self:SetStackCount(parent:GetPrimaryAttribute())
		self:SetHasCustomTransmitterData( true )-- 同步cy
	end
end
function modifier_Primary_arcane_supremacy:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
	}
end
function modifier_Primary_arcane_supremacy:Advanced_GetModifierBonusStats_Strength()
	self.bonus_pri = self:GetAbility():GetSpecialValueFor("bonus_pri")	
	if self:GetStackCount()==DOTA_ATTRIBUTE_ALL  then
		return self.bonus_pri*0.3
	end
	return self:GetStackCount()==0 and self.bonus_pri or 0 
end
function modifier_Primary_arcane_supremacy:Advanced_GetModifierBonusStats_Intellect()	
	self.bonus_pri = self:GetAbility():GetSpecialValueFor("bonus_pri")
	if self:GetStackCount()==DOTA_ATTRIBUTE_ALL  then
		return self.bonus_pri*0.3
	end
	return self:GetStackCount()==2 and self.bonus_pri or 0 
end

function modifier_Primary_arcane_supremacy:Advanced_GetModifierBonusStats_Agility()	
	self.bonus_pri = self:GetAbility():GetSpecialValueFor("bonus_pri")
	if self:GetStackCount()==DOTA_ATTRIBUTE_ALL  then
		return self.bonus_pri*0.3
	end
	return self:GetStackCount()==1 and self.bonus_pri or 0 
end

function modifier_Primary_arcane_supremacy:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)
	if not IsServer() then return end
	local attacker = keys.attacker
	local target = keys.target

	if keys.attacker ~= self:GetParent() then--是自己打的
		return
	end
	if target:GetTeamNumber() ~= attacker:GetTeamNumber() then--打的是敌人
		return
	end
	if keys.damage_category~= DOTA_DAMAGE_CATEGORY_SPELL then--用的技能伤害
		return 
	end
	if Cannotcrit(keys) then--不是不能暴击的那种
		return
	end

	if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS ) == DOTA_DAMAGE_FLAG_HPLOSS then return 0 end--不是生命流失
	if bit.band( keys.damage_flags, DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT ) == DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT then return 0 end--不是无任何追加
	
	self.chance = self:GetAbility():GetSpecialValueFor("chance")
	self.crit = self:GetAbility():GetSpecialValueFor("crit")-100

	local random = math.random
	if self.chance >= random(1,100) then
		return self.crit
	end
	return 0
end


function modifier_Primary_arcane_supremacy:AddCustomTransmitterData( )
	return
	{
		bonus_pri = self.bonus_pri,
	}
end

function modifier_Primary_arcane_supremacy:HandleCustomTransmitterData( data )
	self.bonus_pri = data.bonus_pri

end
