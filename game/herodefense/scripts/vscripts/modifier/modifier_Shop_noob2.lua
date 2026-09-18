
--------------------------------------------------------------------------------
modifier_Shop_noob2 = class({})
-- require('internal/timers')   --计时器功能
--------------------------------------------------------------------------------
-- Classifications
function modifier_Shop_noob2:IsHidden()
	if self:GetStackCount()>0 then
		return true
	end
	return false
end
function modifier_Shop_noob2:IsDebuff()return false end
function modifier_Shop_noob2:IsStunDebuff()return false end
function modifier_Shop_noob2:IsPurgable()return false end
function modifier_Shop_noob2:GetTexture() return "invoker_exort_persona1" end
function modifier_Shop_noob2:IsPurgeException() 	return false end
function modifier_Shop_noob2:RemoveOnDeath() return false end

function modifier_Shop_noob2:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷

		

	}
end


function modifier_Shop_noob2:GetModifierBonusStats_Strength()	return 7 end
function modifier_Shop_noob2:GetModifierBonusStats_Intellect()	return 7 end
function modifier_Shop_noob2:GetModifierBonusStats_Agility()	return 7 end

function modifier_Shop_noob2:OnCreated(keys)
	if IsServer() then
		print(keys.hide)
		self.hide = false
		if keys.hide==1 then
			self.hide=true
		end
		self:StartIntervalThink(3)
	end
end

function modifier_Shop_noob2:OnIntervalThink()
	local parent = self:GetParent()
	local id = parent:GetPlayerID()+1
	local type = _G.GAME_SHOP_HIDDEN[id]
	if type=="1" or type==1 then
		self:SetStackCount(1)
	else
		self:SetStackCount(0)
	end
end

