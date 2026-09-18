
--------------------------------------------------------------------------------
modifier_Shop_Dove_of_peace = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Shop_Dove_of_peace:IsHidden()
	if self:GetStackCount()>0 then
		return true
	end
	return false
end
function modifier_Shop_Dove_of_peace:IsDebuff()return false end
function modifier_Shop_Dove_of_peace:IsStunDebuff()return false end
function modifier_Shop_Dove_of_peace:IsPurgable()return false end
function modifier_Shop_Dove_of_peace:GetTexture() return "beastmaster_hawk_invisibility" end
function modifier_Shop_Dove_of_peace:IsPurgeException() 	return false end
function modifier_Shop_Dove_of_peace:RemoveOnDeath() return false end

function modifier_Shop_Dove_of_peace:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷

		

	}
end

function modifier_Shop_Dove_of_peace:GetModifierBonusStats_Strength()	return 2 end
function modifier_Shop_Dove_of_peace:GetModifierBonusStats_Intellect()	return 2 end
function modifier_Shop_Dove_of_peace:GetModifierBonusStats_Agility()	return 2 end


function modifier_Shop_Dove_of_peace:OnCreated(keys)
	if IsServer() then
		print(keys.hide)
		self.hide = false
		if keys.hide==1 then
			self.hide=true
		end
		self:StartIntervalThink(3)
	end
end

function modifier_Shop_Dove_of_peace:OnIntervalThink()
	local parent = self:GetParent()
	local id = parent:GetPlayerID()+1
	local type = _G.GAME_SHOP_HIDDEN[id]
	if type=="1" or type==1 then
		self:SetStackCount(1)
	else
		self:SetStackCount(0)
	end
end

