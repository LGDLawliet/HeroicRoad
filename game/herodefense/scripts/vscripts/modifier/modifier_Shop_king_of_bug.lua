
--------------------------------------------------------------------------------
modifier_Shop_king_of_bug = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Shop_king_of_bug:IsHidden()
	if self:GetStackCount()>0 then
		return true
	end
	return false
end
function modifier_Shop_king_of_bug:IsDebuff()return false end
function modifier_Shop_king_of_bug:IsStunDebuff()return false end
function modifier_Shop_king_of_bug:IsPurgable()return false end
function modifier_Shop_king_of_bug:GetTexture() return "backdoor_protection_in_base" end
function modifier_Shop_king_of_bug:IsPurgeException() 	return false end
function modifier_Shop_king_of_bug:RemoveOnDeath() return false end

function modifier_Shop_king_of_bug:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷

		

	}
end

function modifier_Shop_king_of_bug:GetModifierBonusStats_Strength()	return 3 end
function modifier_Shop_king_of_bug:GetModifierBonusStats_Intellect()	return 3 end
function modifier_Shop_king_of_bug:GetModifierBonusStats_Agility()	return 3 end


function modifier_Shop_king_of_bug:OnCreated(keys)
	if IsServer() then
		self.hide = false
		if keys.hide==1 then
			self.hide=true
		end
		self:StartIntervalThink(3)
	end
end

function modifier_Shop_king_of_bug:OnIntervalThink()
	local parent = self:GetParent()
	local id = parent:GetPlayerID()+1
	local type = _G.GAME_SHOP_HIDDEN[id]
	if type=="1" or type==1 then
		self:SetStackCount(1)
	else
		self:SetStackCount(0)
	end
end

