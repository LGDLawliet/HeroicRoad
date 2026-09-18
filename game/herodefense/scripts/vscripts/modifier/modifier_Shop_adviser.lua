
--------------------------------------------------------------------------------
modifier_Shop_adviser = class({})
-- require('internal/timers')   --计时器功能
--------------------------------------------------------------------------------
-- Classifications
function modifier_Shop_adviser:IsHidden()
	if self:GetStackCount()>0 then
		return true
	end
	return false
end
function modifier_Shop_adviser:IsDebuff()return false end
function modifier_Shop_adviser:IsStunDebuff()return false end
function modifier_Shop_adviser:IsPurgable()return false end
function modifier_Shop_adviser:GetTexture() return "tusk_walrus_punch" end
function modifier_Shop_adviser:IsPurgeException() 	return false end
function modifier_Shop_adviser:RemoveOnDeath() return false end

function modifier_Shop_adviser:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,         

		

	}
end


function modifier_Shop_adviser:GetModifierBonusStats_Intellect()   return 6 end

function modifier_Shop_adviser:OnCreated(keys)
	if IsServer() then

		self.hide = false
		if keys.hide==1 then
			self.hide=true
		end
		self:StartIntervalThink(3)
	end
end

function modifier_Shop_adviser:OnIntervalThink()
	local parent = self:GetParent()
	local id = parent:GetPlayerID()+1
	local type = _G.GAME_SHOP_HIDDEN[id]
	if type=="1" or type==1 then
		self:SetStackCount(1)
	else
		self:SetStackCount(0)
	end
end

