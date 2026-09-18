
--------------------------------------------------------------------------------
modifier_Shop_Novice_tutor = advanced_modifier({})
-- require('internal/timers')   --计时器功能
--------------------------------------------------------------------------------
-- Classifications
function modifier_Shop_Novice_tutor:IsHidden()
	if self:GetStackCount()>0 then
		return true
	end
	return false
end
function modifier_Shop_Novice_tutor:IsDebuff()return false end
function modifier_Shop_Novice_tutor:IsStunDebuff()return false end
function modifier_Shop_Novice_tutor:IsPurgable()return false end
function modifier_Shop_Novice_tutor:GetTexture() return "keeper_of_the_light_recall" end
function modifier_Shop_Novice_tutor:IsPurgeException() 	return false end
function modifier_Shop_Novice_tutor:RemoveOnDeath() return false end

function modifier_Shop_Novice_tutor:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,         --魔法抗性
	}
end


function modifier_Shop_Novice_tutor:GetModifierMagicalResistanceBonus() return 5 end


function modifier_Shop_Novice_tutor:OnCreated(keys)
	if IsServer() then
		print(keys.hide)
		self.hide = false
		if keys.hide==1 then
			self.hide=true
		end
		self:StartIntervalThink(3)
	end
end

function modifier_Shop_Novice_tutor:OnIntervalThink()
	local parent = self:GetParent()
	local id = parent:GetPlayerID()+1
	local type = _G.GAME_SHOP_HIDDEN[id]
	if type=="1" or type==1 then
		self:SetStackCount(1)
	else
		self:SetStackCount(0)
	end
end


function modifier_Shop_Novice_tutor:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_Shop_Novice_tutor:Advanced_GetModifierPhysicalArmorBonus()
    return 2
end