
--------------------------------------------------------------------------------
modifier_Shop_first_N8 = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Shop_first_N8:IsHidden()
	if self:GetStackCount()>0 then
		return true
	end
	return false
end
function modifier_Shop_first_N8:IsDebuff()return false end
function modifier_Shop_first_N8:IsStunDebuff()return false end
function modifier_Shop_first_N8:IsPurgable()return false end
function modifier_Shop_first_N8:GetTexture() return "monkey_king/great_sages_reckoning/monkey_king_tree_jump" end
function modifier_Shop_first_N8:IsPurgeException() 	return false end
function modifier_Shop_first_N8:RemoveOnDeath() return false end

function modifier_Shop_first_N8:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷

		

	}
end

function modifier_Shop_first_N8:GetModifierBonusStats_Strength()	return 6 end
function modifier_Shop_first_N8:GetModifierBonusStats_Intellect()	return 6 end
function modifier_Shop_first_N8:GetModifierBonusStats_Agility()	return 6 end


function modifier_Shop_first_N8:OnCreated(keys)
	if IsServer() then
		print(keys.hide)
		self.hide = false
		if keys.hide==1 then
			self.hide=true
		end
		self:StartIntervalThink(3)
	end
end

function modifier_Shop_first_N8:OnIntervalThink()
	local parent = self:GetParent()
	local id = parent:GetPlayerID()+1
	local type = _G.GAME_SHOP_HIDDEN[id]
	if type=="1" or type==1 then
		self:SetStackCount(1)
	else
		self:SetStackCount(0)
	end
end

