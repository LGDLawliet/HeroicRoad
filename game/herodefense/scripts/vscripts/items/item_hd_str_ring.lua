item_hd_str_ring = class({})

LinkLuaModifier("modifier_item_hd_str_ring", "items/item_hd_str_ring", LUA_MODIFIER_MOTION_NONE)

-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_str_ring:GetIntrinsicModifierName()
	return "modifier_item_hd_str_ring"
end

modifier_item_hd_str_ring = class({})

function modifier_item_hd_str_ring:IsDebuff() return false end
function modifier_item_hd_str_ring:IsHidden() return true end
function modifier_item_hd_str_ring:IsPurgable() return false end
function modifier_item_hd_str_ring:IsPurgeException() return false end
function modifier_item_hd_str_ring:RemoveOnDeath() return false end

function modifier_item_hd_str_ring:OnCreated(keys)
	self:StartIntervalThink(1)
	self.bonus_health = math.min(self:GetParent():GetStrength()*8,5000)
	self.bonus_base_attack = math.min(self:GetParent():GetStrength()*0.3,200)

	if IsServer() then
		self.index =  self:GetAbility():GetSpecialValueFor("bonus_str")*0.01
		self.bonus_str = math.min(self:GetParent():GetBaseStrength() *  self.index ,300)
		

		self.check = true
		self:CheckIteam()
	end
end
function modifier_item_hd_str_ring:OnIntervalThink(keys)
	self.bonus_health = math.min(self:GetParent():GetStrength()*8,5000)
	self.bonus_base_attack = math.min(self:GetParent():GetStrength()*0.3,200)
	if IsServer() then
		self.primaryAttribute = self:GetParent():GetPrimaryAttribute()
		self:SetHasCustomTransmitterData( true )
		self.bonus_str = math.min(self:GetParent():GetBaseStrength() *  self.index ,300)
		if not self.check then
			self.check = true
			self:CheckIteam()
		end
	end

	
end
function modifier_item_hd_str_ring:CheckIteam()
	local caster    =   self:GetParent()
	local agi_item,str_item,int_item
	for i = 0, 8, 1 do
		local current_item = caster:GetItemInSlot(i)
		if current_item then
			local name = current_item:GetAbilityName()
			if name=="item_hd_int_ring" then
				int_item = current_item
			elseif name=="item_hd_str_ring" then
				str_item = current_item
			elseif name=="item_hd_agi_ring" then
				agi_item = current_item
			end
		end
		
	end

	if int_item and str_item and agi_item then
		UTIL_RemoveImmediate(int_item) --removeitem的暂时替代
		UTIL_RemoveImmediate(str_item) --removeitem的暂时替代
		UTIL_RemoveImmediate(agi_item) --removeitem的暂时替代
		self:GetCaster():AddItemByName("item_hd_mul_ring")
	end
end
function modifier_item_hd_str_ring:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,   
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
		MODIFIER_PROPERTY_HEALTH_BONUS      
	}
end
function modifier_item_hd_str_ring:GetModifierBonusStats_Strength()return self.bonus_str end
function modifier_item_hd_str_ring:GetModifierHealthBonus()
	return self.bonus_health
end

function modifier_item_hd_str_ring:GetModifierBaseAttack_BonusDamage()
	if self.primaryAttribute then
		if self.primaryAttribute==DOTA_ATTRIBUTE_STRENGTH  then
			return self.bonus_base_attack
		end
	end
end


function modifier_item_hd_str_ring:AddCustomTransmitterData( )
	return
	{
		primaryAttribute = self.primaryAttribute
	}
end

function modifier_item_hd_str_ring:HandleCustomTransmitterData( data )
	self.primaryAttribute = data.primaryAttribute
end