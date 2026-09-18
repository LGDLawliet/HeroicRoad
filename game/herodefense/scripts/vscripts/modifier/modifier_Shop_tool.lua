
--------------------------------------------------------------------------------
modifier_Shop_tool = class({})
-- require('internal/timers')   --计时器功能
--------------------------------------------------------------------------------
-- Classifications
function modifier_Shop_tool:IsHidden()
	if self:GetStackCount()>0 then
		return true
	end
	return false
end
function modifier_Shop_tool:IsDebuff()return false end
function modifier_Shop_tool:IsStunDebuff()return false end
function modifier_Shop_tool:IsPurgable()return false end
function modifier_Shop_tool:GetTexture() return "tusk_walrus_punch" end
function modifier_Shop_tool:IsPurgeException() 	return false end
function modifier_Shop_tool:RemoveOnDeath() return false end

function modifier_Shop_tool:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,       --攻击速度
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,       --移动速度百分比

	
		

	}
end



function modifier_Shop_tool:GetModifierAttackSpeedBonus_Constant()	return 15 end
function modifier_Shop_tool:GetModifierMoveSpeedBonus_Percentage()	return 3 end




function modifier_Shop_tool:OnCreated(keys)
	if IsServer() then

		self.hide = false
		if keys.hide==1 then
			self.hide=true
		end
		self:StartIntervalThink(3)
	end
end

function modifier_Shop_tool:OnIntervalThink()
	local parent = self:GetParent()
	local id = parent:GetPlayerID()+1
	local type = _G.GAME_SHOP_HIDDEN[id]
	if type=="1" or type==1 then
		self:SetStackCount(1)
	else
		self:SetStackCount(0)
	end
end

