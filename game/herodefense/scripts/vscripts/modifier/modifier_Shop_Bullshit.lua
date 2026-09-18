
--------------------------------------------------------------------------------
modifier_Shop_Bullshit = class({})
-- require('internal/timers')   --计时器功能
--------------------------------------------------------------------------------
-- Classifications
function modifier_Shop_Bullshit:IsHidden()
	if self:GetStackCount()>0 then
		return true
	end
	return false
end
function modifier_Shop_Bullshit:IsDebuff()return false end
function modifier_Shop_Bullshit:IsStunDebuff()return false end
function modifier_Shop_Bullshit:IsPurgable()return false end
function modifier_Shop_Bullshit:GetTexture() return "naga_siren_song_of_the_siren" end
function modifier_Shop_Bullshit:IsPurgeException() 	return false end
function modifier_Shop_Bullshit:RemoveOnDeath() return false end

function modifier_Shop_Bullshit:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,            --生命基础恢复

		

	}
end


function modifier_Shop_Bullshit:GetModifierConstantManaRegen()   return 1 end

function modifier_Shop_Bullshit:OnCreated(keys)
	if IsServer() then
		print(keys.hide)
		self.hide = false
		if keys.hide==1 then
			self.hide=true
		end
		self:StartIntervalThink(3)
	end
end

function modifier_Shop_Bullshit:OnIntervalThink()
	local parent = self:GetParent()
	local id = parent:GetPlayerID()+1
	local type = _G.GAME_SHOP_HIDDEN[id]
	if type=="1" or type==1 then
		self:SetStackCount(1)
	else
		self:SetStackCount(0)
	end
end

