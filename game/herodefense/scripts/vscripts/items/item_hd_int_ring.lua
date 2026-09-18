item_hd_int_ring = class({})

LinkLuaModifier("modifier_item_hd_int_ring", "items/item_hd_int_ring", LUA_MODIFIER_MOTION_NONE)

-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_int_ring:GetIntrinsicModifierName()
	return "modifier_item_hd_int_ring"
end


modifier_item_hd_int_ring = class({})

function modifier_item_hd_int_ring:IsDebuff() return false end
function modifier_item_hd_int_ring:IsHidden() return true end
function modifier_item_hd_int_ring:IsPurgable() return false end
function modifier_item_hd_int_ring:IsPurgeException() return false end
function modifier_item_hd_int_ring:RemoveOnDeath() return false end

function modifier_item_hd_int_ring:OnCreated(keys)

	self:StartIntervalThink(1)
	self.bonus_mana = math.min(self:GetParent():GetIntellect(false)*5,5000)
	self.bonus_base_attack = math.min(self:GetParent():GetIntellect(false)*0.3,200)
	if IsServer() then
		self.index =  self:GetAbility():GetSpecialValueFor("bonus_int")*0.01
		self.bonus_int = math.min(self:GetParent():GetBaseIntellect() *  self.index ,300)
		-- self:StartIntervalThink(1)
		-- self:CheckIteam()
	end
end
function modifier_item_hd_int_ring:OnIntervalThink(keys)
	
	self.bonus_mana = math.min(self:GetParent():GetIntellect(false)*5,5000)
	self.bonus_base_attack = math.min(self:GetParent():GetIntellect(false)*0.3,200)

	if IsServer() then
		self.primaryAttribute = self:GetParent():GetPrimaryAttribute()
		self.bonus_int = math.min(self:GetParent():GetBaseIntellect() *  self.index ,300)
		self:SetHasCustomTransmitterData( true )
	end
end

function modifier_item_hd_int_ring:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,       
		MODIFIER_PROPERTY_MANA_BONUS,  
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE
	}
end
function modifier_item_hd_int_ring:GetModifierBonusStats_Intellect()return self.bonus_int end
function modifier_item_hd_int_ring:GetModifierManaBonus()
	return self.bonus_mana
end

function modifier_item_hd_int_ring:GetModifierBaseAttack_BonusDamage()
	if self.primaryAttribute then
		if self.primaryAttribute==DOTA_ATTRIBUTE_INTELLECT  then
			return self.bonus_base_attack
		end
	end
end


function modifier_item_hd_int_ring:AddCustomTransmitterData( )
	return
	{
		primaryAttribute = self.primaryAttribute
	}
end

function modifier_item_hd_int_ring:HandleCustomTransmitterData( data )
	self.primaryAttribute = data.primaryAttribute
end