
--------------------------------------------------------------------------------
modifier_Shop_Athenas_blessing = class({})
-- require('internal/timers')   --计时器功能
--------------------------------------------------------------------------------
-- Classifications
function modifier_Shop_Athenas_blessing:IsHidden()
	if self:GetStackCount()>0 then
		return true
	end
	return false
end
function modifier_Shop_Athenas_blessing:IsDebuff()return false end
function modifier_Shop_Athenas_blessing:IsStunDebuff()return false end
function modifier_Shop_Athenas_blessing:IsPurgable()return false end
function modifier_Shop_Athenas_blessing:GetTexture() return "mirana/mirana_2021_immortal_ability_icon/mirana_2021_immortal_moonlight_shadow" end
function modifier_Shop_Athenas_blessing:IsPurgeException() 	return false end
function modifier_Shop_Athenas_blessing:RemoveOnDeath() return false end

function modifier_Shop_Athenas_blessing:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,       --移动速度百分比

	
		

	}
end




function modifier_Shop_Athenas_blessing:GetModifierMoveSpeedBonus_Percentage()	return 5 end




function modifier_Shop_Athenas_blessing:OnCreated(keys)
	if IsServer() then

		self.hide = false
		if keys.hide==1 then
			self.hide=true
		end
		self:StartIntervalThink(3)
	end
end

function modifier_Shop_Athenas_blessing:OnIntervalThink()
	local parent = self:GetParent()
	local id = parent:GetPlayerID()+1
	local type = _G.GAME_SHOP_HIDDEN[id]
	if type=="1" or type==1 then
		self:SetStackCount(1)
	else
		self:SetStackCount(0)
	end
end

