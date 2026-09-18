item_hd_slave_owners_flame_whip = class({})
LinkLuaModifier("modifier_item_hd_slave_owners_flame_whip_loan", "items/item_hd_slave_owners_flame_whip", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_slave_owners_flame_whip_loan_finish", "items/item_hd_slave_owners_flame_whip", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_slave_owners_flame_whip", "items/item_hd_slave_owners_flame_whip", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_slave_owners_flame_whip_loan_future", "items/item_hd_slave_owners_flame_whip", LUA_MODIFIER_MOTION_NONE)

function item_hd_slave_owners_flame_whip:GetIntrinsicModifierName()
	return "modifier_item_hd_slave_owners_flame_whip"
end

function item_hd_slave_owners_flame_whip:OnSpellStart()
	if IsServer() then
		local gold = self:GetSpecialValueFor("gold")
		self:GetCaster():ModifyGoldFiltered(gold,true,DOTA_ModifyGold_AbilityGold)
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_hd_slave_owners_flame_whip_loan", {})
		self:StartCooldown(9999)
	end
end
------------------------------------------------------------------
modifier_item_hd_slave_owners_flame_whip = advanced_modifier({})

function modifier_item_hd_slave_owners_flame_whip:IsDebuff() return false end
function modifier_item_hd_slave_owners_flame_whip:IsHidden() return true end
function modifier_item_hd_slave_owners_flame_whip:IsPurgable() return false end

function modifier_item_hd_slave_owners_flame_whip:OnCreated(keys)
    self.ability = self:GetAbility()
	self.bonus_move = self.ability:GetSpecialValueFor("bonus_move")
	
end

function modifier_item_hd_slave_owners_flame_whip:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,       --移动速度百分比
	}
end
function modifier_item_hd_slave_owners_flame_whip:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_Wave_End = {},
	}
end
function modifier_item_hd_slave_owners_flame_whip:OnWaveEnd()	
	if self:GetAbility()~=nil then
		self:GetAbility():EndCooldown()
	end
end
function modifier_item_hd_slave_owners_flame_whip:GetModifierMoveSpeedBonus_Percentage()	return self.bonus_move end
------------------------------------------------------------------



modifier_item_hd_slave_owners_flame_whip_loan = advanced_modifier({})

function modifier_item_hd_slave_owners_flame_whip_loan:IsDebuff() return true end
function modifier_item_hd_slave_owners_flame_whip_loan:IsHidden() return false end
function modifier_item_hd_slave_owners_flame_whip_loan:IsPurgable() return false end
function modifier_item_hd_slave_owners_flame_whip_loan:RemoveOnDeath() return false end
function modifier_item_hd_slave_owners_flame_whip_loan:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_item_hd_slave_owners_flame_whip_loan:GetTexture()return "item_slave_owners_flame_whip" end

function modifier_item_hd_slave_owners_flame_whip_loan:OnCreated()
	self:SetStackCount(self:GetAbility():GetSpecialValueFor("gold"))
end

function modifier_item_hd_slave_owners_flame_whip_loan:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_Wave_End = {},
	}
end

function modifier_item_hd_slave_owners_flame_whip_loan:OnWaveEnd()	
	if not IsServer() then
		return
	end
	if self:GetStackCount() <= 0 then
		self:SafeDestroy()
		return
	end
	local now_gold = self:GetParent():GetGold()--现有
	local gold_back = self:GetAbility():GetSpecialValueFor("gold_back")--应还
	if now_gold >= gold_back then--余额充足，可以还款
		self:GetParent():ModifyGoldFiltered(-gold_back,true,DOTA_ModifyGold_AbilityGold)
		self:SetStackCount(self:GetStackCount()-gold_back*0.75)
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_hd_slave_owners_flame_whip_loan_finish", {})
		if self:GetStackCount() <= 0 then
			self:SafeDestroy()
		end
	else--余额不足，进入逾期
		self:GetParent():ModifyGoldFiltered(-now_gold,true,DOTA_ModifyGold_AbilityGold)
		local future_gold = gold_back - now_gold--逾期
		self:SetStackCount(self:GetStackCount()-gold_back*0.75)
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_hd_slave_owners_flame_whip_loan_future", {stack = future_gold})
		self:GetParent():RemoveModifierByName("modifier_item_hd_slave_owners_flame_whip_loan_finish")
		if self:GetStackCount() <= 0 then
			self:SafeDestroy()
		end
	end
end

------------------------------------
modifier_item_hd_slave_owners_flame_whip_loan_finish = advanced_modifier({})

function modifier_item_hd_slave_owners_flame_whip_loan_finish:IsDebuff() return false end
function modifier_item_hd_slave_owners_flame_whip_loan_finish:IsHidden() return false end
function modifier_item_hd_slave_owners_flame_whip_loan_finish:IsPurgable() return false end
function modifier_item_hd_slave_owners_flame_whip_loan_finish:RemoveOnDeath() return false end
function modifier_item_hd_slave_owners_flame_whip_loan_finish:GetTexture()return "item_slave_owners_flame_whip" end
function modifier_item_hd_slave_owners_flame_whip_loan_finish:OnCreated()
	self.atb = self:GetAbility():GetSpecialValueFor("bonus_atb")
	self.atb_max = self:GetAbility():GetSpecialValueFor("atb_max")
end
function modifier_item_hd_slave_owners_flame_whip_loan_finish:OnRefresh()
	self.atb = self:GetAbility():GetSpecialValueFor("bonus_atb")
	self.atb_max = self:GetAbility():GetSpecialValueFor("atb_max")
	self:SetStackCount(math.min(self:GetStackCount() + 1,10))
end

function modifier_item_hd_slave_owners_flame_whip_loan_finish:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	}
end

function modifier_item_hd_slave_owners_flame_whip_loan_finish:Advanced_GetModifierBonusStats_Strength()
	local bonus = math.max(0,(self:GetStackCount()-1)*self.atb)
	local atb = self.atb + bonus
	return atb
end
function modifier_item_hd_slave_owners_flame_whip_loan_finish:Advanced_GetModifierBonusStats_Agility()
	local bonus = math.max(0,(self:GetStackCount()-1)*self.atb)
	local atb = self.atb + bonus
	return atb
end
function modifier_item_hd_slave_owners_flame_whip_loan_finish:Advanced_GetModifierBonusStats_Intellect()
	local bonus = math.max(0,(self:GetStackCount()-1)*self.atb)
	local atb = self.atb + bonus
	return atb
end

------------------------------------
modifier_item_hd_slave_owners_flame_whip_loan_future = advanced_modifier({})

function modifier_item_hd_slave_owners_flame_whip_loan_future:IsDebuff() return true end
function modifier_item_hd_slave_owners_flame_whip_loan_future:IsHidden() return false end
function modifier_item_hd_slave_owners_flame_whip_loan_future:IsPurgable() return false end
function modifier_item_hd_slave_owners_flame_whip_loan_future:RemoveOnDeath() return false end
function modifier_item_hd_slave_owners_flame_whip_loan_future:GetTexture()return "item_slave_owners_flame_whip" end
function modifier_item_hd_slave_owners_flame_whip_loan_future:OnCreated(keys)
	if IsServer() then
		self:StartIntervalThink(0.1)
		self:SetStackCount(keys.stack)
	end
	
end
function modifier_item_hd_slave_owners_flame_whip_loan_future:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(self:GetStackCount() + keys.stack)
	end
end

function modifier_item_hd_slave_owners_flame_whip_loan_future:OnIntervalThink()
	if not IsServer() then
		return
	end
	if self:GetStackCount() <= 0 then
		self:SafeDestroy()
		return
	end
	local now_gold_f = self:GetParent():GetGold()--现有
	local gold_back_f = self:GetStackCount()--应还
	if now_gold_f >= gold_back_f then--余额充足，可以还款
		self:GetParent():ModifyGoldFiltered(-gold_back_f,true,DOTA_ModifyGold_PurchaseItem)
		self:SetStackCount(self:GetStackCount()-gold_back_f)
		if self:GetStackCount() <= 0 then
			self:SafeDestroy()
		end
	else
		self:GetParent():ModifyGoldFiltered(-now_gold_f,true,DOTA_ModifyGold_PurchaseItem  )
		self:SetStackCount(self:GetStackCount()-now_gold_f)
	end
end

function modifier_item_hd_slave_owners_flame_whip_loan_future:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_Wave_Start = {},
	}
end

function modifier_item_hd_slave_owners_flame_whip_loan_future:OnWaveStart()
	if not IsServer() then
		return
	end
	if self:GetStackCount() > 0 then
		TrueKill(self:GetCaster(),self:GetParent(),self:GetAbility())
	end
end
