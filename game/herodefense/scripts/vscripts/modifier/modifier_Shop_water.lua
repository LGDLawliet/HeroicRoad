
--------------------------------------------------------------------------------
modifier_Shop_water = class({})
-- require('internal/timers')   --计时器功能
--------------------------------------------------------------------------------
-- Classifications
function modifier_Shop_water:IsHidden()
	if self:GetStackCount()>0 then
		return true
	end
	return false
end
function modifier_Shop_water:IsDebuff()return false end
function modifier_Shop_water:IsStunDebuff()return false end
function modifier_Shop_water:IsPurgable()return false end
function modifier_Shop_water:GetTexture() return "naga_siren/naga_2021_immortal_ability_icon/naga_2021_immortal_song_of_the_siren" end
function modifier_Shop_water:IsPurgeException() 	return false end
function modifier_Shop_water:RemoveOnDeath() return false end

function modifier_Shop_water:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,            --生命基础恢复

		

	}
end


function modifier_Shop_water:GetModifierConstantManaRegen()   return 1 end

function modifier_Shop_water:OnCreated(keys)
	if IsServer() then
		print(keys.hide)
		self.hide = false
		if keys.hide==1 then
			self.hide=true
		end
		self:StartIntervalThink(3)
	end
end

function modifier_Shop_water:OnIntervalThink()
	local parent = self:GetParent()
	local id = parent:GetPlayerID()+1
	local type = _G.GAME_SHOP_HIDDEN[id]
	if type=="1" or type==1 then
		self:SetStackCount(1)
	else
		self:SetStackCount(0)
	end
end

