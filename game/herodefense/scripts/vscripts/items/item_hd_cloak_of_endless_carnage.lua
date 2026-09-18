item_hd_cloak_of_endless_carnage = class({})

LinkLuaModifier("modifier_item_hd_cloak_of_endless_carnage", "items/item_hd_cloak_of_endless_carnage", LUA_MODIFIER_MOTION_NONE)

-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_cloak_of_endless_carnage:GetIntrinsicModifierName()
	return "modifier_item_hd_cloak_of_endless_carnage"
end


modifier_item_hd_cloak_of_endless_carnage = advanced_modifier({})

function modifier_item_hd_cloak_of_endless_carnage:IsDebuff() return false end
function modifier_item_hd_cloak_of_endless_carnage:IsHidden() return false end
function modifier_item_hd_cloak_of_endless_carnage:IsPurgable() return false end
function modifier_item_hd_cloak_of_endless_carnage:IsPurgeException() return false end
function modifier_item_hd_cloak_of_endless_carnage:RemoveOnDeath() return false end
function modifier_item_hd_cloak_of_endless_carnage:DestroyOnExpire() return false end
function modifier_item_hd_cloak_of_endless_carnage:OnCreated(keys)
	self.bonus_int =  self:GetAbility():GetSpecialValueFor("bonus_int")
	self.bonus_spell_amp =  self:GetAbility():GetSpecialValueFor("bonus_spell_amp")

	if IsServer() then
	
		-- self:CheckIteam()
		self:StartIntervalThink(0.5)
	end
end
function modifier_item_hd_cloak_of_endless_carnage:OnIntervalThink()
	if self:GetRemainingTime()<=0 then
		self:SetStackCount(0)
	end
end
function modifier_item_hd_cloak_of_endless_carnage:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,        
		MODIFIER_EVENT_ON_RESPAWN ,
	}
end
function modifier_item_hd_cloak_of_endless_carnage:GetModifierBonusStats_Intellect()return self.bonus_int+self:GetStackCount()*10 end
function modifier_item_hd_cloak_of_endless_carnage:Advanced_GetModifierSpellAmplifyBonus()return self.bonus_spell_amp end
function modifier_item_hd_cloak_of_endless_carnage:OnRespawn(keys)
	if IsServer() then
		if keys.unit==self:GetParent() then
			self:SetStackCount(math.min(self:GetStackCount()+1,10))
			self:SetDuration(180, true)
		end
	end
end



function modifier_item_hd_cloak_of_endless_carnage:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_BUY_BACK_TIME_REDUCTION_Target,
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
    }
end
function modifier_item_hd_cloak_of_endless_carnage:Advanced_GetBuyBackTimeReduction_Target()
	return 5
end



