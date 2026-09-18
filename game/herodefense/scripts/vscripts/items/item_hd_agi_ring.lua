item_hd_agi_ring = class({})

LinkLuaModifier("modifier_item_hd_agi_ring", "items/item_hd_agi_ring", LUA_MODIFIER_MOTION_NONE)

-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_agi_ring:GetIntrinsicModifierName()
	return "modifier_item_hd_agi_ring"
end


modifier_item_hd_agi_ring = class({})

function modifier_item_hd_agi_ring:IsDebuff() return false end
function modifier_item_hd_agi_ring:IsHidden() return true end
function modifier_item_hd_agi_ring:IsPurgable() return false end
function modifier_item_hd_agi_ring:IsPurgeException() return false end
function modifier_item_hd_agi_ring:RemoveOnDeath() return false end

function modifier_item_hd_agi_ring:OnCreated(keys)

	self:StartIntervalThink(1)
	self.bonus_attack_speed = math.min(self:GetParent():GetAgility()*0.4,2000)
	self.bonus_base_attack = math.min(self:GetParent():GetAgility()*0.3,200)

	if IsServer() then
		self.index =  self:GetAbility():GetSpecialValueFor("bonus_agi")*0.01
		self.bonus_agi = math.min(self:GetParent():GetBaseAgility() *  self.index ,300)
		self.primaryAttribute = self:GetParent():GetPrimaryAttribute()
		-- self:CheckIteam()
	end
end
function modifier_item_hd_agi_ring:OnIntervalThink(keys)
	self.bonus_attack_speed = math.min(self:GetParent():GetAgility()*0.4,2000)
	self.bonus_base_attack = math.min(self:GetParent():GetAgility()*0.3,200)

	if IsServer() then
		self.primaryAttribute = self:GetParent():GetPrimaryAttribute()
		self.bonus_agi = math.min(self:GetParent():GetBaseAgility() *  self.index ,300)
		self:SetHasCustomTransmitterData( true )
	end
end

function modifier_item_hd_agi_ring:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,     
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE
	}
end
function modifier_item_hd_agi_ring:GetModifierBonusStats_Agility()return self.bonus_agi end
function modifier_item_hd_agi_ring:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attack_speed
end

function modifier_item_hd_agi_ring:GetModifierBaseAttack_BonusDamage()
	if self.primaryAttribute then
		if self.primaryAttribute==DOTA_ATTRIBUTE_AGILITY  then
			return self.bonus_base_attack
		end
	end
end


function modifier_item_hd_agi_ring:AddCustomTransmitterData( )
	return
	{
		primaryAttribute = self.primaryAttribute
	}
end

function modifier_item_hd_agi_ring:HandleCustomTransmitterData( data )
	self.primaryAttribute = data.primaryAttribute
end