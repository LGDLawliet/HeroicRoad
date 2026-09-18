item_hd_mul_ring = class({})

LinkLuaModifier("modifier_item_hd_mul_ring", "items/item_hd_mul_ring", LUA_MODIFIER_MOTION_NONE)

-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_mul_ring:GetIntrinsicModifierName()
	return "modifier_item_hd_mul_ring"
end


modifier_item_hd_mul_ring = class({})

function modifier_item_hd_mul_ring:IsDebuff() return false end
function modifier_item_hd_mul_ring:IsHidden() return true end
function modifier_item_hd_mul_ring:IsPurgable() return false end
function modifier_item_hd_mul_ring:IsPurgeException() return false end
function modifier_item_hd_mul_ring:RemoveOnDeath() return false end

function modifier_item_hd_mul_ring:OnCreated(keys)
	self:StartIntervalThink(1)
	self.bonus_health = math.min(self:GetParent():GetStrength()*10,5000)
	self.bonus_mana = math.min(self:GetParent():GetIntellect(false)*6,8000)
	self.bonus_attack_speed = math.min(self:GetParent():GetAgility()*0.5,2000)

	if IsServer() then
		self.index =  self:GetAbility():GetSpecialValueFor("bonus_attrubute")*0.01
		self.bonus_str = math.min(self:GetParent():GetBaseAgility() *  self.index ,300)
		self.bonus_agi = math.min(self:GetParent():GetBaseAgility() *  self.index ,300)
		self.bonus_int = math.min(self:GetParent():GetBaseIntellect() *  self.index ,300)
		self:SetStackCount(math.min(self:GetParent():HDGetPrimaryStatValue()*0.4,200))
	end

end
function modifier_item_hd_mul_ring:OnIntervalThink(keys)
	self.bonus_health = math.min(self:GetParent():GetStrength()*10,5000)
	self.bonus_mana = math.min(self:GetParent():GetIntellect(false)*6,8000)
	self.bonus_attack_speed = math.min(self:GetParent():GetAgility()*0.5,2000)
	if IsServer() then
		self.bonus_str = math.min(self:GetParent():GetBaseAgility() *  self.index ,300)
		self.bonus_agi = math.min(self:GetParent():GetBaseAgility() *  self.index ,300)
		self.bonus_int = math.min(self:GetParent():GetBaseIntellect() *  self.index ,300)
		self:SetStackCount(math.min(self:GetParent():HDGetPrimaryStatValue()*0.4,200))
	end

end

function modifier_item_hd_mul_ring:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,        
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS ,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
end
function modifier_item_hd_mul_ring:GetModifierBonusStats_Agility()return self.bonus_agi end
function modifier_item_hd_mul_ring:GetModifierBonusStats_Strength()return self.bonus_str end
function modifier_item_hd_mul_ring:GetModifierBonusStats_Intellect()return self.bonus_int end


function modifier_item_hd_mul_ring:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attack_speed
end

function modifier_item_hd_mul_ring:GetModifierManaBonus()
	return self.bonus_mana
end
function modifier_item_hd_mul_ring:GetModifierHealthBonus()
	return self.bonus_health
end

function modifier_item_hd_mul_ring:GetModifierBaseAttack_BonusDamage()
	return self:GetStackCount()
end

